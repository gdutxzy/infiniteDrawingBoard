//
//  BYDrawingBoardScrollView.m
//  iBazi
//
//  Created by mac on 16/10/10.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "BYDrawingBoardScrollView.h"

@implementation BYDrawingBoardScrollView


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delaysContentTouches = NO;
        self.panGestureRecognizer.minimumNumberOfTouches = 2;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delaysContentTouches = NO;
        self.panGestureRecognizer.minimumNumberOfTouches = 2;
    }
    return self;
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [super touchesBegan:touches withEvent:event];
    self.delaysContentTouches = NO;
//    if([event.allTouches count] == 1)
//    {
        [self.parentResponder touchesBegan:touches withEvent:event];
//    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [super touchesMoved:touches withEvent:event];
//    if([event.allTouches count] == 1)
//    {
    
        [self.parentResponder touchesMoved:touches withEvent:event];
//    }
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [super touchesEnded:touches withEvent:event];
//    if([event.allTouches count] == 1)
//    {
        [self.parentResponder touchesEnded:touches withEvent:event];
//    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [super touchesCancelled:touches withEvent:event];
//    if([event.allTouches count] == 1)
//    {
        [self.parentResponder touchesCancelled:touches withEvent:event];
//    }
}

@end
