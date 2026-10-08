#import <XCTest/XCTest.h>
#import <objc/message.h>

#import <React/RCTViewComponentView.h>
#import <react/renderer/components/RNAutoSkeletonViewSpec/Props.h>

using namespace facebook::react;

// The library's headers are not public in its podspec, so classes are resolved at runtime.
static Class AutoSkeletonViewClass(void) {
  return NSClassFromString(@"AutoSkeletonView");
}

static UIView<RCTComponentViewProtocol> *MakeLoadingSkeleton(void) {
  UIView<RCTComponentViewProtocol> *skeleton =
      [[AutoSkeletonViewClass() alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
  auto oldProps = std::make_shared<const AutoSkeletonViewProps>();
  auto props = std::make_shared<AutoSkeletonViewProps>();
  props->isLoading = true;
  [skeleton updateProps:props oldProps:oldProps];
  return skeleton;
}

// A paragraph is always a skeleton target, whatever its background.
static UIView<RCTComponentViewProtocol> *MakeTextChild(void) {
  UIView<RCTComponentViewProtocol> *child =
      [[NSClassFromString(@"RCTParagraphComponentView") alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
  return child;
}

static void Mount(UIView<RCTComponentViewProtocol> *skeleton, UIView<RCTComponentViewProtocol> *child) {
  [skeleton mountChildComponentView:child index:0];
  [skeleton setNeedsLayout];
  [skeleton layoutIfNeeded];
}

@interface AutoSkeletonViewTests : XCTestCase
@end

@implementation AutoSkeletonViewTests

#pragma mark - Fabric

- (void)testComponentClassesExist {
  XCTAssertNotNil(AutoSkeletonViewClass());
  XCTAssertNotNil(NSClassFromString(@"AutoSkeletonIgnoreView"));
}

// A child unmounted while loading goes to Fabric's recycle pool, which never resets `hidden` (#19).
- (void)testUnmountingAChildWhileLoadingRestoresItsVisibility {
  UIView<RCTComponentViewProtocol> *skeleton = MakeLoadingSkeleton();
  UIView<RCTComponentViewProtocol> *child = MakeTextChild();
  Mount(skeleton, child);
  XCTAssertTrue(child.hidden, @"precondition: the skeleton hides its child while loading");

  [skeleton unmountChildComponentView:child index:0];

  XCTAssertFalse(child.hidden);
  XCTAssertNil(child.superview);
}

- (void)testUnmountingAnOriginallyHiddenChildKeepsItHidden {
  UIView<RCTComponentViewProtocol> *skeleton = MakeLoadingSkeleton();
  UIView<RCTComponentViewProtocol> *child = MakeTextChild();
  child.hidden = YES;
  Mount(skeleton, child);

  [skeleton unmountChildComponentView:child index:0];

  XCTAssertTrue(child.hidden);
}

// Covers the whole skeleton being unmounted while loading: it leaves the window first.
- (void)testLeavingTheWindowWhileLoadingRestoresChildren {
  UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 400, 800)];
  UIView<RCTComponentViewProtocol> *skeleton = MakeLoadingSkeleton();
  [window addSubview:skeleton];
  UIView<RCTComponentViewProtocol> *child = MakeTextChild();
  Mount(skeleton, child);
  XCTAssertTrue(child.hidden, @"precondition: the skeleton hides its child while loading");

  [skeleton removeFromSuperview];

  XCTAssertFalse(child.hidden);
}

#pragma mark - Old Architecture manager

// `RCTComponentData` exports this type to JS; only `UIColorArray` makes the view config run
// processColorArray, so anything else sends raw color strings to native (#20).
- (void)testOldArchGradientColorsPropIsExportedAsUIColorArray {
  Class manager = NSClassFromString(@"AutoSkeletonViewManager");
  NSArray<NSString *> *config =
      ((NSArray<NSString *> * (*)(id, SEL)) objc_msgSend)(manager, NSSelectorFromString(@"propConfig_gradientColors"));

  XCTAssertEqualObjects(config.firstObject, @"UIColorArray");
}

- (void)testOldArchSetterAppliesProcessedColors {
  UIView *view = [self setOldArchGradientColors:@[ @(0xFFFF0000), @(0xFF0000FF) ]];

  NSArray<UIColor *> *colors = [view valueForKey:@"gradientColors"];
  XCTAssertEqual(colors.count, 2u);
  XCTAssertEqualObjects(colors[0], [UIColor colorWithRed:1 green:0 blue:0 alpha:1]);
  XCTAssertEqualObjects(colors[1], [UIColor colorWithRed:0 green:0 blue:1 alpha:1]);
}

// Unprocessed strings fail RCTConvert, leaving an empty array that used to be indexed (#20).
- (void)testOldArchSetterSurvivesUnprocessedColors {
  NSArray *unprocessed = @[ @"#D3D3D3", @"#FFFFFF" ];

  XCTAssertNoThrow([self setOldArchGradientColors:unprocessed]);
}

- (UIView *)setOldArchGradientColors:(id)json {
  id manager = [NSClassFromString(@"AutoSkeletonViewManager") new];
  UIView *view = [NSClassFromString(@"react_native_auto_skeleton.SkeletonViewOldArch") new];
  UIView *defaultView = [NSClassFromString(@"react_native_auto_skeleton.SkeletonViewOldArch") new];
  ((void (*)(id, SEL, id, id, id))objc_msgSend)(
      manager, NSSelectorFromString(@"set_gradientColors:forView:withDefaultView:"), json, view, defaultView);
  return view;
}

@end
