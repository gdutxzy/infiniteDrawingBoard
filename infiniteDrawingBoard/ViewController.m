//
//  ViewController.m
//  infiniteDrawingBoard
//
//  Created by mac on 01/1/1.
//  Copyright © 2001年 mac. All rights reserved.
//

#import "ViewController.h"
#import "BYDrawingBoardViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)presentToDrawingBoard:(UIButton *)sender {
    BYDrawingBoardViewController * vc = [[BYDrawingBoardViewController alloc]init];
    vc.originView = [self.view snapshotViewAfterScreenUpdates:NO];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
