#import <React/RCTUIManager.h>
#import <React/RCTViewManager.h>
#import "AutoSkeletonView.h"
#import "RCTBridge.h"
#import "react_native_auto_skeleton-Swift.h"

#pragma mark SkeletonView

@interface AutoSkeletonViewManager : RCTViewManager
@end

@implementation AutoSkeletonViewManager

RCT_EXPORT_MODULE(AutoSkeletonView)

RCT_CUSTOM_VIEW_PROPERTY(isLoading, BOOL, SkeletonViewOldArch) {
  BOOL isLoading = json ? [RCTConvert BOOL:json] : defaultView.isLoading;
  view.isLoading = isLoading;
}

RCT_CUSTOM_VIEW_PROPERTY(defaultRadius, float, SkeletonViewOldArch) {
  float defaultRadius =
      json ? [RCTConvert float:json] : defaultView.defaultCorderRadius;
  view.defaultCorderRadius = defaultRadius;
}

RCT_CUSTOM_VIEW_PROPERTY(shimmerSpeed, float, SkeletonViewOldArch) {
  float shimmerSpeed =
      json ? [RCTConvert float:json] : defaultView.animationSpeed;
  view.animationSpeed = shimmerSpeed;
}

RCT_CUSTOM_VIEW_PROPERTY(shimmerBackgroundColor, UIColor, SkeletonViewOldArch) {
  UIColor* uiColor =
      json ? [RCTConvert UIColor:json] : view.shapesBackgroundColor;

  view.shapesBackgroundColor = uiColor;
}

RCT_CUSTOM_VIEW_PROPERTY(gradientColors,
                         NSArray<UIColor>,
                         SkeletonViewOldArch) {
  NSArray<UIColor*>* colors = [RCTConvert UIColorArray:json];

  [view setGradientColors:colors];
}

RCT_CUSTOM_VIEW_PROPERTY(animationType, NSString, SkeletonViewOldArch) {
  NSString* animationType =
      json ? [RCTConvert NSString:json] : view.animationType;

  [view setAnimationType:animationType];
}

- (UIView*)view {
  return [SkeletonViewOldArch new];
}

RCT_EXPORT_VIEW_PROPERTY(color, NSString)

@end

// -----------

#pragma mark SkeletonIgnoreView

@interface AutoSkeletonViewIgnoreManager : RCTViewManager
@end

@implementation AutoSkeletonViewIgnoreManager

RCT_EXPORT_MODULE(AutoSkeletonIgnoreView)

- (UIView*)view {
  UIView* view = [UIView new];
  view.accessibilityIdentifier = Constants.IGNORE_VIEW_NAME;
  return view;
}

@end
