//
//  SkeletonProtocols.swift
//  Pods
//
//  Created by Oleksandr Shumihin on 30/3/25.
//

protocol SkeletonRenderable: AnyObject {
  var mainLayer: CAShapeLayer { get set }
}

protocol SkeletonGradientSupporting: AnyObject {
  var gradientColors: [UIColor] { get set }
}

typealias SkeletonAnimatableDelegate = SkeletonRenderable & SkeletonGradientSupporting

protocol SkeletonAnimatableBase {
  var animatedLayer: CALayer? { get }
  func start()
  func stop()
  func restart()
  func updateBounds(bounds: CGRect)
}

protocol SkeletonAnimatable:SkeletonAnimatableBase {
  var duration: TimeInterval { get set }
  var delegate: SkeletonAnimatableDelegate? { get set }
  var animatedLayer: CALayer? { get }
  func start()
  func stop()
  func restart()
  func updateBounds(bounds: CGRect)
}

protocol PlaceholderMaskDelegate: UIView, SkeletonRenderable {
  var views: [UIView] { get set }
}
