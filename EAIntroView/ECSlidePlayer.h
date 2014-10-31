//
//  ECSlidePlayer.h
//
//  Copyright (c) 2013-2014 Evgeny Aleksandrov. License: MIT.
//  
//  This is forked from EAIntroView by Evgeny Aleksandrov.
//  Usage is enhanced, not only introduction but also scrolling
//  images such as advertisement are supported too. 

#import <UIKit/UIKit.h>
#import "ECSlide.h"

typedef enum {
    kTitleLabelTag = 1,
    kDescLabelTag,
    kTitleImageViewTag
} ECSliderPlayerTags;

typedef enum {
    kSlidePlayerModeScrollImage,    // for scrolling images, e.g., ADs
    kSlidePlayerModeIntroduction,   // for introduction page which appears in the first launch
    kSlidePlayerModeCustom
} ECSlidePlayerMode;

typedef enum {
    kSliderPlayerBorderBehaviorLoop,        // when slide reaches the last(first), the next(previous) would be first(last) again
    kSliderPlayerBorderBehaviorSwipeToExit, // when slide reaches the last, another swipe would exit slide show
    kSliderPlayerBorderBehaviorBounce       // bounce when user wants to swipe to the slide out of boundary
} ECSlidePlayerBorderBehavior;

@class ECSlidePlayer;

@protocol ECSlidePlayerDelegate
@optional
- (void)slidePlayerDidFinish:(ECSlidePlayer *)slidePlayer;
- (void)slidePlayer:(ECSlidePlayer *)slidePlayer slideAppeared:(ECSlide *)slide withIndex:(NSInteger)slideIndex;
- (void)slidePlayer:(ECSlidePlayer *)slidePlayer slideStartScrolling:(ECSlide *)slide withIndex:(NSInteger)slideIndex;
- (void)slidePlayer:(ECSlidePlayer *)slidePlayer slideEndScrolling:(ECSlide *)slide withIndex:(NSInteger)slideIndex;
- (void)slidePlayer:(ECSlidePlayer *)slidePlayer slideTapped:(ECSlide *)slide withIndex:(NSInteger)slideIndex;
@end

@interface ECSlidePlayer : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id<ECSlidePlayerDelegate> delegate;

@property (nonatomic, assign) NSInteger autoScrollingInterval;
@property (nonatomic, assign) bool autoScrolling;
@property (nonatomic, assign) bool tapToNext;
@property (nonatomic, assign) ECSlidePlayerBorderBehavior borderBehavior;
@property (nonatomic, assign) ECSlidePlayerMode showMode;

@property (nonatomic, assign) bool hideOffscreenSlides;
@property (nonatomic, assign) bool easeOutCrossDisolves;
@property (nonatomic, assign) bool showSkipButtonOnlyOnLastSlide;
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

@property (nonatomic, assign) NSInteger currentSlideIndex;
@property (nonatomic, assign) NSInteger visibleSlideIndex;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *slides;

- (id)initWithFrame:(CGRect)frame andSlides:(NSArray *)slidesArray;

- (void)showInView:(UIView *)view animateDuration:(CGFloat)duration;
- (void)hideWithFadeOutDuration:(CGFloat)duration;

- (void)setCurrentSlideIndex:(NSInteger)currentSlideIndex;
- (void)setCurrentSlideIndex:(NSInteger)currentSlideIndex animated:(BOOL)animated;

@end
