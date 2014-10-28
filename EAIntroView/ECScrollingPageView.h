//
//  ECScrollingPageView.h
//
//  Copyright (c) 2013-2014 Evgeny Aleksandrov. License: MIT.

#import <UIKit/UIKit.h>
#import "ECScrollingPage.h"

enum ECScrollingPageViewTags {
    kTitleLabelTag = 1,
    kDescLabelTag,
    kTitleImageViewTag
};

enum ECSlideShowMode {
    kScrollingImageMode,    // for scrolling images, e.g., ADs
    kIntroductionMode,      // for introduction page which appears in the first launch
    kCustomMode
};

enum ECSlideShowReachBorderBehavior {
    kLoop,                  // when slide reaches the last(first), the next(previous) would be first(last) again
    kSwipeToExit,           // when slide reaches the last, another swipe would exit slide show
    kBounce                 // bounce when user wants to swipe to the slide out of boundary
};

@class ECScrollingPageView;

@protocol ECScrollingDelegate
@optional
- (void)scrollingPageViewDidFinish:(ECScrollingPageView *)scrollingPageView;
- (void)scrollingPageView:(ECScrollingPageView *)scrollingPageView pageAppeared:(ECScrollingPage *)page withIndex:(NSInteger)pageIndex;
- (void)scrollingPageView:(ECScrollingPageView *)scrollingPageView pageStartScrolling:(ECScrollingPage *)page withIndex:(NSInteger)pageIndex;
- (void)scrollingPageView:(ECScrollingPageView *)scrollingPageView pageEndScrolling:(ECScrollingPage *)page withIndex:(NSInteger)pageIndex;
- (void)scrollingPageView:(ECScrollingPageView *)scrollingPageView pageTapped:(ECScrollingPage *)page withIndex:(NSInteger)pageIndex;
@end

@interface ECScrollingPageView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id<ECScrollingDelegate> delegate;

// these properties are conflict
@property (nonatomic, assign) bool autoScrolling;
@property (nonatomic, assign) NSInteger autoScrollingInterval;
@property (nonatomic, assign) bool tapToNext;
@property (nonatomic, assign) ECSlideShowReachBorderBehavior borderBehavior;
@property (nonatomic, assign) ECSlideShowMode showMode;

@property (nonatomic, assign) bool hideOffscreenPages;
@property (nonatomic, assign) bool easeOutCrossDisolves;
@property (nonatomic, assign) bool showSkipButtonOnlyOnLastPage;
@property (nonatomic, assign) bool useMotionEffects;
@property (nonatomic, assign) CGFloat motionEffectsRelativeValue;
@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, assign) UIViewContentMode bgViewContentMode;

// titleView Y position - from top of the screen
// pageControl Y position - from bottom of the screen
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, assign) CGFloat titleViewY;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) CGFloat pageControlY;
@property (nonatomic, strong) UIButton *skipButton;

@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign) NSInteger visiblePageIndex;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *pages;

- (id)initWithFrame:(CGRect)frame andPages:(NSArray *)pagesArray;

- (void)showInView:(UIView *)view animateDuration:(CGFloat)duration;
- (void)hideWithFadeOutDuration:(CGFloat)duration;

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex;
- (void)setCurrentPageIndex:(NSInteger)currentPageIndex animated:(BOOL)animated;

@end
