
  //
//  Animations.swift
//  react-native-auto-skeleton
//
//  Created by Oleksandr Shumihin on 30/3/25.
//

import Foundation

private let ANIMATION_NAME = "animationPulse"

class AnimationPulse: AnimationBase {
  override var animatedLayer: CALayer? {
    return delegate?.mainLayer
  }

  private let animation = CABasicAnimation(keyPath: "opacity")

  override func start() {
    if(animatedLayer?.animation(forKey: ANIMATION_NAME) != nil){
      super.stop()
    }

    animation.fromValue = 1.0
    animation.toValue = 0.5

    animation.duration = duration

    animation.autoreverses = true
    animation.repeatCount = .infinity

    animatedLayer?.add(animation, forKey: ANIMATION_NAME)
  }

  deinit {
    animatedLayer?.removeAnimation(forKey: ANIMATION_NAME)
  }
}
