//
//  ViewController.m
//  ZWHorizonPagingView
//
//  Created by 曾威 on 16/4/30.
//  Copyright © 2016年 曾威. All rights reserved.
//

#import "ViewController.h"
#import "ZWHorizonPagingView.h"
#import "table0.h"
#import "table1.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //header
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 64.f, ScreenWidth, 200)];
    header.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 50, 100, 25)];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [header addSubview:btn];
    
    //contentViews
    NSMutableArray *contentViews = [NSMutableArray array];
    table0 *contentView0 = [table0 new];
    table1 *contentView1 = [[table1 alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    UIScrollView *contentView2 = [[UIScrollView alloc] init];
    contentView2.contentSize = CGSizeMake(0, ScreenHeight-40-63);
    contentView2.backgroundColor = [UIColor greenColor];
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(10, 50, 100, 25)];
    [btn2 addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    btn2.backgroundColor = [UIColor redColor];
    [contentView2 addSubview:btn2];
    table0 *contentView3 = [table0 new];
    [contentViews addObject:contentView0];
    [contentViews addObject:contentView1];
    [contentViews addObject:contentView2];
    [contentViews addObject:contentView3];
    
    //segmentBtns
    CGFloat x = 0;
    CGFloat width = ScreenWidth/4;
    NSMutableArray *btnArr = [NSMutableArray array];
    for (int i = 0; i<4; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, width, 40.f)];
        [btn setTitle:@"test" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [btnArr addObject:btn];
        x+= width;
    }
    
    ZWHorizonPagingView *pagingView = [ZWHorizonPagingView pagingWithTopView:header segmentHeight:40.f segmentBtns:btnArr contentViews:contentViews];
    [self.view addSubview:pagingView];
}

- (void)clickBtn{
    NSLog(@"clickBtn");
}

@end
