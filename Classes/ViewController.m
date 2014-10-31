//
//  ViewController.m
//
//  Copyright (c) 2013-2014 Evgeny Aleksandrov. License: MIT.

#import "ViewController.h"
#import "SMPageControl.h"
#import <QuartzCore/QuartzCore.h>

static NSString * const sampleDescription1 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
static NSString * const sampleDescription2 = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
static NSString * const sampleDescription3 = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
static NSString * const sampleDescription4 = @"Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit.";

@interface ViewController () {
    UIView *rootView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // using self.navigationController.view - to display ECScrollingPageView above navigation bar
    rootView = self.navigationController.view;
}

- (void)showIntroWithCrossDissolve {
    ECSlide *slide1 = [ECSlide slide];
    slide1.title = @"Hello world";
    slide1.desc = sampleDescription1;
    slide1.bgImage = [UIImage imageNamed:@"bg1"];
    slide1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    
    ECSlide *slide2 = [ECSlide slide];
    slide2.title = @"This is page 2";
    slide2.desc = sampleDescription2;
    slide2.bgImage = [UIImage imageNamed:@"bg2"];
    slide2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    
    ECSlide *slide3 = [ECSlide slide];
    slide3.title = @"This is page 3";
    slide3.desc = sampleDescription3;
    slide3.bgImage = [UIImage imageNamed:@"bg3"];
    slide3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    
    ECSlide *slide4 = [ECSlide slide];
    slide4.title = @"This is page 4";
    slide4.desc = sampleDescription4;
    slide4.bgImage = [UIImage imageNamed:@"bg4"];
    slide4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    ECSlidePlayer *slidePlayer = [[ECSlidePlayer alloc] initWithFrame:rootView.bounds andSlides:@[slide1,slide2,slide3,slide4]];
    [slidePlayer setDelegate:self];
    slidePlayer.showMode = kSlidePlayerModeIntroduction;
    slidePlayer.tapToNext = YES;
    
    [slidePlayer showInView:rootView animateDuration:0.3];
}

- (void)showIntroWithFixedTitleView {
    ECSlide *slide1 = [ECSlide slide];
    slide1.title = @"Hello world";
    slide1.desc = sampleDescription1;
    
    ECSlide *slide2 = [ECSlide slide];
    slide2.title = @"This is page 2";
    slide2.desc = sampleDescription2;
    
    ECSlide *slide3 = [ECSlide slide];
    slide3.title = @"This is page 3";
    slide3.desc = sampleDescription3;
    
    ECSlide *slide4 = [ECSlide slide];
    slide4.title = @"This is page 4";
    slide4.desc = sampleDescription4;
    
//    ECSlidePlayer *slidePlayer = [[ECSlidePlayer alloc] initWithFrame:rootView.bounds andSlides:@[slide1,slide2,slide3,slide4]];
    ECSlidePlayer *slidePlayer = [[ECSlidePlayer alloc] initWithFrame:rootView.bounds andSlides:@[slide1,slide2]];
    [slidePlayer setDelegate:self];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    slidePlayer.titleView = titleView;
    slidePlayer.titleViewY = 90;
    slidePlayer.backgroundColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f]; //iOS7 dark blue
    
    slidePlayer.showMode = kSlidePlayerModeCustom;
    slidePlayer.borderBehavior = kSliderPlayerBorderBehaviorLoop;
    slidePlayer.tapToNext = YES;
    slidePlayer.autoScrolling = NO;

    [slidePlayer showInView:rootView animateDuration:0.3];
}

