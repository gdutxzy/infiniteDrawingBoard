//
//  BYDrawingToolBarView.h
//  iBazi
//
//  Created by mac on 16/10/8.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BYDrawingToolBarViewDelegate <NSObject>
- (void)BYDrawingToolBarViewUndoClick;
- (void)BYDrawingToolBarViewColor:(UIColor *)color;
- (void)BYDrawingToolBarViewLineWidth:(CGFloat)width;
- (void)BYDrawingToolBarViewLeftAddClick;
- (void)BYDrawingToolBarViewRightAddClick;
- (void)BYDrawingToolBarViewAllClick;
@end

@interface BYDrawingToolBarView : UIView
@property (weak,nonatomic) id<BYDrawingToolBarViewDelegate> delegate;
@end
