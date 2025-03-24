#import "AutoSkeletonView.h"

#import "../generated/RNAutoSkeletonViewSpec/ComponentDescriptors.h"
#import "../generated/RNAutoSkeletonViewSpec/EventEmitters.h"
#import "../generated/RNAutoSkeletonViewSpec/Props.h"
#import "../generated/RNAutoSkeletonViewSpec/RCTComponentViewHelpers.h"

#import "RCTFabricComponentsPlugins.h"
#import "react_native_auto_skeleton-Swift.h"

#import <React/RCTUIManager.h>
#import <React/RCTViewManager.h>
#import "RCTBridge.h"

using namespace facebook::react;

@interface AutoSkeletonView () <RCTAutoSkeletonViewViewProtocol>

@end

@implementation AutoSkeletonView {
  SkeletonView* _view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<
      AutoSkeletonViewComponentDescriptor>();
}

- (instancetype)init {
  if (self = [super init]) {
    _view = [SkeletonView new];

    self.contentView = _view;
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps =
        std::make_shared<const AutoSkeletonViewProps>();
    _props = defaultProps;

    _view = [[SkeletonView alloc] init];

    [_view addChildrenWithViews:self.subviews];

    self.contentView = _view;
  }

  return self;
}

- (void)updateProps:(Props::Shared const&)props
           oldProps:(Props::Shared const&)oldProps {
  const auto& oldViewProps =
      *std::static_pointer_cast<AutoSkeletonViewProps const>(_props);
  const auto& newViewProps =
      *std::static_pointer_cast<AutoSkeletonViewProps const>(props);

  if (oldViewProps.isLoading != newViewProps.isLoading) {
    [_view setIsLoading:newViewProps.isLoading];
  }
  if (oldViewProps.shimmerSpeed != newViewProps.shimmerSpeed) {
    [_view setAnimationSpeed:newViewProps.shimmerSpeed];
  }

  if (oldViewProps.shimmerBackgroundColor !=
      newViewProps.shimmerBackgroundColor) {
    NSString* string_color = [NSString
        stringWithUTF8String:newViewProps.shimmerBackgroundColor.c_str()];

    UIColor* uiColor = [self hexStringToColor:string_color];

    [_view setShimmerBackgroundColor:uiColor.CGColor];
  }

  if (oldViewProps.defaultRadius !=
      newViewProps.defaultRadius) {
    [_view setDefaultCorderRadius:newViewProps.defaultRadius];
  }

  [super updateProps:props oldProps:oldProps];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _view.frame = self.bounds;
}

Class<RCTComponentViewProtocol> AutoSkeletonViewCls(void) {
  return AutoSkeletonView.class;
}

- hexStringToColor:(NSString*)stringToConvert {
  NSString* noHashString =
      [stringToConvert stringByReplacingOccurrencesOfString:@"#"
                                                 withString:@""];
  NSScanner* stringScanner = [NSScanner scannerWithString:noHashString];

  unsigned hex;
  if (![stringScanner scanHexInt:&hex])
    return nil;
  int r = (hex >> 16) & 0xFF;
  int g = (hex >> 8) & 0xFF;
  int b = (hex)&0xFF;

  return [UIColor colorWithRed:r / 255.0f
                         green:g / 255.0f
                          blue:b / 255.0f
                         alpha:1.0f];
}

@end