- (void)showIntroWithCustomPages {
    ECSlide *slide1 = [ECSlide slide];
    slide1.title = @"Hello world";
    slide1.desc = sampleDescription1;
    slide1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    
    ECSlide *slide2 = [ECSlide slide];
    slide2.title = @"This is page 2";
    slide2.titlePositionY = self.view.bounds.size.height/2 - 10;
    slide2.desc = sampleDescription2;
    slide2.descPositionY = self.view.bounds.size.height/2 - 50;
    slide2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    slide2.titleIconPositionY = 70;
    
    ECSlide *slide3 = [ECSlide slide];
    slide3.title = @"This is page 3";
    slide3.titleFont = [UIFont fontWithName:@"Georgia-BoldItalic" size:20];
    slide3.titlePositionY = 220;
    slide3.desc = sampleDescription2;
    slide3.descFont = [UIFont fontWithName:@"Georgia-Italic" size:18];
    slide3.descPositionY = 200;
    slide3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    slide3.titleIconPositionY = 100;
    
    ECSlide *slide4 = [ECSlide slide];
    slide4.title = @"This is page 4";
    slide4.desc = sampleDescription4;
    slide4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    ECSlidePlayer *slidePlayer = [[ECSlidePlayer alloc] initWithFrame:rootView.bounds andSlides:@[slide1,slide2,slide3,slide4]];
    slidePlayer.bgImage = [UIImage imageNamed:@"bg2"];
    
    slidePlayer.pageControlY = 250.0f;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake((320-230)/2, [UIScreen mainScreen].bounds.size.height - 60, 230, 40)];
    [btn setTitle:@"SKIP NOW" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 2.0f;
    btn.layer.cornerRadius = 10;
    btn.layer.borderColor = [[UIColor whiteColor] CGColor];
    slidePlayer.skipButton = btn;
    
    [slidePlayer setDelegate:self];
    slidePlayer.showMode = kSlidePlayerModeScrollImage;
    
    [slidePlayer showInView:rootView animateDuration:0.3];
}

- (void)showIntroWithCustomView {
    ECSlide *slide1 = [ECSlide slide];
    slide1.title = @"Hello world";
    slide1.desc = sampleDescription1;
    slide1.bgImage = [UIImage imageNamed:@"bg1"];
    slide1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    
    UIView *viewForslide2 = [[UIView alloc] initWithFrame:self.view.bounds];
    UILabel *labelForslide2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, 300, 30)];
    labelForslide2.text = @"Some custom view";
    labelForslide2.font = [UIFont systemFontOfSize:32];
    labelForslide2.textColor = [UIColor whiteColor];
    labelForslide2.backgroundColor = [UIColor clearColor];
    labelForslide2.transform = CGAffineTransformMakeRotation(M_PI_2*3);
    [viewForslide2 addSubview:labelForslide2];
    ECSlide *slide2 = [ECSlide slideWithCustomView:viewForslide2];
    slide2.bgImage = [UIImage imageNamed:@"bg2"];
    
    ECSlide *slide3 = [ECSlide slide];
    slide3.title = @"This is page 3";
    slide3.desc = sampleDescription3;
    slide3.bgImage = [UIImage imageNamed:@"bg3"];
    slide3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    
    ECSlide *slide4 = [ECSlide slide];
    slide4.title = @"This is page 4";
    slide4.desc = sampleDescription4;
    slide4.bgImage = [UIImage imageNamed:@"bg4"];
    slide4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    ECSlidePlayer *slidePlayer = [[ECSlidePlayer alloc] initWithFrame:rootView.bounds andSlides:@[slide1,slide2,slide3,slide4]];
    [slidePlayer setDelegate:self];
    
    [slidePlayer showInView:rootView animateDuration:0.3];
}

- (void)showIntroWithCustomViewFromNib {
    ECSlide *slide1 = [ECSlide slide];
    slide1.title = @"Hello world";
    slide1.desc = sampleDescription1;
    slide1.bgImage = [UIImage imageNamed:@"bg1"];
    slide1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    
    ECSlide *slide2 = [ECSlide slideWithCustomViewFromNibNamed:@"IntroPage"];
    slide2.bgImage = [UIImage imageNamed:@"bg2"];
    
    ECSlide *slide3 = [ECSlide slide];
    slide3.title = @"This is page 3";
    slide3.desc = sampleDescription3;
    slide3.bgImage = [UIImage imageNamed:@"bg3"];
    slide3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    
    ECSlide *slide4 = [ECSlide slide];
    slide4.title = @"This is page 4";
    slide4.desc = sampleDescription4;
    slide4.bgImage = [UIImage imageNamed:@"bg4"];
    slide4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    ECSlidePlayer *slidePlayer = [[ECSlidePlayer alloc] initWithFrame:rootView.bounds andSlides:@[slide1,slide2,slide3,slide4]];
    [slidePlayer setDelegate:self];
    
    [slidePlayer showInView:rootView animateDuration:0.3];
}

