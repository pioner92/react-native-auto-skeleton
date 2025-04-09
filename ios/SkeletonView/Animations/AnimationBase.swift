//
//  AnimationBase.swift
//  react-native-auto-skeleton
//
//  Created by Oleksandr Shumihin on 30/3/25.
//

import Foundation


class AnimationBase:SkeletonAnimatable {
  weak var delegate: SkeletonAnimatableDelegate?
  var isAnimating = false

  var animatedLayer: CALayer? {
    fatalError("Subclasses must override `animatedLayer`")
  }

  var duration: TimeInterval = 1.0 {
    didSet {
      restart()
    }
  }

  func start() {
  }

  func stop() {
    animatedLayer?.removeAllAnimations()
  }

  func restart() {
    stop()
    start()
  }

  func updateBounds(bounds: CGRect) {}
}
