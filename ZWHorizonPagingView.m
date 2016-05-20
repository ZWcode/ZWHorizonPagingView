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
@property (nonatomic, strong) UIView                    *segmentView;/**<选择视图*/
@property (nonatomic, assign) CGFloat                   segmentHeight;/**<选择视图的高度*/

@property (nonatomic, assign) CGFloat                   scrollY;/** 记录scrollView上次偏移Y的距离 */
@property (nonatomic, strong) UIScrollView              *showingScrollView;/**<记录当前滚动视图*/

@property (nonatomic, strong) NSArray                   *segmentBtnTitles;/**<按钮文字*/
@property (nonatomic, strong) NSArray                   *contentViews;/**<垂直方向滚动视图*/

@end

@implementation ZWHorizonPagingView

static void *ZWVerticallyScrollViewContext = &ZWVerticallyScrollViewContext;/**<处理垂直方向contentViews的KVO参数*/
+ (instancetype)pagingWithTopView:(UIView *)topView segmentHeight:(CGFloat)segmentHeight segmentBtnTitles:(NSArray *)segmentBtnTitles contentViews:(NSArray *)contentViews{
    ZWHorizonPagingView *pagingView = [ZWHorizonPagingView new];
    pagingView.frame = [UIScreen mainScreen].bounds;
    
    pagingView.topView = topView;
    pagingView.topViewHeight = topView.frame.size.height;
    pagingView.segmentHeight = segmentHeight;
    pagingView.segmentBtnTitles = segmentBtnTitles;
    pagingView.contentViews = contentViews;
    
    [pagingView setupView];

    return pagingView;
}

- (void)setupView{
    
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _bgScrollView.contentSize = CGSizeMake(ScreenWidth*_contentViews.count, 0);
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    _bgScrollView.pagingEnabled = YES;
    _bgScrollView.bounces = NO;
    _bgScrollView.delegate = self;
    [self addSubview:_bgScrollView];
    
    __block CGFloat x = 0;
    [_contentViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIScrollView *scrollView = obj;
        scrollView.contentInset = UIEdgeInsetsMake(self.topViewHeight, 0, 0, 0);
        scrollView.contentOffset = CGPointMake(0, -self.topViewHeight);
        scrollView.frame = CGRectMake(x, self.segmentHeight, ScreenWidth, ScreenHeight-self.segmentHeight-64.f);
        
        //采用KVO方式监听滚动，是为了更好的封装此控件->防止contentViews的delegate冲突
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:ZWVerticallyScrollViewContext];
        [self.bgScrollView addSubview:scrollView];
        x += ScreenWidth;
    }];

    CGRect topViewRect = _topView.frame;
    topViewRect.origin.y = 64.f;
    _topView.frame = topViewRect;
    [self addSubview:_topView];

    _segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), ScreenWidth, self.segmentHeight)];
    _segmentView.backgroundColor = [UIColor orangeColor];
    [self addSubview:_segmentView];
}

- (void)objectDidDragged:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged) {
        
        //这里取得的参照坐标系是该对象在父控件的坐标。
        CGPoint offset = [sender translationInView:self];
//        NSLog(@"%@",NSStringFromCGPoint(offset));
//        UIView *draggableObj = sender.view;
        
        //初始化sender中的坐标位置。如果不初始化，移动坐标会一直积累起来。
        [sender setTranslation:CGPointMake(0, 0) inView:self];

        //处理联动:偏移量映射到showingScrollView,由KVO处理联动
        NSLog(@"%f",self.showingScrollView.contentOffset.y);

        self.showingScrollView.contentOffset = CGPointMake(0, self.showingScrollView.contentOffset.y-offset.y);
    }
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

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(__unused id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (context == &ZWVerticallyScrollViewContext) {

        CGFloat offsetY = self.showingScrollView.contentOffset.y+self.topViewHeight;
        CGFloat segOffsetY = offsetY - self.scrollY;
        self.scrollY = offsetY;
//        NSLog(@"offsetY:%f,segOffsetY:%f",offsetY,segOffsetY);
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
    
}

#pragma mark - getter
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

- (void)dealloc{
    for(UIScrollView *v in self.contentViews) {
        [v removeObserver:self forKeyPath:@"contentOffset" context:&ZWVerticallyScrollViewContext];
    }
}

@end
