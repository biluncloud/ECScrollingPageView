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
    ECScrollingPage *page1 = [ECScrollingPage page];
    page1.title = @"Hello world";
    page1.desc = sampleDescription1;
    page1.bgImage = [UIImage imageNamed:@"bg1"];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    
    ECScrollingPage *page2 = [ECScrollingPage page];
    page2.title = @"This is page 2";
    page2.desc = sampleDescription2;
    page2.bgImage = [UIImage imageNamed:@"bg2"];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    
    ECScrollingPage *page3 = [ECScrollingPage page];
    page3.title = @"This is page 3";
    page3.desc = sampleDescription3;
    page3.bgImage = [UIImage imageNamed:@"bg3"];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    
    ECScrollingPage *page4 = [ECScrollingPage page];
    page4.title = @"This is page 4";
    page4.desc = sampleDescription4;
    page4.bgImage = [UIImage imageNamed:@"bg4"];
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    ECScrollingPageView *scrollingPageView = [[ECScrollingPageView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4]];
    [scrollingPageView setDelegate:self];
    
    // ---
    scrollingPageView.autoScrolling = YES;
    scrollingPageView.swipeToExit = NO;
    // ---
    
    [scrollingPageView showInView:rootView animateDuration:0.3];
}

- (void)showIntroWithFixedTitleView {
    ECScrollingPage *page1 = [ECScrollingPage page];
    page1.title = @"Hello world";
    page1.desc = sampleDescription1;
    
    ECScrollingPage *page2 = [ECScrollingPage page];
    page2.title = @"This is page 2";
    page2.desc = sampleDescription2;
    
    ECScrollingPage *page3 = [ECScrollingPage page];
    page3.title = @"This is page 3";
    page3.desc = sampleDescription3;
    
    ECScrollingPage *page4 = [ECScrollingPage page];
    page4.title = @"This is page 4";
    page4.desc = sampleDescription4;
    
    ECScrollingPageView *scrollingPageView = [[ECScrollingPageView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4]];
    [scrollingPageView setDelegate:self];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    scrollingPageView.titleView = titleView;
    scrollingPageView.titleViewY = 90;
    scrollingPageView.backgroundColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f]; //iOS7 dark blue

    [scrollingPageView showInView:rootView animateDuration:0.3];
}

- (void)showIntroWithCustomPages {
    ECScrollingPage *page1 = [ECScrollingPage page];
    page1.title = @"Hello world";
    page1.desc = sampleDescription1;
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    
    ECScrollingPage *page2 = [ECScrollingPage page];
    page2.title = @"This is page 2";
    page2.titlePositionY = self.view.bounds.size.height/2 - 10;
    page2.desc = sampleDescription2;
    page2.descPositionY = self.view.bounds.size.height/2 - 50;
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    page2.titleIconPositionY = 70;
    
    ECScrollingPage *page3 = [ECScrollingPage page];
    page3.title = @"This is page 3";
    page3.titleFont = [UIFont fontWithName:@"Georgia-BoldItalic" size:20];
    page3.titlePositionY = 220;
    page3.desc = sampleDescription2;
    page3.descFont = [UIFont fontWithName:@"Georgia-Italic" size:18];
    page3.descPositionY = 200;
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    page3.titleIconPositionY = 100;
    
    ECScrollingPage *page4 = [ECScrollingPage page];
    page4.title = @"This is page 4";
    page4.desc = sampleDescription4;
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    ECScrollingPageView *scrollingPageView = [[ECScrollingPageView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4]];
    scrollingPageView.bgImage = [UIImage imageNamed:@"bg2"];
    
    scrollingPageView.pageControlY = 250.0f;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake((320-230)/2, [UIScreen mainScreen].bounds.size.height - 60, 230, 40)];
    [btn setTitle:@"SKIP NOW" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 2.0f;
    btn.layer.cornerRadius = 10;
    btn.layer.borderColor = [[UIColor whiteColor] CGColor];
    scrollingPageView.skipButton = btn;
    
    [scrollingPageView setDelegate:self];
    [scrollingPageView showInView:rootView animateDuration:0.3];
}

- (void)showIntroWithCustomView {
    ECScrollingPage *page1 = [ECScrollingPage page];
    page1.title = @"Hello world";
    page1.desc = sampleDescription1;
    page1.bgImage = [UIImage imageNamed:@"bg1"];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    
    UIView *viewForPage2 = [[UIView alloc] initWithFrame:self.view.bounds];
    UILabel *labelForPage2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, 300, 30)];
    labelForPage2.text = @"Some custom view";
    labelForPage2.font = [UIFont systemFontOfSize:32];
    labelForPage2.textColor = [UIColor whiteColor];
    labelForPage2.backgroundColor = [UIColor clearColor];
    labelForPage2.transform = CGAffineTransformMakeRotation(M_PI_2*3);
    [viewForPage2 addSubview:labelForPage2];
    ECScrollingPage *page2 = [ECScrollingPage pageWithCustomView:viewForPage2];
    page2.bgImage = [UIImage imageNamed:@"bg2"];
    
    ECScrollingPage *page3 = [ECScrollingPage page];
    page3.title = @"This is page 3";
    page3.desc = sampleDescription3;
    page3.bgImage = [UIImage imageNamed:@"bg3"];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    
    ECScrollingPage *page4 = [ECScrollingPage page];
    page4.title = @"This is page 4";
    page4.desc = sampleDescription4;
    page4.bgImage = [UIImage imageNamed:@"bg4"];
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    ECScrollingPageView *scrollingPageView = [[ECScrollingPageView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4]];
    [scrollingPageView setDelegate:self];
    
    [scrollingPageView showInView:rootView animateDuration:0.3];
}