- (void)showIntroWithSeparatePagesInitAndPageCallback {
    ECSlide *slide1 = [ECSlide slide];
    slide1.title = @"Hello world";
    slide1.desc = sampleDescription1;
    slide1.bgImage = [UIImage imageNamed:@"bg1"];
    slide1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    
    ECSlide *slide2 = [ECSlide slide];
    slide2.title = @"This is page 2";
    slide2.desc = sampleDescription2;
    slide2.bgImage = [UIImage imageNamed:@"bg2"];
    slide2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    slide2.onSlideDidAppear = ^{
        NSLog(@"Page 2 did appear block");
    };
    
    ECSlide *slide3 = [ECSlide slide];
    slide3.title = @"This is page 3";
    slide3.desc = sampleDescription3;
    slide3.bgImage = [UIImage imageNamed:@"bg3"];
    slide3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    
    ECSlide *slide4 = [ECSlide slide];
    slide4.title = @"This is page 4";
    slide4.desc = sampleDescription4;
    slide4.bgImage = [UIImage imageNamed:@"bg4"];
    slide4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    ECSlidePlayer *slidePlayer = [[ECSlidePlayer alloc] initWithFrame:rootView.bounds];
    [slidePlayer setDelegate:self];
    [slidePlayer setSlides:@[slide1,slide2,slide3,slide4]];
    
    [slidePlayer showInView:rootView animateDuration:0.3];
}

- (void)showCustomIntro {
    ECSlide *slide1 = [ECSlide slide];
    slide1.title = @"Hello world";
    slide1.titlePositionY = 240;
    slide1.desc = sampleDescription1;
    slide1.descPositionY = 220;
    slide1.bgImage = [UIImage imageNamed:@"bg1"];
    slide1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    slide1.titleIconPositionY = 100;
    slide1.showTitleView = NO;
    
    ECSlide *slide2 = [ECSlide slide];
    slide2.title = @"This is page 2";
    slide2.titlePositionY = 240;
    slide2.desc = sampleDescription2;
    slide2.descPositionY = 220;
    slide2.bgImage = [UIImage imageNamed:@"bg2"];
    slide2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon1"]];
    slide2.titleIconPositionY = 260;
    
    ECSlide *slide3 = [ECSlide slide];
    slide3.title = @"This is page 3";
    slide3.titlePositionY = 240;
    slide3.desc = sampleDescription3;
    slide3.descPositionY = 220;
    slide3.bgImage = [UIImage imageNamed:@"bg3"];
    slide3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon2"]];
    slide3.titleIconPositionY = 260;
    
    ECSlide *slide4 = [ECSlide slide];
    slide4.title = @"This is page 4";
    slide4.titlePositionY = 240;
    slide4.desc = sampleDescription4;
    slide4.descPositionY = 220;
    slide4.bgImage = [UIImage imageNamed:@"bg4"];
    slide4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon3"]];
    slide4.titleIconPositionY = 260;
    
    ECSlidePlayer *slidePlayer = [[ECSlidePlayer alloc] initWithFrame:rootView.bounds andSlides:@[slide1,slide2,slide3,slide4]];
    slidePlayer.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigLogo"]];
    slidePlayer.titleViewY = 120;
    slidePlayer.tapToNext = YES;
    [slidePlayer setDelegate:self];
    
    SMPageControl *pageControl = [[SMPageControl alloc] init];
    pageControl.pageIndicatorImage = [UIImage imageNamed:@"pageDot"];
    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"selectedPageDot"];
    [pageControl sizeToFit];
    slidePlayer.pageControl = (UIPageControl *)pageControl;
    slidePlayer.pageControlY = 130.0f;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"skipButton"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake((320-270)/2, [UIScreen mainScreen].bounds.size.height - 80, 270, 50)];
    slidePlayer.skipButton = btn;
    
    [slidePlayer showInView:rootView animateDuration:0.3];
}

- (void)slidePlayerDidFinish:(ECSlidePlayer *)slidePlayer {
    NSLog(@"scrollingPageViewDidFinish callback");
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // all settings are basic, slides with custom packgrounds, title image on each slide
        [self showIntroWithCrossDissolve];
    } else if (indexPath.row == 1) {
        // all settings are basic, slidePlayer with colored background, fixed title image
        [self showIntroWithFixedTitleView];
    } else if (indexPath.row == 2) {
        // basic slides with custom settings
        [self showIntroWithCustomPages];
    } else if (indexPath.row == 3) {
        // using slide with custom view
        [self showIntroWithCustomView];
    } else if (indexPath.row == 4) {
        // using slide with custom view from nib
        [self showIntroWithCustomViewFromNib];
    } else if (indexPath.row == 5) {
        // slides separate init and using block callback in one of slide
        [self showIntroWithSeparatePagesInitAndPageCallback];
    } else if (indexPath.row == 6) {
        // show custom slidePlayer 
        [self showCustomIntro];
    }
}

@end
