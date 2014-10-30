//
//  ECSlide.h
//
//  Copyright (c) 2013-2014 Evgeny Aleksandrov. License: MIT.
//  
//  This is forked from EAIntroView by Evgeny Aleksandrov.
//  Usage is enhanced, not only introduction but also scrolling
//  images such as advertisement are supported too. 

#import <Foundation/Foundation.h>

typedef void (^VoidBlock)();

@interface ECSlide : NSObject

// background used for cross-dissolve
@property (nonatomic, strong) UIImage *bgImage;
// show or hide ECSlidePlayer titleView on this slide (default YES)
@property (nonatomic, assign) bool showTitleView;


// properties for default ECSlide layout
//
// title image Y position - from top of the screen
// title and description labels Y position - from bottom of the screen
// all items from subviews array will be added on slide

/**
* The title view that is presented above the title label.
* The view can be a normal UIImageView or any other kind uf
* UIView. This allows to attach animated views as well.
*/
@property (nonatomic, strong) UIView * titleIconView;

@property (nonatomic, assign) CGFloat titleIconPositionY;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) CGFloat titlePositionY;

@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) UIFont *descFont;
@property (nonatomic, strong) UIColor *descColor;
@property (nonatomic, assign) CGFloat descWidth;
@property (nonatomic, assign) CGFloat descPositionY;

@property (nonatomic, strong) NSArray *subviews;

@property (nonatomic,copy) VoidBlock onSlideDidLoad;
@property (nonatomic,copy) VoidBlock onSlideDidAppear;
@property (nonatomic,copy) VoidBlock onSlideDidDisappear;


// if customView is set - all other default properties are ignored
@property (nonatomic, strong) UIView *customView;

@property(nonatomic, strong, readonly) UIView *slideView;

+ (instancetype)slide;
+ (instancetype)slideWithCustomView:(UIView *)customV;
+ (instancetype)slideWithCustomViewFromNibNamed:(NSString *)nibName;

@end
