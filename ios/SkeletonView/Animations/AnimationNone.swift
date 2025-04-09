

  //
//  Animations.swift
//  react-native-auto-skeleton
//
//  Created by Oleksandr Shumihin on 30/3/25.
//

import Foundation


final class AnimationNone: AnimationBase {
  override var animatedLayer: CALayer? {
    return delegate?.mainLayer
  }


  override func start() {
  }

  deinit {

  }
}
