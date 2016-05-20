//
//  ZWHorizonPagingView.h
//  ZWHorizonPagingView
//
//  Created by 曾威 on 16/4/30.
//  Copyright © 2016年 曾威. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

@interface ZWHorizonPagingView : UIView

@property (nonatomic, strong) UIView        *segmentView;/**<选择视图*/
@property (nonatomic, strong) UIView        *underLine;


+ (instancetype)pagingWithTopView:(UIView *)topView segmentHeight:(CGFloat)segmentHeight segmentBtnTitles:(NSArray *)segmentBtns contentViews:(NSArray *)contentViews;

@end
