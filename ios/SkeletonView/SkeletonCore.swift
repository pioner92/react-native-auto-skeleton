//
//  SkeletonView.swift
//  intch_application
//
//  Created by Oleksandr Shumihin on 21/3/25.
//  Copyright © 2025 Facebook. All rights reserved.
//

import Foundation
import UIKit

@objcMembers
public class SkeletonCore: UIView {
  public var isLoading: Bool = false {
    didSet {
      isLoading ? showPlaceholder() : hidePlaceholder()
    }
  }

  public var shimmerBackgroundColors: [UIColor]? {
    didSet {
      updateGradientColors()
    }
  }

  public var animationSpeed: TimeInterval = 1.0

  open var originalViews: [UIView] = []
  public var defaultCorderRadius = 4.0

  final public let gradientLayer: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()

    gradientLayer.colors = [
      UIColor.white.withAlphaComponent(0).cgColor,
      UIColor.white.withAlphaComponent(1).cgColor,
      UIColor.white.withAlphaComponent(0).cgColor,
    ]
    gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
    gradientLayer.locations = [0, 0.5, 1]
    return gradientLayer
  }()

  override public init(frame: CGRect) {
    super.init(frame: frame)
    layer.addSublayer(gradientLayer)
    gradientLayer.isHidden = true
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    layer.addSublayer(gradientLayer)
    gradientLayer.isHidden = true
  }

  override public func didMoveToWindow() {
    super.didMoveToWindow()
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = bounds
  }

  open func initOriginalViews(views: [UIView]) {
    originalViews.removeAll()
    originalViews = views.filter {
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

  /// Updates the gradientLayer’s colors based on shimmerBackgroundColors.
  private func updateGradientColors() {
    // If the user provides exactly 2 colors, create a gradient with them.
    // Here we create a “shimmer” effect by having a transparent version of the first color at the start and end.
    if let colors = shimmerBackgroundColors, colors.count == 2 {
      gradientLayer.colors = [
        colors[0].withAlphaComponent(0).cgColor,
        colors[1].withAlphaComponent(1).cgColor,
        colors[0].withAlphaComponent(0).cgColor,
      ]
    } else {
      // Fallback to the default white gradient.
      gradientLayer.colors = [
        UIColor.white.withAlphaComponent(0).cgColor,
        UIColor.white.withAlphaComponent(1).cgColor,
        UIColor.white.withAlphaComponent(0).cgColor,
      ]
    }
  }

  open func showPlaceholder() {
    self.gradientLayer.isHidden = false
    applyMask()
    UIView.transition(
      with: self, duration: 0.2, options: [.transitionCrossDissolve],
      animations: {
        self.originalViews.forEach { $0.isHidden = true }
      },
      completion: { _ in
        self.startShimmer()
      })
  }

  open func applyMask() {
    let maskLayer = CAShapeLayer()
    maskLayer.frame = bounds
    let combinedPath = UIBezierPath()
    for originalView in originalViews {
      let convertedFrame = originalView.frame
      let radius =
        originalView.layer.cornerRadius > 0 ? originalView.layer.cornerRadius : defaultCorderRadius
      let path = UIBezierPath(roundedRect: convertedFrame, cornerRadius: radius)
      combinedPath.append(path)
    }
    maskLayer.path = combinedPath.cgPath
    gradientLayer.mask = maskLayer
  }

  open func hidePlaceholder() {
    UIView.transition(
      with: self, duration: 0.2, options: [.transitionCrossDissolve],
      animations: {
        self.gradientLayer.isHidden = true
        self.originalViews.forEach { $0.isHidden = false }
      },
      completion: { _ in
        self.stopShimmer()
      })
  }

  open func startShimmer() {
    let animation = CABasicAnimation(keyPath: "colors")

    if let colors = shimmerBackgroundColors, colors.count == 2 {
      // Create the animation using the provided colors
      animation.fromValue = [
        colors[0].withAlphaComponent(0).cgColor,
        colors[1].withAlphaComponent(0.9).cgColor,
        colors[0].withAlphaComponent(0).cgColor,
      ]
      animation.toValue = [
        colors[0].withAlphaComponent(0.9).cgColor,
        colors[1].withAlphaComponent(0).cgColor,
        colors[0].withAlphaComponent(0.9).cgColor,
      ]
    } else {
      // Fallback animation using white
      let valZero = 0.0
      let valColor = 0.9
      animation.fromValue = [
        UIColor.white.withAlphaComponent(valZero).cgColor,
        UIColor.white.withAlphaComponent(valColor).cgColor,
        UIColor.white.withAlphaComponent(valZero).cgColor,
      ]
      animation.toValue = [
        UIColor.white.withAlphaComponent(valColor).cgColor,
        UIColor.white.withAlphaComponent(valZero).cgColor,
        UIColor.white.withAlphaComponent(valColor).cgColor,
      ]
    }

    animation.duration = animationSpeed
    animation.autoreverses = true
    animation.repeatCount = .infinity
    gradientLayer.add(animation, forKey: "alphaGradientAnimation")
  }

  private func stopShimmer() {
    gradientLayer.removeAnimation(forKey: "alphaGradientAnimation")
  }
}
