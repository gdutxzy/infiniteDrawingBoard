//
//  BYDrawingBoardViewController.m
//  iBazi
//
//  Created by mac on 16/10/8.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "BYDrawingBoardViewController.h"
#import "BYDrawingToolBarView.h"
#import "BYDrawingBoardScrollView.h"
#import "UIView+Category.h"



#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height



@interface BYDrawingBoardViewController ()<BYDrawingToolBarViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) BYDrawingBoardScrollView * myScrollView;
@property (nonatomic,strong) UIView * tempView;
@property (nonatomic,strong) CAShapeLayer * tempShapelayer;
@property (nonatomic,strong) UIBezierPath * bezierpath;
@property (nonatomic,strong) UIColor * lineColor;
@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic,strong) BYDrawingToolBarView * drawingbar;

@property (nonatomic,assign) CGPoint lastOffset;

@property (nonatomic,assign) CGPoint lastPanOffset;
@property (nonatomic,assign) CGFloat lastScale;

/// 为了避免双击时也进行绘画
@property (nonatomic,assign) BOOL canDrawing;

@property (nonatomic,strong) UIView * drawingView;
//@property (nonatomic,strong) UIView * drawingBaseView;

/// 双击的手势
@property (nonatomic,strong) UITapGestureRecognizer * tap;
@end

@implementation BYDrawingBoardViewController
- (void)dealloc{
    NSLog(@"drawingBoard Dealloc");
//    [self.undoManager removeAllActionsWithTarget:self];
//    [self.undoManager removeAllActions];
}
- (void)popViewController{
    [self.undoManager removeAllActionsWithTarget:self];
    if (self.navigationController.viewControllers.count==1) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.originView isKindOfClass:[UITableView class]]) {
        [(UITableView *)self.originView reloadData];
//        [(UITableView *)self.originView setContentOffset:CGPointMake(0, -30)];
    }
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.drawingView removeFromSuperview];
//}
//- (void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    [self.drawingView removeFromSuperview];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"对比画板";
    [self setupDrawingBoard];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveDrawingBoardJPGToAPP)];
}

//
//- (void)saveDrawingBoardJPGToAPP{
//    UIGraphicsBeginImageContextWithOptions(self.tempView.bounds.size, YES, [UIScreen mainScreen].scale);
//    [self.tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    if (self.imageName.length < 1) {
//        self.imageName = [NSString stringWithFormat:@"%@@%@x.png",@(time(NULL)),@([UIScreen mainScreen].scale)];
//    }
//    if ([BYDrawingBoardFileManage saveImage:image WithName:self.imageName]) {
//        [BYCommonTools MBPropressHUDAlert:@"保存到画板库成功"];
//        [self.navigationController dismissViewControllerAnimated:YES completion:^{
//            
//        }];
//    }else{
//        [BYCommonTools MBPropressHUDAlert:@"保存到画板库失败"];
//    }
//}


