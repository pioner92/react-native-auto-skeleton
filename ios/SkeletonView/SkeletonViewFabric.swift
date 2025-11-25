//
//  SkeletonView.swift
//  intch_application
//
//  Created by Oleksandr Shumihin on 21/3/25.
//  Copyright © 2025 Facebook. All rights reserved.
//

import Foundation
import UIKit
import React

@objcMembers
public class SkeletonViewFabric: SkeletonCore {
  override public func didMoveToWindow() {
    super.didMoveToWindow()
    
    if self.window == nil {
        hidePlaceholder()
        return
    }
    
    subviewsUpdated()
  }

  public func subviewsUpdated(){
    guard let superview else { return }
    initOriginalViews(subviews: superview.subviews)

    if isLoading {
      showPlaceholder()
    }
  }
}
