#import "AutoSkeletonView.h"

#import "react/renderer/components/RNAutoSkeletonViewSpec/ComponentDescriptors.h"
#import "react/renderer/components/RNAutoSkeletonViewSpec/EventEmitters.h"
#import "react/renderer/components/RNAutoSkeletonViewSpec/Props.h"
#import "react/renderer/components/RNAutoSkeletonViewSpec/RCTComponentViewHelpers.h"

#import "RCTFabricComponentsPlugins.h"
#if __has_include(<react_native_auto_skeleton/react_native_auto_skeleton-Swift.h>)
#import <react_native_auto_skeleton/react_native_auto_skeleton-Swift.h>
#else
#import "react_native_auto_skeleton-Swift.h"
#endif

#import <React/RCTConversions.h>
#import <React/RCTUIManager.h>
#import <React/RCTViewManager.h>
#import <react/renderer/graphics/Color.h>
#import "RCTBridge.h"

using namespace facebook::react;

@interface AutoSkeletonView () <RCTAutoSkeletonViewViewProtocol>

@end

@implementation AutoSkeletonView {
  SkeletonViewFabric* _view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<
      AutoSkeletonViewComponentDescriptor>();
}


- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps =
        std::make_shared<const AutoSkeletonViewProps>();
    _props = defaultProps;

    _view = [SkeletonViewFabric new];
    _view.userInteractionEnabled = NO;

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
    _view.isLoading = newViewProps.isLoading;
  }
  if (oldViewProps.shimmerSpeed != newViewProps.shimmerSpeed) {
    _view.animationSpeed = newViewProps.shimmerSpeed;
  }

  if (oldViewProps.shimmerBackgroundColor !=
      newViewProps.shimmerBackgroundColor) {
    UIColor* uiColor =
        RCTUIColorFromSharedColor(newViewProps.shimmerBackgroundColor);

    _view.shapesBackgroundColor = uiColor;
  }

  if (oldViewProps.defaultRadius != newViewProps.defaultRadius) {
    _view.defaultCorderRadius = newViewProps.defaultRadius;
  }

  if (oldViewProps.animationType != newViewProps.animationType) {
    _view.animationType = [NSString
                           stringWithUTF8String:newViewProps.animationType
      .c_str()];
  }

  if (oldViewProps.gradientColors != newViewProps.gradientColors) {
    if (newViewProps.gradientColors.size() == 2) {
      UIColor* color1 =
          RCTUIColorFromSharedColor(newViewProps.gradientColors.at(0));
      UIColor* color2 =
          RCTUIColorFromSharedColor(newViewProps.gradientColors.at(1));
      NSArray<UIColor*>* colors =
          [NSArray arrayWithObjects:color1, color2, nil];
      [_view setGradientColors:colors];
    }
  }

  [super updateProps:props oldProps:oldProps];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _view.frame = self.bounds;
  [_view subviewsUpdated];
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
