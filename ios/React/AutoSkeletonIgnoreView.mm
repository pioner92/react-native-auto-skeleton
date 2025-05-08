#import "AutoSkeletonIgnoreView.h"

#import "../generated/RNAutoSkeletonViewSpec/ComponentDescriptors.h"
#import "../generated/RNAutoSkeletonViewSpec/EventEmitters.h"
#import "../generated/RNAutoSkeletonViewSpec/Props.h"
#import "../generated/RNAutoSkeletonViewSpec/RCTComponentViewHelpers.h"

#import "RCTFabricComponentsPlugins.h"

#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import "RCTBridge.h"
#if __has_include(<react_native_auto_skeleton/react_native_auto_skeleton-Swift.h>)
#import <react_native_auto_skeleton/react_native_auto_skeleton-Swift.h>
#else
#import "react_native_auto_skeleton-Swift.h"
#endif


using namespace facebook::react;

@interface AutoSkeletonIgnoreView () <RCTAutoSkeletonIgnoreViewViewProtocol>

@end

@implementation AutoSkeletonIgnoreView {
  UIView * _view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<AutoSkeletonIgnoreViewComponentDescriptor>();
}

-(instancetype)init
{
  if(self = [super init]) {
    self.accessibilityIdentifier = Constants.IGNORE_VIEW_NAME;

    _view = [UIView new];
    _view.userInteractionEnabled = NO;
    self.contentView = _view;
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const AutoSkeletonIgnoreViewProps>();
    _props = defaultProps;

    self.accessibilityIdentifier = Constants.IGNORE_VIEW_NAME;

    _view = [UIView new];
    _view.userInteractionEnabled = NO;

    self.contentView = _view;
  }

  return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    [super updateProps:props oldProps:oldProps];
}

-(void) layoutSubviews {
  [super layoutSubviews];
  _view.frame = self.bounds;
}

Class<RCTComponentViewProtocol> AutoSkeletonIgnoreViewCls(void)
{
    return AutoSkeletonIgnoreView.class;
}


@end
