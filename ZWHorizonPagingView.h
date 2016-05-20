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

/**
 *  @brief  使用说明：子控件若是scrollview必须设置contentsize，若是table且高度较小必须设置最低高度为ScreenHeight-segmentHeight
 */
@interface ZWHorizonPagingView : UIView

@property (nonatomic, strong) UIView        *segmentView;/**<选择视图*/
@property (nonatomic, strong) UIView        *underLine;/**<segmentView里跟随滚动的underLine*/
@property (nonatomic, copy)   UIColor       *splitLineColor;/**<custom segmentView's color*/

+ (instancetype)pagingWithTopView:(UIView *)topView segmentHeight:(CGFloat)segmentHeight segmentBtnTitles:(NSArray *)segmentBtns contentViews:(NSArray *)contentViews;

@end
