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
public class SkeletonViewFabric: SkeletonCore {

  override public func didMoveToWindow() {
    super.didMoveToWindow()

    guard let superview else { return }

    initOriginalViews(views: superview.subviews)

    if isLoading {
      showPlaceholder()
    }
  }
}