//
//- (void)saveDrawingBoardJPGToAlbum{
//    UIGraphicsBeginImageContextWithOptions(self.tempView.bounds.size, YES, [UIScreen mainScreen].scale);
//    [self.tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    [self createAlbumWithImage:image];
////    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
////    __block BOOL screatSucess = NO;
////    NSString * name = @"对比画板";
////    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
////    [library addAssetsGroupAlbumWithName:name resultBlock:^(ALAssetsGroup *group)    {
////        screatSucess = YES;
////    } failureBlock:^(NSError *error) {
////        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"存储失败"
////                                                       message:@"请打开 设置-隐私-照片 来进行设置"
////                                                      delegate:self
////                                             cancelButtonTitle:@"取消"
////                                             otherButtonTitles:@"确定", nil];
////        [alert show];
////    }];
////    if (screatSucess) {
////        [self saveToAlbumWithMetadata:nil imageData:UIImageJPEGRepresentation(image, 1) customAlbumName:name completionBlock:^{
////            
////        } failureBlock:^(NSError *error) {
////            
////        }];
////    }
//}
//
//- (void)createAlbumWithImage:(UIImage *)image
//{
//    NSString * name = @"画板库";
////    if (self.imageALAsset) {
////        [self.imageALAsset setImageData:UIImagePNGRepresentation(image) metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
////            
////        }];
////        return;
////    }
//    ALAssetsLibrary *assetsLibrary = [BYPhotoPickerDatas defaultAssetsLibrary];
//    NSMutableArray *groups=[[NSMutableArray alloc]init];
//    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
//    {
//        if (group)
//        {
//            [groups addObject:group];
//        }
//        else
//        {
//            BOOL haveHDRGroup = NO;
//            for (ALAssetsGroup *gp in groups)
//            {
//                NSString *name =[gp valueForProperty:ALAssetsGroupPropertyName];
//                if ([name isEqualToString:name])
//                {
//                    haveHDRGroup = YES;
//                }
//            }
//            if (!haveHDRGroup)
//            {
//                [assetsLibrary addAssetsGroupAlbumWithName:name
//                                               resultBlock:^(ALAssetsGroup *group)
//                 {
//                     [groups addObject:group];
//                 }
//                                              failureBlock:nil];
//                haveHDRGroup = YES;
//            }
//        }
//    };
//    //创建相簿
//    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:listGroupBlock failureBlock:nil];
//    
//    [self saveToAlbumWithMetadata:nil imageData:UIImagePNGRepresentation(image) customAlbumName:name completionBlock:^
//     {
//         dispatch_async(dispatch_get_main_queue(), ^{
//             [BYCommonTools MBPropressHUDAlert:@"保存到画板库成功"];
//         });
//         //这里可以创建添加成功的方法
//     }
//                     failureBlock:^(NSError *error)
//     {
//         //处理添加失败的方法显示alert让它回到主线程执行，不然那个框框死活不肯弹出来
//         dispatch_async(dispatch_get_main_queue(), ^{
//             //             //添加失败一般是由用户不允许应用访问相册造成的，这边可以取出这种情况加以判断一下
//             //             if([error.localizedDescription rangeOfString:@"User denied access"].location != NSNotFound ||[error.localizedDescription rangeOfString:@"用户拒绝访问"].location!=NSNotFound){
//             //                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:error.localizedDescription message:error.localizedFailureReason delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles: nil];
//             //                 [alert show];
//             //             }
//             
//             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"存储失败"
//                                                            message:@"请打开 设置-隐私-照片 来进行设置"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"取消"
//                                                  otherButtonTitles:@"确定", nil];
//             [alert show];
//             
//         });
//     }];
//}

//
//- (void)saveToAlbumWithMetadata:(NSDictionary *)metadata
//                      imageData:(NSData *)imageData
//                customAlbumName:(NSString *)customAlbumName
//                completionBlock:(void (^)(void))completionBlock
//                   failureBlock:(void (^)(NSError *error))failureBlock
//{
//    ALAssetsLibrary *assetsLibrary = [BYPhotoPickerDatas defaultAssetsLibrary];
//    __weak ALAssetsLibrary *weakSelf = assetsLibrary;
//    void (^AddAsset)(ALAssetsLibrary *, NSURL *) = ^(ALAssetsLibrary *assetsLibrary, NSURL *assetURL) {
//        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
//            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:customAlbumName]) {
//                    [group addAsset:asset];
//                    if (completionBlock) {
//                        completionBlock();
//                    }
//                }
//            } failureBlock:^(NSError *error) {
//                if (failureBlock) {
//                    failureBlock(error);
//                }
//            }];
//        } failureBlock:^(NSError *error) {
//            if (failureBlock) {
//                failureBlock(error);
//            }
//        }];
//    };
//    [assetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
//        if (customAlbumName) {
//            [assetsLibrary addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
//                if (group) {
//                    [weakSelf assetForURL:assetURL resultBlock:^(ALAsset *asset) {
//                        [group addAsset:asset];
//                        if (completionBlock) {
//                            completionBlock();
//                        }
//                    } failureBlock:^(NSError *error) {
//                        if (failureBlock) {
//                            failureBlock(error);
//                        }
//                    }];
//                } else {
//                    AddAsset(weakSelf, assetURL);
//                }
//            } failureBlock:^(NSError *error) {
//                AddAsset(weakSelf, assetURL);
//            }];
//        } else {
//            if (completionBlock) {
//                completionBlock();
//            }
//        }
//    }];
    
    
    
    
//    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc]init];
//    [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
//            if (result.isEditable) {
//                //在这里imageData 和 metaData设为nil，就可以将相册中的照片删除
//                [result setImageData:nil metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
//                    NSLog(@"asset url(%@) should be delete . Error:%@ ", assetURL, error);
//                }];
//            }
//            if (weakSelfVC.imageALAsset) {
//                [weakSelfVC.imageALAsset setImageData:[NSData data] metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
//                    [group addAsset:weakSelfVC.imageALAsset];
//                }];
//            }
//        }];
//    } failureBlock:^(NSError *error) {
//        
//    }];
    
    
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSURL *url = nil;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
        }else{
            url=[NSURL URLWithString:@"prefs:root=INTERNET_TETHERING"];
        }
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }

}

