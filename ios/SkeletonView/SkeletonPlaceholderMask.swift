//
//  PlaceholderMask.swift
//  react-native-auto-skeleton
//
//  Created by Oleksandr Shumihin on 30/3/25.
//

import Foundation

final class SkeletonPlaceholderMask {
  weak var delegate: PlaceholderMaskDelegate?

  var defaultBorderRadius: CGFloat = 4.0 {
    didSet {
      applyMask()
    }
  }

  let maskLayer = CAShapeLayer()

  func applyMask() {

    guard let targedDelegate = delegate else { return }

    maskLayer.frame = targedDelegate.bounds

    let combinedPath = UIBezierPath()

    for originalView in targedDelegate.views {
      let convertedFrame = originalView.frame

      let radius = originalView.layer.cornerRadius > 0 ? originalView.layer.cornerRadius : defaultBorderRadius

      let path = UIBezierPath(roundedRect: convertedFrame,
                              cornerRadius: radius)

      combinedPath.append(path)
    }

    maskLayer.path = combinedPath.cgPath

    targedDelegate.mainLayer.mask = maskLayer
  }
}
