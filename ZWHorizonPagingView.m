//
//  ZWHorizonPagingView.m
//  ZWHorizonPagingView
//
//  Created by 曾威 on 16/4/30.
//  Copyright © 2016年 曾威. All rights reserved.
//

#import "ZWHorizonPagingView.h"
#import "UIView+ZW.h"

@interface ZWHorizonPagingView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView              *bgScrollView;/**<水平滚动*/
@property (nonatomic, strong) UIView                    *topView;/**<头部视图*/
@property (nonatomic, assign) CGFloat                   topViewHeight;

@property (nonatomic, assign) CGFloat                   segmentHeight;/**<选择视图的高度*/

@property (nonatomic, assign) CGFloat                   scrollY;/** 记录scrollView上次偏移Y的距离 */
@property (nonatomic, strong) UIScrollView              *showingScrollView;/**<记录当前滚动视图*/

@property (nonatomic, strong) NSArray                   *segmentBtnTitles;/**<按钮文字*/
@property (nonatomic, strong) NSArray                   *contentViews;/**<垂直方向滚动视图*/

@end

@implementation ZWHorizonPagingView

static void *ZWVerticallyScrollViewContext = &ZWVerticallyScrollViewContext;/**<处理垂直方向contentViews的KVO参数*/
+ (instancetype)pagingWithTopView:(UIView *)topView segmentHeight:(CGFloat)segmentHeight segmentBtnTitles:(NSArray *)segmentBtnTitles contentViews:(NSArray *)contentViews{
    
    ZWHorizonPagingView *pagingView     = [ZWHorizonPagingView new];
    pagingView.backgroundColor          = [UIColor whiteColor];
    pagingView.frame                    = [UIScreen mainScreen].bounds;
    pagingView.segmentHeight            = segmentHeight;
    pagingView.topViewHeight            = topView.frame.size.height;
    pagingView.contentViews             = contentViews;
    pagingView.topView                  = topView;
    pagingView.segmentBtnTitles         = segmentBtnTitles;
    
    return pagingView;
}

#pragma mark - scroll view delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //KVO方法里改变contentOffset，循环引用会crash，所以在这里处理contentViews的y值逻辑
    //临界点是segmentView刚刚置顶时的y轴，处理对象是除当前滚动视图之外的contentViews。
    //如果小于这个临界点，所有滚动视图的contentOffset保持一致->contentViews其余部分跟随滚动
    //如果大于这个临界点,情况一：已经向上滚动超出临界点，情况二：将其置0
    [self.contentViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIScrollView *scroll = obj;
        if (![scroll isEqual:self.showingScrollView]) {
            if (self.scrollY < self.topViewHeight) {
                scroll.contentOffset = CGPointMake(0, self.scrollY-self.topViewHeight);
            }else if (scroll.contentOffset.y < 0.f){
                scroll.contentOffset = CGPointMake(0.f, 0.f);
            }
        }
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    CGFloat LineTotalLength = ScreenWidth-15.f;
    CGFloat width = LineTotalLength/self.segmentBtnTitles.count;
    CGFloat scrollMoveLength = scrollView.contentOffset.x;
    CGFloat scrollTotalLength = ScreenWidth * self.segmentBtnTitles.count;
    CGFloat LineMoveLength = scrollMoveLength * LineTotalLength / scrollTotalLength;
    CGFloat x = LineMoveLength+15.f;
//    CGRect rect = self.underLine.frame;
    CGRect rect = CGRectMake(x, self.segmentHeight-1, width-15, 1);
    self.underLine.frame = rect;
}

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(__unused id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (context == &ZWVerticallyScrollViewContext) {

        CGFloat offsetY = self.showingScrollView.contentOffset.y+self.topViewHeight;
        CGFloat segOffsetY = offsetY - self.scrollY;
        self.scrollY = offsetY;
        NSLog(@"offsetY:%f,segOffsetY:%f",offsetY,segOffsetY);
        //topView联动
        CGRect headRect = self.topView.frame;
        headRect.origin.y -= segOffsetY;
        self.topView.frame = headRect;

        //segmentView联动，处理悬浮效果
        if (offsetY > self.topViewHeight) {
            self.segmentView.frame = CGRectMake(0, 64.f, ScreenWidth, self.segmentHeight);
            self.showingScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            self.showingScrollView.showsVerticalScrollIndicator = YES;
        } else {
            self.segmentView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), ScreenWidth, self.segmentHeight);
            self.showingScrollView.contentInset = UIEdgeInsetsMake(self.topViewHeight, 0, 0, 0);
            self.showingScrollView.showsVerticalScrollIndicator = NO;
        }
    }
}

#pragma mark - setter
- (void)setSegmentBtnTitles:(NSArray *)segmentBtnTitles{
    _segmentBtnTitles = segmentBtnTitles;
    __block x = 0;
    [segmentBtnTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton new];
    }];
}

- (void)setTopView:(UIView *)topView{
    _topView = topView;
    [self addSubview:_topView];
}

- (void)setContentViews:(NSArray *)contentViews{
    _contentViews = contentViews;
    __block CGFloat x = 0;
    [self.contentViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIScrollView *scrollView = obj;
        scrollView.contentInset = UIEdgeInsetsMake(self.topViewHeight, 0, 0, 0);
        scrollView.contentOffset = CGPointMake(0, -self.topViewHeight);
        scrollView.frame = CGRectMake(x, self.segmentHeight, ScreenWidth, ScreenHeight-self.segmentHeight-64.f);
        
        //采用KVO方式监听滚动，是为了更好的封装此控件->防止contentViews的delegate冲突
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:ZWVerticallyScrollViewContext];
        [self.bgScrollView addSubview:scrollView];
        x += ScreenWidth;
    }];
}

#pragma mark - getter
- (UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _bgScrollView.contentSize = CGSizeMake(ScreenWidth*_contentViews.count, 0);
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.pagingEnabled = YES;
        _bgScrollView.bounces = NO;
        _bgScrollView.delegate = self;
        [self addSubview:_bgScrollView];
    }
    return _bgScrollView;
}

- (UIView *)segmentView{
    if (!_segmentView) {
        _segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), ScreenWidth, self.segmentHeight)];
        [self addSubview:_segmentView];
    }
    return _segmentView;
}

- (UIScrollView *)showingScrollView{
    if (!_showingScrollView) {
        _showingScrollView = [UIScrollView new];
    }
    CGFloat bgOffsetX = _bgScrollView.contentOffset.x;
    int currentPage = (bgOffsetX+ScreenWidth*0.5)/ScreenWidth;
    [self.contentViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (currentPage == idx) {
            _showingScrollView = self.contentViews[idx];
            *stop = YES;
        }
    }];
    return _showingScrollView;
}

- (UIView *)underLine{
    if (!_underLine) {
        _underLine = [UIView new];
        _underLine.backgroundColor = [UIColor lightGrayColor];
        [self.segmentView addSubview:_underLine];
    }
    return _underLine;
}

- (void)dealloc{
    for(UIScrollView *v in self.contentViews) {
        [v removeObserver:self forKeyPath:@"contentOffset" context:&ZWVerticallyScrollViewContext];
    }
}

@end
