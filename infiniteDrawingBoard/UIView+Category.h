//
//  UIView+Category.h
//  iBazi
//
//  Created by jerry on 15/8/3.
//  Copyright (c) 2015年 jerry. All rights reserved.
//

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

//#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)
//#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)
#define SCREEN_WITHOUT_STATUS_HEIGHT (SCREEN_HEIGHT - [[UIApplication sharedApplication] statusBarFrame].size.height)

#import <UIKit/UIKit.h>

@interface UIView (Category)

// coordinator getters
- (CGFloat)height;
- (CGFloat)width;
- (CGFloat)x;
- (CGFloat)y;
- (CGSize)size;
- (CGPoint)origin;
- (CGFloat)centerX;
- (CGFloat)centerY;
- (CGFloat)bottom;
- (CGFloat)right;

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setRight:(CGFloat)right;
- (void)setBottom:(CGFloat)bottom;

// height
- (void)setHeight:(CGFloat)height;
- (void)heightEqualToView:(UIView *)view;

// width
- (void)setWidth:(CGFloat)width;
- (void)widthEqualToView:(UIView *)view;

// center
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;
- (void)centerXEqualToView:(UIView *)view;
- (void)centerYEqualToView:(UIView *)view;

// top, bottom, left, right
- (void)top:(CGFloat)top FromView:(UIView *)view;
- (void)bottom:(CGFloat)bottom FromView:(UIView *)view;
- (void)left:(CGFloat)left FromView:(UIView *)view;
- (void)right:(CGFloat)right FromView:(UIView *)view;

- (void)topInContainer:(CGFloat)top shouldResize:(BOOL)shouldResize;
- (void)bottomInContainer:(CGFloat)bottom shouldResize:(BOOL)shouldResize;
- (void)leftInContainer:(CGFloat)left shouldResize:(BOOL)shouldResize;
- (void)rightInContainer:(CGFloat)right shouldResize:(BOOL)shouldResize;

- (void)topEqualToView:(UIView *)view;
- (void)bottomEqualToView:(UIView *)view;
- (void)leftEqualToView:(UIView *)view;
- (void)rightEqualToView:(UIView *)view;

// size
- (void)setSize:(CGSize)size;
- (void)sizeEqualToView:(UIView *)view;

// imbueset
- (void)fillWidth;
- (void)fillHeight;
- (void)fill;

- (UIView *)topSuperView;


@end


@protocol LayoutProtocol
@required
// put your layout code here
- (void)calculateLayout;
@end


