//
//  BYDrawingBoardViewController.h
//  iBazi
//
//  Created by mac on 16/10/8.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYDrawingBoardViewController : UIViewController
@property (nonatomic,strong) UIView * originView;
//@property (nonatomic,strong) ALAsset * imageALAsset;

/// 从画板库进来时
@property (nonatomic,strong) NSString * imageName;
@end
