//
//  Animations.swift
//  react-native-auto-skeleton
//
//  Created by Oleksandr Shumihin on 30/3/25.
//

import Foundation

private let ANIMATION_NAME = "alphaGradientAnimation"


final class AnimationGradient: AnimationBase {

  override var animatedLayer: CALayer? { gradientLayer }

  private let animation = CABasicAnimation(keyPath: "colors")

  private let gradientLayer: CAGradientLayer = {
    let layer = CAGradientLayer()

    layer.colors = [
      DEFAULT_GRADIENT_COLORS[0].cgColor,
      DEFAULT_GRADIENT_COLORS[1].cgColor,
      DEFAULT_GRADIENT_COLORS[0].cgColor,
    ]

    layer.startPoint = CGPoint(x: 0, y: 0.5)
    layer.endPoint = CGPoint(x: 1, y: 0.5)

    layer.locations = [0, 0.5, 1]

    return layer
  }()


  override func start() {
    if(gradientLayer.animation(forKey: ANIMATION_NAME) != nil){
      super.stop()
    }

    gradientLayer.frame = delegate?.mainLayer.bounds ?? .zero

    let colors = delegate?.gradientColors ?? DEFAULT_GRADIENT_COLORS

    animation.fromValue = [
      colors[0].cgColor,
      colors[1].cgColor,
      colors[0].cgColor,
    ]
    animation.toValue = [
      colors[1].cgColor,
      colors[0].cgColor,
      colors[1].cgColor,
    ]

    animation.duration = duration

    animation.autoreverses = true
    animation.repeatCount = .infinity

    gradientLayer.add(animation, forKey: ANIMATION_NAME)

    if(gradientLayer.superlayer == nil){
      delegate?.mainLayer.addSublayer(gradientLayer)
    }
  }

  override func updateBounds(bounds: CGRect) {
    gradientLayer.frame = bounds
  }

  deinit {
    gradientLayer.removeAnimation(forKey: ANIMATION_NAME )
    gradientLayer.removeFromSuperlayer()
  }
}
