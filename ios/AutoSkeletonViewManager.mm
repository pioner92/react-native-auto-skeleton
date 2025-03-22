#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import "RCTBridge.h"

@interface AutoSkeletonViewManager : RCTViewManager
@end

@implementation AutoSkeletonViewManager

RCT_EXPORT_MODULE(AutoSkeletonView)

- (UIView *)view
{
  return [[UIView alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(color, NSString)

@end
