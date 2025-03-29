#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import "RCTBridge.h"
#import "AutoSkeletonView.h"
#import "react_native_auto_skeleton-Swift.h"


#pragma mark SkeletonView

@interface AutoSkeletonViewManager : RCTViewManager
@end

@implementation AutoSkeletonViewManager

RCT_EXPORT_MODULE(AutoSkeletonView)


RCT_CUSTOM_VIEW_PROPERTY(isLoading, BOOL, SkeletonView) {
  BOOL isLoading = json ? [RCTConvert BOOL:json] : defaultView.isLoading;
  view.isLoading = isLoading;
}

RCT_CUSTOM_VIEW_PROPERTY(defaultRadius, float, SkeletonView) {
	float defaultRadius = json ? [RCTConvert float:json] : defaultView.defaultCorderRadius;
	view.defaultCorderRadius = defaultRadius;
}

RCT_CUSTOM_VIEW_PROPERTY(shimmerSpeed, float, SkeletonView) {
	float shimmerSpeed = json ? [RCTConvert float:json] : defaultView.animationSpeed;
	view.animationSpeed = shimmerSpeed;
}

RCT_CUSTOM_VIEW_PROPERTY(shimmerBackgroundColor, UIColor, SkeletonView) {
	UIColor *uiColor = json ? [RCTConvert UIColor:json] : view.shimmerBackgroundColor;

	view.shimmerBackgroundColor = uiColor;
}

RCT_CUSTOM_VIEW_PROPERTY(gradientColors, NSArray<UIColor>, SkeletonView) {
	NSArray<UIColor*> *colors = [RCTConvert UIColorArray:json];

	[view setGradientColors:colors];
}


- (UIView *)view
{
  return  [SkeletonView new];
}

RCT_EXPORT_VIEW_PROPERTY(color, NSString)

@end

// -----------

#pragma mark SkeletonIgnoreView

@interface AutoSkeletonViewIgnoreManager : RCTViewManager
@end

@implementation AutoSkeletonViewIgnoreManager

RCT_EXPORT_MODULE(AutoSkeletonIgnoreView)

- (UIView *)view
{
	UIView * view = [UIView new];
	view.accessibilityIdentifier = Constants.IGNORE_VIEW_NAME;
	return view;
}

@end
