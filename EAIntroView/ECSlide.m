//
//  ECSlide.m
//
//  Copyright (c) 2013-2014 Evgeny Aleksandrov. License: MIT.
//  
//  This is forked from EAIntroView by Evgeny Aleksandrov.
//  Usage is enhanced, not only introduction but also scrolling
//  images such as advertisement are supported too. 

#import "ECSlide.h"

#define DEFAULT_DESCRIPTION_LABEL_SIDE_PADDING 25
#define DEFAULT_TITLE_FONT [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]
#define DEFAULT_LABEL_COLOR [UIColor whiteColor]
#define DEFAULT_DESCRIPTION_FONT [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0]
#define DEFAULT_TITLE_IMAGE_Y_POSITION 50.0f
#define DEFAULT_TITLE_LABEL_Y_POSITION 160.0f
#define DEFAULT_DESCRIPTION_LABEL_Y_POSITION 140.0f

@interface ECSlide ()
@property(nonatomic, strong, readwrite) UIView *slideView;
@end

@implementation ECSlide

#pragma mark - Slide lifecycle

- (instancetype)init {
    if (self = [super init]) {
        _titleIconPositionY = DEFAULT_TITLE_IMAGE_Y_POSITION;
        _titlePositionY  = DEFAULT_TITLE_LABEL_Y_POSITION;
        _descPositionY   = DEFAULT_DESCRIPTION_LABEL_Y_POSITION;
        _title = @"";
        _titleFont = DEFAULT_TITLE_FONT;
        _titleColor = DEFAULT_LABEL_COLOR;
        _desc = @"";
        _descFont = DEFAULT_DESCRIPTION_FONT;
        _descColor = DEFAULT_LABEL_COLOR;
        _showTitleView = YES;
    }
    return self;
}

+ (instancetype)slide {
    return [[self alloc] init];
}

+ (instancetype)slideWithCustomView:(UIView *)customV {
    ECSlide *newSlide = [[self alloc] init];
    newSlide.customView = customV;
    return newSlide;
}

+ (instancetype)slideWithCustomViewFromNibNamed:(NSString *)nibName {
    return [self slideWithCustomViewFromNibNamed:nibName bundle:[NSBundle mainBundle]];
}

+ (instancetype)slideWithCustomViewFromNibNamed:(NSString *)nibName bundle:(NSBundle*)aBundle {
    ECSlide *newSlide = [[self alloc] init];
    newSlide.customView = [[aBundle loadNibNamed:nibName owner:newSlide options:nil] firstObject];
    return newSlide;
}

@end