- (void)showIntroWithCustomViewFromNib {
    ECScrollingPage *page1 = [ECScrollingPage page];
    page1.title = @"Hello world";
    page1.desc = sampleDescription1;
    page1.bgImage = [UIImage imageNamed:@"bg1"];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    
    ECScrollingPage *page2 = [ECScrollingPage pageWithCustomViewFromNibNamed:@"IntroPage"];
    page2.bgImage = [UIImage imageNamed:@"bg2"];
    
    ECScrollingPage *page3 = [ECScrollingPage page];
    page3.title = @"This is page 3";
    page3.desc = sampleDescription3;
    page3.bgImage = [UIImage imageNamed:@"bg3"];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    
    ECScrollingPage *page4 = [ECScrollingPage page];
    page4.title = @"This is page 4";
    page4.desc = sampleDescription4;
    page4.bgImage = [UIImage imageNamed:@"bg4"];
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    ECScrollingPageView *scrollingPageView = [[ECScrollingPageView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4]];
    [scrollingPageView setDelegate:self];
    
    [scrollingPageView showInView:rootView animateDuration:0.3];
}

- (void)showIntroWithSeparatePagesInitAndPageCallback {
    ECScrollingPage *page1 = [ECScrollingPage page];
    page1.title = @"Hello world";
    page1.desc = sampleDescription1;
    page1.bgImage = [UIImage imageNamed:@"bg1"];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    
    ECScrollingPage *page2 = [ECScrollingPage page];
    page2.title = @"This is page 2";
    page2.desc = sampleDescription2;
    page2.bgImage = [UIImage imageNamed:@"bg2"];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    page2.onPageDidAppear = ^{
        NSLog(@"Page 2 did appear block");
    };
    
    ECScrollingPage *page3 = [ECScrollingPage page];
    page3.title = @"This is page 3";
    page3.desc = sampleDescription3;
    page3.bgImage = [UIImage imageNamed:@"bg3"];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    
    ECScrollingPage *page4 = [ECScrollingPage page];
    page4.title = @"This is page 4";
    page4.desc = sampleDescription4;
    page4.bgImage = [UIImage imageNamed:@"bg4"];
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    ECScrollingPageView *scrollingPageView = [[ECScrollingPageView alloc] initWithFrame:rootView.bounds];
    [scrollingPageView setDelegate:self];
    [scrollingPageView setPages:@[page1,page2,page3,page4]];
    
    [scrollingPageView showInView:rootView animateDuration:0.3];
}

- (void)showCustomIntro {
    ECScrollingPage *page1 = [ECScrollingPage page];
    page1.title = @"Hello world";
    page1.titlePositionY = 240;
    page1.desc = sampleDescription1;
    page1.descPositionY = 220;
    page1.bgImage = [UIImage imageNamed:@"bg1"];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    page1.titleIconPositionY = 100;
    page1.showTitleView = NO;
    
    ECScrollingPage *page2 = [ECScrollingPage page];
    page2.title = @"This is page 2";
    page2.titlePositionY = 240;
    page2.desc = sampleDescription2;
    page2.descPositionY = 220;
    page2.bgImage = [UIImage imageNamed:@"bg2"];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon1"]];
    page2.titleIconPositionY = 260;
    
    ECScrollingPage *page3 = [ECScrollingPage page];
    page3.title = @"This is page 3";
    page3.titlePositionY = 240;
    page3.desc = sampleDescription3;
    page3.descPositionY = 220;
    page3.bgImage = [UIImage imageNamed:@"bg3"];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon2"]];
    page3.titleIconPositionY = 260;
    
    ECScrollingPage *page4 = [ECScrollingPage page];
    page4.title = @"This is page 4";
    page4.titlePositionY = 240;
    page4.desc = sampleDescription4;
    page4.descPositionY = 220;
    page4.bgImage = [UIImage imageNamed:@"bg4"];
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon3"]];
    page4.titleIconPositionY = 260;
    
    ECScrollingPageView *scrollingPageView = [[ECScrollingPageView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4]];
    scrollingPageView.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigLogo"]];
    scrollingPageView.titleViewY = 120;
    scrollingPageView.tapToNext = YES;
    [scrollingPageView setDelegate:self];
    
    SMPageControl *pageControl = [[SMPageControl alloc] init];
    pageControl.pageIndicatorImage = [UIImage imageNamed:@"pageDot"];
    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"selectedPageDot"];
    [pageControl sizeToFit];
    scrollingPageView.pageControl = (UIPageControl *)pageControl;
    scrollingPageView.pageControlY = 130.0f;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"skipButton"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake((320-270)/2, [UIScreen mainScreen].bounds.size.height - 80, 270, 50)];
    scrollingPageView.skipButton = btn;
    
    [scrollingPageView showInView:rootView animateDuration:0.3];
}

- (void)scrollingPageViewDidFinish:(ECScrollingPageView *)scrollingPageView {
    NSLog(@"scrollingPageViewDidFinish callback");
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // all settings are basic, pages with custom packgrounds, title image on each page
        [self showIntroWithCrossDissolve];
    } else if (indexPath.row == 1) {
        // all settings are basic, scrollingPageView with colored background, fixed title image
        [self showIntroWithFixedTitleView];
    } else if (indexPath.row == 2) {
        // basic pages with custom settings
        [self showIntroWithCustomPages];
    } else if (indexPath.row == 3) {
        // using page with custom view
        [self showIntroWithCustomView];
    } else if (indexPath.row == 4) {
        // using page with custom view from nib
        [self showIntroWithCustomViewFromNib];
    } else if (indexPath.row == 5) {
        // pages separate init and using block callback in one of pages
        [self showIntroWithSeparatePagesInitAndPageCallback];
    } else if (indexPath.row == 6) {
        // show custom scrollingPageView 
        [self showCustomIntro];
    }
}

@end
