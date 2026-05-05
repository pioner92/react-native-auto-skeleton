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
  private var transitionGeneration = 0
  private var appliedLoadingState: Bool?
  private let hiddenViews = NSMapTable<UIView, NSNumber>(
    keyOptions: .weakMemory,
    valueOptions: .strongMemory
  )

  public var isLoading: Bool = false {
    didSet {
      guard Thread.isMainThread else {
        DispatchQueue.main.async { [weak self] in
          self?.applyLoadingState()
        }
        return
      }

      applyLoadingState()
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
    self.animator.duration = animationSpeed

    if(isLoading){
      self.animator.start()
    }
  }

  public func initOriginalViews(subviews: [UIView]) {
    views.removeAll()

    views = subviews.filter {
      if $0.accessibilityIdentifier == Constants.IGNORE_VIEW_NAME || ($0 is SkeletonCore) {
        return false
      }

      if hasBGColor($0) {
        return true
      }

      let className = String(describing: type(of: $0))

      if RCT_COMPONENTS_SET.contains(className) {
        return true
      }
      return false
    }

    if isLoading {
      hideOriginalViewsForSkeleton()
      placeholderMask.applyMask()
    }
  }

  private func hideOriginalViewsForSkeleton() {
    views.forEach {
      if hiddenViews.object(forKey: $0) == nil {
        hiddenViews.setObject(NSNumber(value: $0.isHidden), forKey: $0)
      }

      $0.isHidden = true
    }
  }

  private func restoreOriginalViews() {
    let enumerator = hiddenViews.keyEnumerator()

    while let view = enumerator.nextObject() as? UIView {
      let wasHidden = hiddenViews.object(forKey: view)?.boolValue ?? false
      view.isHidden = wasHidden
    }

    hiddenViews.removeAllObjects()
  }

  private func applyLoadingState() {
    guard appliedLoadingState != isLoading else { return }

    transitionGeneration += 1
    let generation = transitionGeneration
    appliedLoadingState = isLoading

    layer.removeAllAnimations()
    mainLayer.removeAllAnimations()
    animator.stop()

    if isLoading {
      showPlaceholder(generation: generation)
    } else {
      hidePlaceholder(generation: generation)
    }
  }

  func showPlaceholder() {
    transitionGeneration += 1
    appliedLoadingState = true
    showPlaceholder(generation: transitionGeneration)
  }

  private func showPlaceholder(generation: Int) {
    guard isLoading, generation == transitionGeneration else { return }

    mainLayer.isHidden = false
    placeholderMask.applyMask()

    UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve, .beginFromCurrentState, .allowUserInteraction], animations: {
      guard self.isLoading, generation == self.transitionGeneration else { return }
      self.hideOriginalViewsForSkeleton()
    }, completion: { _ in
      guard self.isLoading, generation == self.transitionGeneration else { return }
      self.animator.start()
    })
  }

  func hidePlaceholder() {
    transitionGeneration += 1
    appliedLoadingState = false
    hidePlaceholder(generation: transitionGeneration, force: true)
  }

  private func hidePlaceholder(generation: Int, force: Bool = false) {
    guard (!isLoading || force), generation == transitionGeneration else { return }

    UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve, .beginFromCurrentState, .allowUserInteraction], animations: {
      guard (!self.isLoading || force), generation == self.transitionGeneration else { return }
      self.mainLayer.isHidden = true
      self.restoreOriginalViews()
    }, completion: { _ in
      guard (!self.isLoading || force), generation == self.transitionGeneration else { return }
      self.animator.stop()
    })
  }

  @inline(__always)
  private func hasBGColor(_ view: UIView) -> Bool {
    return view.backgroundColor != nil && view.backgroundColor != .clear
  }
}
