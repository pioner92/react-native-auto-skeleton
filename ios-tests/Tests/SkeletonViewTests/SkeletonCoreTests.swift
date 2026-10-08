import UIKit
import XCTest
@testable import SkeletonView

final class SkeletonCoreTests: XCTestCase {
  private func makeView(_ frame: CGRect, background: UIColor? = .red) -> UIView {
    let view = UIView(frame: frame)
    view.backgroundColor = background
    return view
  }

  private func makeCore(children: [UIView]) -> SkeletonCore {
    let core = SkeletonCore(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
    children.forEach(core.addSubview)
    core.initOriginalViews(subviews: children)
    return core
  }

  func testHidesSkeletonTargetsWhileLoading() {
    let target = makeView(CGRect(x: 0, y: 0, width: 100, height: 20))
    let transparent = makeView(CGRect(x: 0, y: 30, width: 100, height: 20), background: nil)
    let core = makeCore(children: [target, transparent])

    core.isLoading = true

    XCTAssertTrue(target.isHidden)
    XCTAssertFalse(transparent.isHidden)
  }

  func testNeverHidesIgnoredViews() {
    let ignored = makeView(CGRect(x: 0, y: 0, width: 100, height: 20))
    ignored.accessibilityIdentifier = Constants.IGNORE_VIEW_NAME
    let core = makeCore(children: [ignored])

    core.isLoading = true

    XCTAssertFalse(ignored.isHidden)
  }

  func testRestoresTheOriginalHiddenStateWhenLoadingEnds() {
    let visible = makeView(CGRect(x: 0, y: 0, width: 100, height: 20))
    let hidden = makeView(CGRect(x: 0, y: 30, width: 100, height: 20))
    hidden.isHidden = true
    let core = makeCore(children: [visible, hidden])

    core.isLoading = true
    XCTAssertTrue(visible.isHidden)

    core.isLoading = false
    XCTAssertFalse(visible.isHidden)
    XCTAssertTrue(hidden.isHidden)
  }

  // A view unmounted during loading goes to Fabric's recycle pool; it must not stay hidden (#18, #19).
  func testRestoreOriginalViewUnhidesAViewLeavingTheSkeleton() {
    let leaving = makeView(CGRect(x: 0, y: 0, width: 100, height: 20))
    let staying = makeView(CGRect(x: 0, y: 30, width: 100, height: 20))
    let core = makeCore(children: [leaving, staying])
    core.isLoading = true

    core.restoreOriginalView(leaving)

    XCTAssertFalse(leaving.isHidden)
    XCTAssertTrue(staying.isHidden)
    XCTAssertFalse(core.views.contains { $0 === leaving })
  }

  func testRestoreOriginalViewKeepsAnOriginallyHiddenViewHidden() {
    let hidden = makeView(CGRect(x: 0, y: 0, width: 100, height: 20))
    hidden.isHidden = true
    let core = makeCore(children: [hidden])
    core.isLoading = true

    core.restoreOriginalView(hidden)

    XCTAssertTrue(hidden.isHidden)
  }

  // Once handed back, the view belongs to its next owner; ending the skeleton must not touch it.
  func testARestoredViewIsNoLongerManaged() {
    let leaving = makeView(CGRect(x: 0, y: 0, width: 100, height: 20))
    let core = makeCore(children: [leaving])
    core.isLoading = true
    core.restoreOriginalView(leaving)

    leaving.isHidden = true
    core.isLoading = false

    XCTAssertTrue(leaving.isHidden)
  }

  func testRestoreOriginalViewIgnoresViewsItNeverHid() {
    let core = makeCore(children: [])
    let foreign = makeView(CGRect(x: 0, y: 0, width: 100, height: 20))
    foreign.isHidden = true

    core.restoreOriginalView(foreign)

    XCTAssertTrue(foreign.isHidden)
  }
}
