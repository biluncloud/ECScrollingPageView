//
//  ECSlidePlayer.m
//
//  Copyright (c) 2013-2014 Evgeny Aleksandrov. License: MIT.

#import "ECSlidePlayer.h"

@interface ECSlidePlayer()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *slideBgBack;
@property (nonatomic, strong) UIImageView *slideBgFront;
@property (nonatomic, strong) NSTimer *autoScrollingTimer;

@property(nonatomic, strong) NSLayoutConstraint *pageControlYConstraint;

@end

@interface ECSlide()

@property(nonatomic, strong, readwrite) UIView *slideView;

@end


@implementation ECSlidePlayer

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self applyDefaultsToSelfDuringInitializationWithframe:frame slides:nil];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self applyDefaultsToSelfDuringInitializationWithframe:self.frame slides:nil];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andSlides:(NSArray *)slidesArray {
    self = [super initWithFrame:frame];
    if (self) {
        [self applyDefaultsToSelfDuringInitializationWithframe:self.frame slides:slidesArray];
    }
    return self;
}

#pragma mark - Private

- (void)applyDefaultsToSelfDuringInitializationWithframe:(CGRect)frame slides:(NSArray *)slidesArray {
    self.autoScrolling = NO;
    self.autoScrollingInterval = 3;
    self.tapToNext = NO;
    self.borderBehavior = kSliderPlayerBorderBehaviorBounce;
    self.showMode = kSlidePlayerModeScrollImage;
    self.easeOutCrossDisolves = YES;
    self.hideOffscreenSlides = YES;
    self.titleViewY = 20.0f;
    self.pageControlY = 60.0f;
    self.bgViewContentMode = UIViewContentModeScaleAspectFill;
    self.motionEffectsRelativeValue = 40.0f;
    _slides = [slidesArray copy];
    [self buildUI];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)applyDefaultsToBackgroundImageView:(UIImageView *)backgroundImageView {
    backgroundImageView.backgroundColor = [UIColor clearColor];
    backgroundImageView.contentMode = self.bgViewContentMode;
    backgroundImageView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

- (void)makePanelVisibleAtIndex:(NSInteger)panelIndex{
    [UIView animateWithDuration:0.3 animations:^{
        for (int idx = 0; idx < _slides.count; idx++) {
            if (idx == panelIndex) {
                [[self viewForSlideIndex:idx] setAlpha:1];
            } else {
                if(!self.hideOffscreenSlides) {
                    [[self viewForSlideIndex:idx] setAlpha:0];
                }
            }
        }
    }];
}

- (UIView *)viewForSlideIndex:(NSInteger)idx {
    return ((ECSlide *)_slides[idx]).slideView;
}

- (BOOL)showTitleViewForSlide:(NSInteger)idx {
    if(idx >= _slides.count || idx < 0)
        return NO;
    
    return ((ECSlide *)_slides[idx]).showTitleView;
}

- (void)showPanelAtPageControl {
    [self makePanelVisibleAtIndex:self.currentSlideIndex];
    
    [self setCurrentSlideIndex:self.pageControl.currentPage animated:YES];
}

- (void)checkIndexForScrollView:(UIScrollView *)scrollView {
    NSInteger newSlideIndex = (scrollView.contentOffset.x + scrollView.bounds.size.width/2)/self.scrollView.frame.size.width;
    [self notifyDelegateWithPreviousSlide:self.currentSlideIndex andCurrentSlide:newSlideIndex];
    _currentSlideIndex = newSlideIndex;
    
    if (self.currentSlideIndex == (_slides.count)) {
        
        //if run here, it means you can't  call _slides[self.currentSlideIndex],
        //to be safe, set to the biggest index
        _currentSlideIndex = _slides.count - 1;
        
        [self finishIntroductionAndRemoveSelf];
    }
}

- (void)finishIntroductionAndRemoveSelf {
	if ([(id)self.delegate respondsToSelector:@selector(slidePlayerDidFinish:)]) {
		[self.delegate slidePlayerDidFinish:self];
	}
    
    //prevent last slide flicker on disappearing
    self.alpha = 0;
    [self disableAutoScroll];
    
    //Calling removeFromSuperview from scrollViewDidEndDecelerating: method leads to crash on iOS versions < 7.0.
    //removeFromSuperview should be called after a delay
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)0);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self removeFromSuperview];
    });
}

- (void)skipIntroduction {
    [self hideWithFadeOutDuration:0.3];
}