- (void)setupDrawingBoard{
    self.lineWidth = 1;
    self.lineColor = [UIColor redColor];
    self.canDrawing = NO;
    if (self.originView == nil) {
        self.originView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-45)];
        self.originView.backgroundColor = [UIColor whiteColor];
    }
    self.drawingView = [[UIView alloc]initWithFrame:self.originView.bounds];
    self.drawingView.backgroundColor = [UIColor whiteColor];
    self.drawingView.clipsToBounds = NO;
    self.originView.y = 30;
    [self.drawingView addSubview:self.originView];
//    self.drawingView.layer.zPosition = 1000;
    
//    self.drawingBaseView = [[UIView alloc]initWithFrame:self.originView.bounds];
//    self.drawingBaseView.backgroundColor = [UIColor whiteColor];
//    [self.drawingBaseView addSubview:self.originView];
//    [self.drawingBaseView addSubview:self.drawingView];
    
    self.tempView = [[UIView alloc]initWithFrame:self.originView.bounds];
    self.tempView.width = self.tempView.width > (SCREEN_WIDTH) ?self.tempView.width:SCREEN_WIDTH;
    self.tempView.height = self.tempView.height > (SCREEN_HEIGHT-64-45) ?self.tempView.height:SCREEN_HEIGHT-64-45;
    self.tempView.layer.masksToBounds = YES;
    self.originView.clipsToBounds = NO;
    self.tempView.backgroundColor = [UIColor whiteColor];
    [self.tempView addSubview:self.drawingView];
    
    
    
    self.myScrollView = [[BYDrawingBoardScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-45)];
    [self.view addSubview:self.myScrollView];
    [self.myScrollView addSubview:self.tempView];
    self.myScrollView.contentSize = self.tempView.size;
    self.myScrollView.delegate = self;
    self.myScrollView.parentResponder = self;
    self.myScrollView.maximumZoomScale = 4;
    self.myScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setupMyScrollViewMininumZoomScale];
    self.myScrollView.contentOffset = CGPointMake(0, 0);
    
    
    self.drawingbar = [[BYDrawingToolBarView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    self.drawingbar.bottom = SCREEN_HEIGHT-64;
    [self.view addSubview:self.drawingbar];
    self.drawingbar.delegate = self;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 2;
    self.tap = tap;
    [self.myScrollView addGestureRecognizer:tap];
}
- (void)tap:(UIGestureRecognizer *)ges{
    self.canDrawing = NO;
    
    if (self.myScrollView.zoomScale >= 1) {
        return;
    }
    CGPoint point = [ges locationInView:self.tempView];
    self.myScrollView.zoomScale = 1;
    CGPoint offset = CGPointMake(point.x-SCREEN_WIDTH/2.0, point.y-self.myScrollView.height/2.0);
    // 为了回到固定页，x再改改
    offset = CGPointMake(SCREEN_WIDTH*((NSInteger)point.x/(NSInteger)SCREEN_WIDTH), point.y-self.myScrollView.height/2.0);
    if (CGRectContainsPoint(self.tempView.bounds, point)) {
        [self.myScrollView setContentOffset:offset animated:NO];
    }
}
- (void)setupMyScrollViewMininumZoomScale{
    CGFloat ymin = (SCREEN_HEIGHT-64-45-20)/self.tempView.height;
    CGFloat xmin = (SCREEN_WIDTH)/self.self.tempView.width;
    self.myScrollView.minimumZoomScale = ymin<xmin?ymin:xmin;
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView.zoomScale>=1) {
//        self.lastOffset = scrollView.contentOffset;
//    }
//}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.tempView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    [self.tempView setCenter:CGPointMake(xcenter, ycenter)];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (event.allTouches.count > 1) {
        self.lastPanOffset = self.myScrollView.contentOffset;
        self.lastScale = self.myScrollView.zoomScale;
        return;
    }
    UITouch * touch = [touches anyObject];
    if (event.allTouches.count == 1) {
        CGPoint point = [touch locationInView:self.drawingView];
        self.tempShapelayer = [CAShapeLayer layer];
        self.tempShapelayer.lineWidth = self.lineWidth;
        self.tempShapelayer.strokeColor = self.lineColor.CGColor;
        self.tempShapelayer.fillColor = [UIColor clearColor].CGColor;
        self.tempShapelayer.backgroundColor = [UIColor redColor].CGColor;
//        [self addShaperlayer:self.tempShapelayer];
        self.bezierpath = [UIBezierPath bezierPath];
        [self.bezierpath moveToPoint:point];
        self.canDrawing = YES;
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    if (event.allTouches.count > 1) {
        
        
        
        return;
    }
    UITouch * touch = [touches anyObject];
    if (event.allTouches.count == 1) {
        if (self.canDrawing) {
            self.canDrawing = NO;
            [self addShaperlayer:self.tempShapelayer];
        }
        CGPoint point = [touch locationInView:self.drawingView];
        [self.bezierpath addLineToPoint:point];
        self.tempShapelayer.path = self.bezierpath.CGPath;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    if (event.allTouches.count > 1) {
        if (self.myScrollView.zoomScale >= 0) {
            CGPoint point = CGPointMake(self.myScrollView.contentOffset.x/self.myScrollView.zoomScale, self.myScrollView.contentOffset.y/self.myScrollView.zoomScale);
            
//            point.x = floorf(point.x/SCREEN_WIDTH)*SCREEN_WIDTH;
            self.lastOffset = point;
        }
        [self zoomFromScale:self.lastScale toScale:self.myScrollView.zoomScale fromOffset:self.lastPanOffset toOffset:self.myScrollView.contentOffset];

        
        return;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if (event.allTouches.count > 1) {
        if (self.myScrollView.zoomScale >= 0) {
            CGPoint point = CGPointMake(self.myScrollView.contentOffset.x/self.myScrollView.zoomScale, self.myScrollView.contentOffset.y/self.myScrollView.zoomScale);
            
//            point.x = floorf(point.x/SCREEN_WIDTH)*SCREEN_WIDTH;
            self.lastOffset = point;
        }
        [self zoomFromScale:self.lastScale toScale:self.myScrollView.zoomScale fromOffset:self.lastPanOffset toOffset:self.myScrollView.contentOffset];
        
        return;
    }
}

- (void)BYDrawingToolBarViewAllClick{
//    if ([self.undoManager canRedo]) {
//        [self.undoManager redo];
//    }
    if (self.myScrollView.contentSize.height >= self.myScrollView.height) {
        self.lastScale = self.myScrollView.zoomScale;
        self.lastOffset = CGPointMake(self.myScrollView.contentOffset.x/self.myScrollView.zoomScale, self.myScrollView.contentOffset.y/self.myScrollView.zoomScale);
        self.myScrollView.zoomScale = self.myScrollView.minimumZoomScale;
        [self zoomFromScale:1 toScale:self.myScrollView.minimumZoomScale fromOffset:self.lastOffset toOffset:self.myScrollView.contentOffset];
    }else{
        self.lastScale = self.myScrollView.zoomScale;
        CGPoint offset = self.lastOffset;
        self.lastOffset = self.myScrollView.contentOffset;
        self.myScrollView.zoomScale = 1;
        [self.myScrollView setContentOffset:offset animated:NO];
        [self zoomFromScale:self.lastScale toScale:1 fromOffset:self.lastOffset toOffset:offset];
    }
}

- (void)BYDrawingToolBarViewColor:(UIColor *)color{
    self.lineColor = color;
}

- (void)BYDrawingToolBarViewLeftAddClick{
    if (self.myScrollView.zoomScale != 1) {
        self.myScrollView.zoomScale = 1;
        [self.myScrollView setContentOffset:self.lastOffset animated:NO];
    }
    if (self.myScrollView.contentOffset.x < SCREEN_WIDTH/3.0) {
        [self addLeftBoardWidth];
    }else{
        CGFloat x = self.myScrollView.contentOffset.x - SCREEN_WIDTH;
        x = x>0?x:0;
        [self moveToX:x fromX:self.myScrollView.contentOffset.x];
    }
}
- (void)BYDrawingToolBarViewRightAddClick{
    if (self.myScrollView.zoomScale != 1) {
        self.myScrollView.zoomScale = 1;
        [self.myScrollView setContentOffset:self.lastOffset animated:NO];
    }
    if (self.myScrollView.contentOffset.x > self.myScrollView.contentSize.width-SCREEN_WIDTH-SCREEN_WIDTH/3.0) {
        [self addRightBoardWidth];
    }else{
        CGFloat x = self.myScrollView.contentOffset.x + SCREEN_WIDTH;
        x = x<self.myScrollView.contentSize.width-SCREEN_WIDTH?x:self.myScrollView.contentSize.width-SCREEN_WIDTH;
        [self moveToX:x fromX:self.myScrollView.contentOffset.x];
    }
}

- (void)BYDrawingToolBarViewLineWidth:(CGFloat)width{
    self.lineWidth = width;
}

- (void)BYDrawingToolBarViewUndoClick{
    if ([self.undoManager canUndo]) {
        [self.undoManager undo];
    }
//    CAShapeLayer * layer = self.shapelayerArry.lastObject;
//    [self.shapelayerArry removeObject:layer];
//    [layer removeFromSuperlayer];
}


- (void)zoomFromScale:(CGFloat)fscale toScale:(CGFloat)tScale fromOffset:(CGPoint)fromOffset toOffset:(CGPoint)toOffset{
    [[self.undoManager prepareWithInvocationTarget:self] zoomFromScale:tScale toScale:fscale fromOffset:toOffset toOffset:fromOffset];
    self.myScrollView.zoomScale = tScale;
    self.myScrollView.contentOffset = toOffset;
}


- (void)deleteShaperlayer:(CAShapeLayer *)layer{
//    [self.shapelayerArry removeObject:layer];
    __weak typeof(self) weakSelf = self;
    [layer removeFromSuperlayer];
    [[weakSelf.undoManager prepareWithInvocationTarget:weakSelf] addShaperlayer:layer];
}

- (void)addShaperlayer:(CAShapeLayer *)layer{
    __weak typeof(self) weakSelf = self;
    [[weakSelf.undoManager prepareWithInvocationTarget:weakSelf] deleteShaperlayer:layer];
    [weakSelf.drawingView.layer addSublayer:layer];
//    [self.shapelayerArry addObject:self.tempShapelayer];
}


- (void)moveToX:(CGFloat)toX fromX:(CGFloat)fromX{
    self.myScrollView.zoomScale = 1;
    __weak typeof(self) weakSelf = self;
    [[weakSelf.undoManager prepareWithInvocationTarget:weakSelf] moveToX:fromX fromX:toX];
    [weakSelf.myScrollView setContentOffset:CGPointMake(toX, weakSelf.myScrollView.contentOffset.y) animated:YES];
}




- (void)addLeftBoardWidth{
    self.myScrollView.zoomScale = 1;
    __weak typeof(self) weakSelf = self;
    [[self.undoManager prepareWithInvocationTarget:self] deleteLeftBoardWidth];
    weakSelf.tempView.width = weakSelf.tempView.width + SCREEN_WIDTH;
    [weakSelf.myScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    weakSelf.myScrollView.contentSize = weakSelf.tempView.size;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.drawingView.x = weakSelf.drawingView.x + SCREEN_WIDTH;
    }];
    self.lastOffset = self.myScrollView.contentOffset;
    [weakSelf setupMyScrollViewMininumZoomScale];
}
- (void)deleteLeftBoardWidth{
    self.myScrollView.zoomScale = 1;
    __weak typeof(self) weakSelf = self;
    [weakSelf.myScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    weakSelf.tempView.width = weakSelf.tempView.width - SCREEN_WIDTH;
    weakSelf.myScrollView.contentSize = weakSelf.tempView.size;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.drawingView.x = weakSelf.drawingView.x - SCREEN_WIDTH;
    }];
    [[weakSelf.undoManager prepareWithInvocationTarget:weakSelf] addLeftBoardWidth];
    self.lastOffset = self.myScrollView.contentOffset;
    [weakSelf setupMyScrollViewMininumZoomScale];

}



- (void)addRightBoardWidth{
    self.myScrollView.zoomScale = 1;
    [[self.undoManager prepareWithInvocationTarget:self] deleteRightBoardWidth];
    self.tempView.width = self.tempView.width + SCREEN_WIDTH;
    self.myScrollView.contentSize = self.tempView.size;
    [self setupMyScrollViewMininumZoomScale];
    [self.myScrollView setContentOffset:CGPointMake(self.myScrollView.contentSize.width-SCREEN_WIDTH, 0) animated:YES];
}
- (void)deleteRightBoardWidth{
    self.myScrollView.zoomScale = 1;
//    [self.myScrollView setContentOffset:CGPointMake(self.myScrollView.contentSize.width-1*SCREEN_WIDTH, 0) animated:YES];
    self.tempView.width = self.tempView.width - SCREEN_WIDTH;
    self.myScrollView.contentSize = self.tempView.size;
    [self.myScrollView setContentOffset:CGPointMake(self.myScrollView.contentSize.width-1*SCREEN_WIDTH, 0) animated:YES];
    [[self.undoManager prepareWithInvocationTarget:self] addRightBoardWidth];
    [self setupMyScrollViewMininumZoomScale];
    
}

@end
