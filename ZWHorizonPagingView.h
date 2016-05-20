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

+ (instancetype)pagingWithTopView:(UIView *)topView segmentHeight:(CGFloat)segmentHeight segmentBtnTitles:(NSArray *)segmentBtnTitles contentViews:(NSArray *)contentViews;

@end
