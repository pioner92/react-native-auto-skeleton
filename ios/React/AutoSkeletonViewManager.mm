#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import "RCTBridge.h"
#import "AutoSkeletonView.h"
#import "react_native_auto_skeleton-Swift.h"

@interface AutoSkeletonViewManager : RCTViewManager
@end

@implementation AutoSkeletonViewManager

RCT_EXPORT_MODULE(AutoSkeletonViewOld)


RCT_CUSTOM_VIEW_PROPERTY(isLoading, BOOL, SkeletonView) {
  BOOL isLoading = json ? [RCTConvert BOOL:json] : defaultView.isLoading;
  view.isLoading = isLoading;
  [view setNeedsDisplay];
}

- (UIView *)view
{
  return  [[SkeletonView alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(color, NSString)

@end
