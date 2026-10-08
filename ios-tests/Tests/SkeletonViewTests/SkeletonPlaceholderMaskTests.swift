import UIKit
import XCTest
@testable import SkeletonView

final class SkeletonPlaceholderMaskTests: XCTestCase {
  private func maskPath(of core: SkeletonCore) -> CGPath? {
    (core.mainLayer.mask as? CAShapeLayer)?.path
  }

  private func makeView(_ frame: CGRect) -> UIView {
    let view = UIView(frame: frame)
    view.backgroundColor = .red
    return view
  }

  func testDirectChildShapeMatchesItsFrame() {
    let core = SkeletonCore(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
    let child = makeView(CGRect(x: 10, y: 20, width: 100, height: 30))
    core.addSubview(child)
    core.initOriginalViews(subviews: [child])

    core.isLoading = true

    XCTAssertEqual(maskPath(of: core)?.boundingBox, child.frame)
  }

  // Old Arch collects nested descendants; their shape must land where they are on screen (#16).
  func testNestedViewShapeIsPlacedInSkeletonCoordinates() {
    let core = SkeletonCore(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
    let card = makeView(CGRect(x: 0, y: 150, width: 300, height: 120))
    let nested = makeView(CGRect(x: 200, y: 30, width: 100, height: 40))
    card.addSubview(nested)
    core.addSubview(card)
    core.initOriginalViews(subviews: [card, nested])

    core.isLoading = true

    let path = try! XCTUnwrap(maskPath(of: core))
    // Centre of `nested` on screen: inside the card.
    XCTAssertTrue(path.contains(CGPoint(x: 250, y: 200)))
    // Centre of `nested` read as if its local frame were skeleton coordinates: above the card.
    XCTAssertFalse(path.contains(CGPoint(x: 250, y: 50)))
    XCTAssertEqual(path.boundingBox, card.frame)
  }
}
