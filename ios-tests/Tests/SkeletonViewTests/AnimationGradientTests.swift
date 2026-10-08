import UIKit
import XCTest
@testable import SkeletonView

final class AnimationGradientTests: XCTestCase {
  private func gradientColors(of core: SkeletonCore) -> [CGColor] {
    let gradient = core.mainLayer.sublayers?.compactMap { $0 as? CAGradientLayer }.first
    let animation = gradient?.animation(forKey: "alphaGradientAnimation") as? CABasicAnimation
    return (animation?.fromValue as? [CGColor]) ?? []
  }

  private func expected(_ a: UIColor, _ b: UIColor) -> [CGColor] {
    [a.cgColor, b.cgColor, a.cgColor]
  }

  func testUsesTheTwoProvidedColors() {
    let core = SkeletonCore(frame: CGRect(x: 0, y: 0, width: 300, height: 400))

    core.gradientColors = [.red, .blue]

    XCTAssertEqual(gradientColors(of: core), expected(.red, .blue))
  }

  // The Old Arch setter receives an empty NSArray when RCTConvert drops every color (#20).
  func testEmptyColorsFromObjectiveCFallBackToDefaults() {
    let core = SkeletonCore(frame: CGRect(x: 0, y: 0, width: 300, height: 400))

    core.perform(NSSelectorFromString("setGradientColors:"), with: NSMutableArray())

    XCTAssertEqual(
      gradientColors(of: core),
      expected(DEFAULT_GRADIENT_COLORS[0], DEFAULT_GRADIENT_COLORS[1])
    )
  }

  func testASingleColorFallsBackToDefaults() {
    let core = SkeletonCore(frame: CGRect(x: 0, y: 0, width: 300, height: 400))

    core.gradientColors = [.red]

    XCTAssertEqual(
      gradientColors(of: core),
      expected(DEFAULT_GRADIENT_COLORS[0], DEFAULT_GRADIENT_COLORS[1])
    )
  }
}
