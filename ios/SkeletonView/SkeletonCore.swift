//
//  SkeletonView.swift
//  intch_application
//
//  Created by Oleksandr Shumihin on 21/3/25.
//  Copyright © 2025 Facebook. All rights reserved.
//

import Foundation
import UIKit

let DEFAULT_GRADIENT_COLORS: [UIColor] = [UIColor.lightGray, UIColor.white]
let DEFAULT_BG_COLOR = UIColor.lightGray

enum AnimationTypes:String {
  case gradient
  case pulse
  case none
}

@objcMembers
public class SkeletonCore: UIView, PlaceholderMaskDelegate, SkeletonAnimatableDelegate {
  var mainLayer = CAShapeLayer()
  var views: [UIView] = []

  private let placeholderMask = SkeletonPlaceholderMask()

  private var animator: SkeletonAnimatable = AnimationGradient()

  public var isLoading: Bool = false {
    didSet {
      DispatchQueue.main.async {
        self.isLoading ? self.showPlaceholder() : self.hidePlaceholder()
      }
    }
  }

  public var shapesBackgroundColor: UIColor = DEFAULT_BG_COLOR {
    didSet {
      mainLayer.backgroundColor = shapesBackgroundColor.cgColor
    }
  }

  public var gradientColors: [UIColor] = DEFAULT_GRADIENT_COLORS {
    didSet {
      guard let animator = animator as? AnimationGradient else { return }
      animator.restart()
    }
  }

  public var animationSpeed: TimeInterval = 1.0 {
    didSet {
      animator.duration = animationSpeed
    }
  }

  public var defaultCorderRadius = 4.0 {
    didSet {
      placeholderMask.defaultBorderRadius = defaultCorderRadius
    }
  }

  public var animationType: String = AnimationTypes.gradient.rawValue {
    didSet {
      guard let type = AnimationTypes(rawValue: animationType) else {
        setAnimatorByAnimationType(type: AnimationTypes.gradient)
        return
      }

      setAnimatorByAnimationType(type: type)
    }
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  func commonInit(){
    layer.addSublayer(mainLayer)
    mainLayer.isHidden = true
    placeholderMask.delegate = self
    animator.delegate = self
  }

  override public func didMoveToWindow() {
    super.didMoveToWindow()
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    mainLayer.frame = bounds

    animator.updateBounds(bounds: bounds)
  }


  private func setAnimatorByAnimationType(type:AnimationTypes) {
    switch type {
      case .gradient:
        setAnimator(AnimationGradient())
        break
      case .pulse:
        setAnimator(AnimationPulse())
        break
      case .none:
        setAnimator(AnimationNone())
        break
    }
  }

  private func setAnimator(_ animator: SkeletonAnimatable) {
    self.animator.stop()
    self.animator = animator
    self.animator.delegate = self

    if(isLoading){
      self.animator.start()
    }
  }

  public func initOriginalViews(subviews: [UIView]) {
    views.removeAll()

    views = subviews.filter {
      if $0.accessibilityIdentifier == Constants.IGNORE_VIEW_NAME {
        return false
      }

      if $0.backgroundColor != nil && $0.backgroundColor != .clear && !($0 is SkeletonCore) {
        return true
      }

      let className = String(describing: type(of: $0))

      if RCT_COMPONENTS_SET.contains(className) {
        return true
      }
      return false
    }
  }

  func showPlaceholder() {
    mainLayer.isHidden = false
    placeholderMask.applyMask()

    UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve], animations: {
      self.views.forEach { $0.isHidden = true }
    }, completion: { _ in
      self.animator.start()
    })
  }

  func hidePlaceholder() {
    UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve], animations: {
      self.mainLayer.isHidden = true
      self.views.forEach { $0.isHidden = false }
    }, completion: { _ in
      self.animator.stop()
    })
  }
}