#pragma mark - Properties

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.accessibilityIdentifier = @"slide_player_scroll";
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return _scrollView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.frame];
        [self applyDefaultsToBackgroundImageView:_bgImageView];
    }
    return _bgImageView;
}

- (UIImageView *)slideBgBack {
    if (!_slideBgBack) {
        _slideBgBack = [[UIImageView alloc] initWithFrame:self.frame];
        [self applyDefaultsToBackgroundImageView:_slideBgBack];
        _slideBgBack.alpha = 0;
    }
    return _slideBgBack;
}

- (UIImageView *)slideBgFront {
    if (!_slideBgFront) {
        _slideBgFront = [[UIImageView alloc] initWithFrame:self.frame];
        [self applyDefaultsToBackgroundImageView:_slideBgFront];
        _slideBgFront.alpha = 0;
    }
    return _slideBgFront;
}

#pragma mark - UI building

- (void)buildUI {
    self.backgroundColor = [UIColor blackColor];
    
    [self buildBackgroundImage];
    [self buildScrollView];
    
    [self buildFooterView];
    
    self.bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.skipButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

- (void)buildBackgroundImage {
    [self addSubview:self.bgImageView];
    [self addSubview:self.slideBgBack];
    [self addSubview:self.slideBgFront];
    
    if (self.useMotionEffects) {
        [self addMotionEffectsOnBg];
    }
}

- (void)buildScrollView {
    
    CGFloat contentXIndex = 0;
    for (int idx = 0; idx < _slides.count; idx++) {
        ECSlide *slide = _slides[idx];
        slide.slideView = [self viewForSlide:slide atXIndex:&contentXIndex];
        [self.scrollView addSubview:slide.slideView];
        if(slide.onSlideDidLoad) slide.onSlideDidLoad();
    }
    
    [self makePanelVisibleAtIndex:0];
    
    if (self.borderBehavior == kSliderPlayerBorderBehaviorSwipeToExit) {
        [self appendCloseViewAtXIndex:&contentXIndex];
    }
    
    [self insertSubview:self.scrollView aboveSubview:self.slideBgFront];
    self.scrollView.contentSize = CGSizeMake(contentXIndex, self.scrollView.frame.size.height);
    
    self.slideBgBack.alpha = 0;
    self.slideBgBack.image = [self bgForSlide:1];
    self.slideBgFront.alpha = 1;
    self.slideBgFront.image = [self bgForSlide:0];
}

- (UIView *)viewForSlide:(ECSlide *)slide atXIndex:(CGFloat *)xIndex {
    
    UIView *slideView = [[UIView alloc] initWithFrame:CGRectMake(*xIndex, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    
    *xIndex += self.scrollView.frame.size.width;
    
    if(slide.customView) {
        slide.customView.frame = slideView.bounds;
        [slideView addSubview:slide.customView];
        return slideView;
    }
    
    UIButton *tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tapButton.frame = slideView.bounds;
    [tapButton addTarget:self action:@selector(slideTapped:) forControlEvents:UIControlEventTouchUpInside];
    [slideView addSubview:tapButton];
    
    if(slide.titleIconView) {
        UIView *titleImageView = slide.titleIconView;
        CGRect rect1 = titleImageView.frame;
        rect1.origin.x = (self.scrollView.frame.size.width - rect1.size.width)/2;
        rect1.origin.y = slide.titleIconPositionY;
        titleImageView.frame = rect1;
        titleImageView.tag = kTitleImageViewTag;
        
        [slideView addSubview:titleImageView];
    }
    
    if(slide.title.length) {
        CGFloat titleHeight;
        
        if ([slide.title respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:slide.title attributes:@{ NSFontAttributeName: slide.titleFont }];
            CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.scrollView.frame.size.width - 20, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            titleHeight = ceilf(rect.size.height);
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            titleHeight = [slide.title sizeWithFont:slide.titleFont constrainedToSize:CGSizeMake(self.scrollView.frame.size.width - 20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
#pragma clang diagnostic pop
        }
        
        CGRect titleLabelFrame = CGRectMake(10, self.frame.size.height - slide.titlePositionY, self.scrollView.frame.size.width - 20, titleHeight);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        titleLabel.text = slide.title;
        titleLabel.font = slide.titleFont;
        titleLabel.textColor = slide.titleColor;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 0;
        titleLabel.tag = kTitleLabelTag;
        
        [slideView addSubview:titleLabel];
    }
    
    if([slide.desc length]) {
        CGRect descLabelFrame;
        
        if(slide.descWidth != 0) {
            descLabelFrame = CGRectMake((self.frame.size.width - slide.descWidth)/2, self.frame.size.height - slide.descPositionY, slide.descWidth, 500);
        } else {
            descLabelFrame = CGRectMake(0, self.frame.size.height - slide.descPositionY, self.scrollView.frame.size.width, 500);
        }
        
        UITextView *descLabel = [[UITextView alloc] initWithFrame:descLabelFrame];
        descLabel.text = slide.desc;
        descLabel.scrollEnabled = NO;
        descLabel.font = slide.descFont;
        descLabel.textColor = slide.descColor;
        descLabel.backgroundColor = [UIColor clearColor];
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.userInteractionEnabled = NO;
        descLabel.tag = kDescLabelTag;
        
        [slideView addSubview:descLabel];
    }
    
    if(slide.subviews) {
        for (UIView *subV in slide.subviews) {
            [slideView addSubview:subV];
        }
    }
    
    slideView.accessibilityLabel = [NSString stringWithFormat:@"slide_view_%lu",(unsigned long)[self.slides indexOfObject:slide]];
    
    return slideView;
}

- (void)appendCloseViewAtXIndex:(CGFloat*)xIndex {
    UIView *closeView = [[UIView alloc] initWithFrame:CGRectMake(*xIndex, 0, self.frame.size.width, self.frame.size.height)];
    closeView.tag = 124;
    [self.scrollView addSubview:closeView];
    
    *xIndex += self.scrollView.frame.size.width;
}

- (void)removeCloseViewAtXIndex:(CGFloat*)xIndex {
    UIView *closeView = [self.scrollView viewWithTag:124];
    if(closeView) {
        [closeView removeFromSuperview];
        *xIndex -= self.scrollView.frame.size.width;
    }
}

- (void)buildFooterView {
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - self.pageControlY, self.frame.size.width, 20)];
    
    self.pageControl.defersCurrentPageDisplay = YES;
    
    self.pageControl.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    [self.pageControl addTarget:self action:@selector(showPanelAtPageControl) forControlEvents:UIControlEventValueChanged];
    self.pageControl.numberOfPages = _slides.count;
    [self addSubview:self.pageControl];
    
    self.skipButton = [[UIButton alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width - 80, self.pageControl.frame.origin.y - ((30 - self.pageControl.frame.size.height)/2), 80, 30)];
    [self.skipButton setTitle:NSLocalizedString(@"Skip", nil) forState:UIControlStateNormal];
    [self.skipButton addTarget:self action:@selector(skipIntroduction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.skipButton];
    
    if ([self respondsToSelector:@selector(addConstraint:)]) {
        self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        //store Y constraint
        //at launch - page control centered with skip button by Y. If Y is set manually, Y constraint turns to bottom constraint
        self.pageControlYConstraint = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.skipButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [self addConstraint:self.pageControlYConstraint];
        
        self.skipButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.skipButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-30]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.skipButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-20]];
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([(id)self.delegate respondsToSelector:@selector(slidePlayer:slideStartScrolling:withIndex:)] && self.currentSlideIndex < [self.slides count]) {
        [self.delegate slidePlayer:self slideStartScrolling:_slides[self.currentSlideIndex] withIndex:self.currentSlideIndex];
    }
    
    if (self.autoScrolling) {
        [self disableAutoScroll];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self checkIndexForScrollView:scrollView];
    if ([(id)self.delegate respondsToSelector:@selector(slidePlayer:slideEndScrolling:withIndex:)] && self.currentSlideIndex < [self.slides count]) {
        [self.delegate slidePlayer:self slideEndScrolling:_slides[self.currentSlideIndex] withIndex:self.currentSlideIndex];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self checkIndexForScrollView:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.visibleSlideIndex = (scrollView.contentOffset.x + scrollView.bounds.size.width/2)/self.scrollView.frame.size.width;
    
    float offset = scrollView.contentOffset.x / self.scrollView.frame.size.width;
    NSInteger slide = (NSInteger)(offset);
    
    if (slide == (_slides.count - 1) && self.borderBehavior == kSliderPlayerBorderBehaviorSwipeToExit) {
        self.alpha = ((self.scrollView.frame.size.width*_slides.count)-self.scrollView.contentOffset.x)/self.scrollView.frame.size.width;
    } else {
        [self crossDissolveForOffset:offset];
    }
    
    if (self.visibleSlideIndex < _slides.count) {
        self.pageControl.currentPage = self.visibleSlideIndex;
        
        [self makePanelVisibleAtIndex:self.visibleSlideIndex];
    }
    
    if (self.autoScrolling) {
        [self enableAutoScroll];
    }
}

float easeOutValue(float value) {
    float inverse = value - 1.0;
    return 1.0 + inverse * inverse * inverse;
}

- (void)crossDissolveForOffset:(float)offset {
    NSInteger slide = (NSInteger)(offset);
    float alphaValue = offset - slide;
    
    if (alphaValue < 0 && self.visibleSlideIndex == 0){
        self.slideBgBack.image = nil;
        self.slideBgFront.alpha = (1 + alphaValue);
        return;
    }
    
    self.slideBgFront.alpha = 1;
    self.slideBgFront.image = [self bgForSlide:slide];
    self.slideBgBack.alpha = 0;
    self.slideBgBack.image = [self bgForSlide:slide+1];
    
    float backLayerAlpha = alphaValue;
    float frontLayerAlpha = (1 - alphaValue);
    
    if (self.easeOutCrossDisolves) {
        backLayerAlpha = easeOutValue(backLayerAlpha);
        frontLayerAlpha = easeOutValue(frontLayerAlpha);
    }
    
    self.slideBgBack.alpha = backLayerAlpha;
    self.slideBgFront.alpha = frontLayerAlpha;
    
    if(self.titleView) {
        if([self showTitleViewForSlide:slide] && [self showTitleViewForSlide:slide+1]) {
            [self.titleView setAlpha:1.0];
        } else if(![self showTitleViewForSlide:slide] && ![self showTitleViewForSlide:slide+1]) {
            [self.titleView setAlpha:0.0];
        } else if([self showTitleViewForSlide:slide]) {
            [self.titleView setAlpha:(1 - alphaValue)];
        } else {
            [self.titleView setAlpha:alphaValue];
        }
    }
    
    if(self.skipButton) {
        if(!self.showSkipButtonOnlyOnLastSlide) {
            [self.skipButton setAlpha:1.0];
        } else if(slide < (long)[self.slides count] - 2) {
            [self.skipButton setAlpha:0.0];
        } else if(slide == [self.slides count] - 1) {
            [self.skipButton setAlpha:(1 - alphaValue)];
        } else {
            [self.skipButton setAlpha:alphaValue];
        }
    }
}

- (UIImage *)bgForSlide:(NSInteger)idx {
    if(idx >= _slides.count || idx < 0)
        return nil;
    
    return ((ECSlide *)_slides[idx]).bgImage;
}

#pragma mark - Custom setters

- (void)notifyDelegateWithPreviousSlide:(NSInteger)previousSlideIndex andCurrentSlide:(NSInteger)currentSlideIndex {
    if(currentSlideIndex!=_currentSlideIndex && currentSlideIndex < _slides.count) {
        ECSlide* previousSlide = _slides[previousSlideIndex];
        ECSlide* currentSlide = _slides[currentSlideIndex];
        if(previousSlide.onSlideDidDisappear) previousSlide.onSlideDidDisappear();
        if(currentSlide.onSlideDidAppear) currentSlide.onSlideDidAppear();
        
        if ([(id)self.delegate respondsToSelector:@selector(slidePlayer:slideAppeared:withIndex:)]) {
            [self.delegate slidePlayer:self slideAppeared:_slides[currentSlideIndex] withIndex:currentSlideIndex];
        }
    }
}

- (void)setSlides:(NSArray *)slides {
    _slides = [slides copy];
    [self.scrollView removeFromSuperview];
    self.scrollView = nil;
    [self buildScrollView];
    self.pageControl.numberOfPages = _slides.count;
}

- (void)setBgImage:(UIImage *)bgImage {
    _bgImage = bgImage;
    self.bgImageView.image = _bgImage;
}

- (void)setBgViewContentMode:(UIViewContentMode)bgViewContentMode {
    _bgViewContentMode = bgViewContentMode;
    self.bgImageView.contentMode = bgViewContentMode;
    self.slideBgBack.contentMode = bgViewContentMode;
    self.slideBgFront.contentMode = bgViewContentMode;
}

-(void)setAutoScrolling:(bool)autoScrolling {
    _autoScrolling = autoScrolling;
    if (autoScrolling) {
        [self enableAutoScroll];
    } else {
        [self disableAutoScroll];
    }
}

- (void)setBorderBehavior:(ECSlidePlayerBorderBehavior)borderBehavior {
    if (borderBehavior != _borderBehavior) {
        CGFloat contentXIndex = self.scrollView.contentSize.width;
        switch (borderBehavior) {
            case kSliderPlayerBorderBehaviorSwipeToExit:
                [self appendCloseViewAtXIndex:&contentXIndex];
                break;
            case kSliderPlayerBorderBehaviorLoop:     // no break for this case because it has to remove close view too
            case kSliderPlayerBorderBehaviorBounce:
            default:
                [self removeCloseViewAtXIndex:&contentXIndex];
                break;
        }
        self.scrollView.contentSize = CGSizeMake(contentXIndex, self.scrollView.frame.size.height);
    }
    _borderBehavior = borderBehavior;
}

-(void)setShowMode:(ECSlidePlayerMode)showMode {
    _showMode = showMode;
    switch (showMode) {
    case kSlidePlayerModeScrollImage:
        self.borderBehavior = kSliderPlayerBorderBehaviorLoop;
        self.autoScrolling = YES;
        break;
    case kSlidePlayerModeIntroduction:
        self.borderBehavior = kSliderPlayerBorderBehaviorSwipeToExit;
        self.autoScrolling = NO;
        break;
    case kSlidePlayerModeCustom:
    default:
        self.borderBehavior = kSliderPlayerBorderBehaviorBounce;
        self.autoScrolling = NO;
        break;
    }
}

- (void)setTitleView:(UIView *)titleView {
    [_titleView removeFromSuperview];
    _titleView = titleView;
    _titleView.frame = CGRectMake((self.frame.size.width-_titleView.frame.size.width)/2, self.titleViewY, _titleView.frame.size.width, _titleView.frame.size.height);
    
    float offset = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    [self crossDissolveForOffset:offset];
    
    [self addSubview:_titleView];
}

- (void)setTitleViewY:(CGFloat)titleViewY {
    _titleViewY = titleViewY;
    _titleView.frame = CGRectMake((self.frame.size.width-_titleView.frame.size.width)/2, self.titleViewY, _titleView.frame.size.width, _titleView.frame.size.height);
}

- (void)setPageControl:(UIPageControl *)pageControl {
    [_pageControl removeFromSuperview];
    _pageControl = pageControl;
    [self addSubview:_pageControl];
}

- (void)setPageControlY:(CGFloat)pageControlY {
    _pageControlY = pageControlY;
    self.pageControl.frame = CGRectMake(self.pageControl.frame.origin.y, self.frame.size.width - pageControlY, self.frame.size.width, self.pageControl.frame.size.height);
    
    if (self.pageControlYConstraint) {
        [self removeConstraint:self.pageControlYConstraint];
        if (self.pageControlYConstraint.firstAttribute != NSLayoutAttributeBottom || self.pageControlYConstraint.secondAttribute != NSLayoutAttributeBottom) {
            self.pageControlYConstraint = [NSLayoutConstraint constraintWithItem:self.pageControl
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1
                                                                        constant:-pageControlY];
        } else {
            self.pageControlYConstraint.constant = -pageControlY;
        }
        [self addConstraint:self.pageControlYConstraint];
    }
}

- (void)setSkipButton:(UIButton *)skipButton {
    [_skipButton removeFromSuperview];
    _skipButton = skipButton;
    [_skipButton addTarget:self action:@selector(skipIntroduction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_skipButton];
}

- (void)setShowSkipButtonOnlyOnLastSlide:(bool)showSkipButtonOnlyOnLastSlide {
    _showSkipButtonOnlyOnLastSlide = showSkipButtonOnlyOnLastSlide;
    
    float offset = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    [self crossDissolveForOffset:offset];
}

- (void)setUseMotionEffects:(bool)useMotionEffects {
    if(_useMotionEffects == useMotionEffects) {
        return;
    }
    _useMotionEffects = useMotionEffects;
    
    if(useMotionEffects) {
        [self addMotionEffectsOnBg];
    } else {
        [self removeMotionEffectsOnBg];
    }
}

- (void)setMotionEffectsRelativeValue:(CGFloat)motionEffectsRelativeValue {
    _motionEffectsRelativeValue = motionEffectsRelativeValue;
    if(self.useMotionEffects) {
        [self addMotionEffectsOnBg];
    }
}

#pragma mark - Motion effects actions

- (void)addMotionEffectsOnBg {
    if(![self respondsToSelector:@selector(setMotionEffects:)]) {
        return;
    }
    
    CGRect parallaxFrame = CGRectMake(-self.motionEffectsRelativeValue, -self.motionEffectsRelativeValue, self.frame.size.width + (self.motionEffectsRelativeValue * 2), self.frame.size.height + (self.motionEffectsRelativeValue * 2));
    [self.slideBgFront setFrame:parallaxFrame];
    [self.slideBgBack setFrame:parallaxFrame];
    [self.bgImageView setFrame:parallaxFrame];
    
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(self.motionEffectsRelativeValue);
    verticalMotionEffect.maximumRelativeValue = @(-self.motionEffectsRelativeValue);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(self.motionEffectsRelativeValue);
    horizontalMotionEffect.maximumRelativeValue = @(-self.motionEffectsRelativeValue);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to all background image views
    [UIView animateWithDuration:0.5f animations:^{
        [self.slideBgFront setMotionEffects:@[group]];
        [self.slideBgBack setMotionEffects:@[group]];
        [self.bgImageView setMotionEffects:@[group]];
    }];
}

- (void)removeMotionEffectsOnBg {
    if(![self respondsToSelector:@selector(removeMotionEffect:)]) {
        return;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.slideBgFront removeMotionEffect:self.slideBgFront.motionEffects[0]];
        [self.slideBgBack removeMotionEffect:self.slideBgBack.motionEffects[0]];
        [self.bgImageView removeMotionEffect:self.bgImageView.motionEffects[0]];
    }];
}

#pragma mark - Actions

- (void)showInView:(UIView *)view animateDuration:(CGFloat)duration {
    self.alpha = 0;
    _currentSlideIndex = 0;
    self.scrollView.contentOffset = CGPointZero;
    [view addSubview:self];
    
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        ECSlide* currentSlide = _slides[self.currentSlideIndex];
        if(currentSlide.onSlideDidAppear) currentSlide.onSlideDidAppear();
        
        if ([(id)self.delegate respondsToSelector:@selector(slidePlayer:slideAppeared:withIndex:)]) {
            [self.delegate slidePlayer:self slideAppeared:_slides[self.currentSlideIndex] withIndex:self.currentSlideIndex];
        }
    }];
}

