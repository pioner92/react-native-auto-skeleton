
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
public class SkeletonViewOldArch: SkeletonCore {

	override public func layoutSubviews() {
		super.layoutSubviews()

		DispatchQueue.main.async {
			let views = self.flattenSubviews(from: self.subviews)

      self.initOriginalViews(subviews: views)

			if self.isLoading {
				self.showPlaceholder()
			}
		}
  }

  func flattenSubviews(from views: [UIView]) -> [UIView] {
    var result: [UIView] = []

    for view in views {
      if(view.accessibilityIdentifier == Constants.IGNORE_VIEW_NAME){
        continue
      }

      result.append(view)
      if !view.subviews.isEmpty {
        result.append(contentsOf: flattenSubviews(from: view.subviews))
      }
    }

    return result
  }
}
