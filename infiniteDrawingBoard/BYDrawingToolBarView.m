//
//  BYDrawingToolBarView.m
//  iBazi
//
//  Created by mac on 16/10/8.
//  Copyright © 2016年 jerry. All rights reserved.
//


#define UIColorFromHex(hex) [UIColor colorWithRed:(((hex & 0xFF0000) >> 16))/255.0 green:(((hex &0xFF00) >>8))/255.0 blue:((hex &0xFF))/255.0 alpha:1.0]


#import "BYDrawingToolBarView.h"
#import "UIView+Category.h"

@interface BYDrawingToolBarView ()
@property (nonatomic,strong) UIButton * undoButton;
@property (nonatomic,strong) UIButton * colorButton;
@property (nonatomic,strong) UIButton * widthButton;
@property (nonatomic,strong) UIButton * leftaddButton;
@property (nonatomic,strong) UIButton * rightAddButton;
@property (nonatomic,strong) UIButton * allButton;

@property (nonatomic,strong) UIColor * color;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,strong) NSArray * colorArry;

@property (nonatomic,strong) UIView * selectView;
@end

@implementation BYDrawingToolBarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView:frame];
    }
    return self;
}

- (void)setupView:(CGRect)frame{
    CGFloat width = frame.size.width/6.0;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.undoButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, frame.size.height)];
    [self.undoButton setImage:[UIImage imageNamed:@"drawing_undo"] forState:UIControlStateNormal];
    [self addSubview:self.undoButton];
    [self.undoButton addTarget:self action:@selector(bottonclick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.colorButton = [[UIButton alloc]initWithFrame:CGRectMake(1*width,0,  width, frame.size.height)];
    [self.colorButton setImage:[UIImage imageNamed:@"drawing_lineColor"] forState:UIControlStateNormal];
    [self addSubview:self.colorButton];
    [self.colorButton addTarget:self action:@selector(bottonclick:) forControlEvents:UIControlEventTouchUpInside];

    self.widthButton = [[UIButton alloc]initWithFrame:CGRectMake(2*width,0,  width, frame.size.height)];
    [self.widthButton setImage:[UIImage imageNamed:@"drawing_lineWidth"] forState:UIControlStateNormal];
    [self addSubview:self.widthButton];
    [self.widthButton addTarget:self action:@selector(bottonclick:) forControlEvents:UIControlEventTouchUpInside];

    self.leftaddButton = [[UIButton alloc]initWithFrame:CGRectMake(3*width,0,  width, frame.size.height)];
    [self.leftaddButton setImage:[UIImage imageNamed:@"drawing_leftAdd"] forState:UIControlStateNormal];
    [self addSubview:self.leftaddButton];
    [self.leftaddButton addTarget:self action:@selector(bottonclick:) forControlEvents:UIControlEventTouchUpInside];

    self.rightAddButton = [[UIButton alloc]initWithFrame:CGRectMake( 4*width,0,  width, frame.size.height)];
    [self.rightAddButton setImage:[UIImage imageNamed:@"drawing_rightAdd"] forState:UIControlStateNormal];
    [self addSubview:self.rightAddButton];
    [self.rightAddButton addTarget:self action:@selector(bottonclick:) forControlEvents:UIControlEventTouchUpInside];

    self.allButton = [[UIButton alloc]initWithFrame:CGRectMake( 5*width,0,  width, frame.size.height)];
    [self.allButton setImage:[UIImage imageNamed:@"drawing_all"] forState:UIControlStateNormal];
    [self addSubview:self.allButton];
    [self.allButton addTarget:self action:@selector(bottonclick:) forControlEvents:UIControlEventTouchUpInside];

    self.color = [UIColor redColor];
    self.width = 1;
    self.colorArry = @[[UIColor redColor],[UIColor colorWithRed:17/255.0 green:118/255.0 blue:185/255.0 alpha:1],[UIColor colorWithRed:27/255.0 green:113/255.0 blue:22/255.0 alpha:1],UIColorFromHex(0x676767)];
}

- (void)bottonclick:(UIButton *)button{
    if (button == self.undoButton) {
        if ([self.delegate respondsToSelector:@selector(BYDrawingToolBarViewUndoClick)]) {
            [self.delegate BYDrawingToolBarViewUndoClick];
        }
        [self selectViewRemove];
    }else if (button == self.colorButton){
        [self setupColorMenum];
    }else if (button == self.widthButton){
        [self setupWidthMenum];
    }else if (button == self.leftaddButton){
        if ([self.delegate respondsToSelector:@selector(BYDrawingToolBarViewLeftAddClick)]) {
            [self.delegate BYDrawingToolBarViewLeftAddClick];
        }
        [self selectViewRemove];

    }else if (button == self.rightAddButton){
        if ([self.delegate respondsToSelector:@selector(BYDrawingToolBarViewRightAddClick)]) {
            [self.delegate BYDrawingToolBarViewRightAddClick];
        }
        [self selectViewRemove];

    }else if (button == self.allButton){
        if ([self.delegate respondsToSelector:@selector(BYDrawingToolBarViewAllClick)]) {
            [self.delegate BYDrawingToolBarViewAllClick];
        }
        [self selectViewRemove];
        
    }

}

- (void)setupColorMenum{
    [self selectViewRemove];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 98/2.0, 257/2.0)];
    view.centerX = self.colorButton.centerX;
    view.bottom = self.colorButton.y + 5;
    [self addSubview:view];
    self.selectView = view;
    UIImageView * imageview = [[UIImageView alloc]initWithFrame:view.bounds];
    [view addSubview:imageview];
    imageview.image = [UIImage imageNamed:@"drawing_showMore"];
    
    NSMutableArray * arry = [NSMutableArray arrayWithArray:self.colorArry];
    [arry removeObject:self.color];
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(7, 8, 35, 35)];
    button.tintColor = arry[0];
    [button setImage:[[UIImage imageNamed:@"drawing_lineColor"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(colorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    button = [[UIButton alloc]initWithFrame:CGRectMake(7, 44, 35, 35)];
    button.tintColor = arry[1];
    [button setImage:[[UIImage imageNamed:@"drawing_lineColor"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(colorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    button = [[UIButton alloc]initWithFrame:CGRectMake(7, 80, 35, 35)];
    button.tintColor = arry[2];
    [button setImage:[[UIImage imageNamed:@"drawing_lineColor"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(colorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];

}

- (void)setupWidthMenum{
    [self selectViewRemove];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 98/2.0, 257/2.0)];
    view.centerX = self.widthButton.centerX;
    view.bottom = self.widthButton.y + 5;
    [self addSubview:view];
    self.selectView = view;
    UIImageView * imageview = [[UIImageView alloc]initWithFrame:view.bounds];
    [view addSubview:imageview];
    imageview.image = [UIImage imageNamed:@"drawing_showMore"];
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(7, 13, 35, 30)];
    [button addSubview:({UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 14, 35, 4)];
        view.backgroundColor = self.color;
        view;
    })];
//    button.backgroundColor = [UIColor yellowColor];
    [button addTarget:self action:@selector(fourwidthbuttonclick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
     button = [[UIButton alloc]initWithFrame:CGRectMake(7, 44, 35, 30)];
    [button addSubview:({UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 35, 2)];
        view.backgroundColor = self.color;
        view;
    })];
    [button addTarget:self action:@selector(twowidthbuttonclick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
//    button.backgroundColor = [UIColor grayColor];

    button = [[UIButton alloc]initWithFrame:CGRectMake(7, 75, 35, 30)];
    [button addSubview:({UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 35, 1)];
        view.backgroundColor = self.color;
        view;
    })];
    [button addTarget:self action:@selector(OneWidthButtonclick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
//    button.backgroundColor = [UIColor yellowColor];

}

- (void)selectViewRemove{
    [self.selectView removeFromSuperview];
}

- (void)colorButtonClick:(UIButton *)button{
    self.color = button.tintColor;
    if ([self.delegate respondsToSelector:@selector(BYDrawingToolBarViewColor:)]) {
        [self.delegate BYDrawingToolBarViewColor:self.color];
    }
    [self selectViewRemove];
    self.widthButton.tintColor = self.color;
    [self.widthButton setImage:[[UIImage imageNamed:@"drawing_lineWidth"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.colorButton.tintColor = self.color;
    [self.colorButton setImage:[[UIImage imageNamed:@"drawing_lineColor"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];

}


- (void)bluebuttonclick{
    self.color = self.colorArry[1];
    if ([self.delegate respondsToSelector:@selector(BYDrawingToolBarViewColor:)]) {
        [self.delegate BYDrawingToolBarViewColor:self.color];
    }
    [self selectViewRemove];
    self.widthButton.tintColor = self.color;
    [self.widthButton setImage:[[UIImage imageNamed:@"drawing_lineWidth"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
}
- (void)greenbuttonclick{
    self.color = self.colorArry[2];
    if ([self.delegate respondsToSelector:@selector(BYDrawingToolBarViewColor:)]) {
        [self.delegate BYDrawingToolBarViewColor:self.color];
    }
    [self selectViewRemove];
    self.widthButton.tintColor = self.color;
    [self.widthButton setImage:[[UIImage imageNamed:@"drawing_lineWidth"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
}
- (void)graybuttonclick{
    self.color = self.colorArry[3];
    if ([self.delegate respondsToSelector:@selector(BYDrawingToolBarViewColor:)]) {
        [self.delegate BYDrawingToolBarViewColor:self.color];
    }
    [self selectViewRemove];
    self.widthButton.tintColor = self.color;
    [self.widthButton setImage:[[UIImage imageNamed:@"drawing_lineWidth"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
}


- (void)OneWidthButtonclick{
    if ([self.delegate respondsToSelector:@selector(BYDrawingToolBarViewLineWidth:)]) {
        [self.delegate BYDrawingToolBarViewLineWidth:1];
    }
    [self selectViewRemove];

}

- (void)twowidthbuttonclick{
    if ([self.delegate respondsToSelector:@selector(BYDrawingToolBarViewLineWidth:)]) {
        [self.delegate BYDrawingToolBarViewLineWidth:2];
    }
    [self selectViewRemove];

}

- (void)fourwidthbuttonclick{
    if ([self.delegate respondsToSelector:@selector(BYDrawingToolBarViewLineWidth:)]) {
        [self.delegate BYDrawingToolBarViewLineWidth:4];
    }
    [self selectViewRemove];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = [subView hitTest:tp withEvent:event];
            }
        }
    }
    if (view == nil) {
        [self selectViewRemove];
    }
    return view;
}

@end