- (void)hideWithFadeOutDuration:(CGFloat)duration {
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished){
		[self finishIntroductionAndRemoveSelf];
	}];
}

- (void)setCurrentSlideIndex:(NSInteger)currentSlideIndex {
    [self setCurrentSlideIndex:currentSlideIndex animated:NO];
}

- (void)setCurrentSlideIndex:(NSInteger)currentSlideIndex animated:(BOOL)animated {
    if(currentSlideIndex < 0 || currentSlideIndex >= [self.slides count]) {
        NSLog(@"Wrong currentSlideIndex received: %ld",(long)currentSlideIndex);
        return;
    }
    
    float offset = currentSlideIndex * self.scrollView.frame.size.width;
    CGRect slideRect = { .origin.x = offset, .origin.y = 0.0, .size.width = self.scrollView.frame.size.width, .size.height = self.scrollView.frame.size.height };
    [self.scrollView scrollRectToVisible:slideRect animated:animated];
}

- (IBAction)slideTapped:(id)sender {
    // The tapped method is delegated
    if ([(id)self.delegate respondsToSelector:@selector(slidePlayer:slideTapped:withIndex:)]) {
        [self.delegate slidePlayer:self slideTapped:_slides[self.currentSlideIndex] withIndex:self.currentSlideIndex];
        return;
    }
    
    if(!self.tapToNext) {
        return;
    }
}

- (void)nextSlide {
    if(self.currentSlideIndex + 1 >= [self.slides count]) {
        [self hideWithFadeOutDuration:0.3];
    } else {
        [self setCurrentSlideIndex:self.currentSlideIndex + 1 animated:YES];
    }
}

#pragma mark - Timer

- (void)enableAutoScroll {
    if (self.autoScrollingTimer == nil) {
        self.autoScrollingTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollingInterval
                                                                   target:self
                                                                 selector:@selector(nextSlide)
                                                                 userInfo:nil
                                                                  repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.autoScrollingTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)disableAutoScroll {
    if (self.autoScrollingTimer != nil) {
        [self.autoScrollingTimer invalidate];
        self.autoScrollingTimer = nil;
    }
}

@end