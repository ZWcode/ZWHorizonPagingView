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
    
    
}
- (void)clickBtn{
    NSLog(@"clickBtn");
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 64.f, ScreenWidth, 200)];
    header.backgroundColor = [UIColor blueColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 50, 100, 25)];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [header addSubview:btn];
    NSMutableArray *contentViews = [NSMutableArray array];
    table0 *contentView0 = [[table0 alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
//    contentView0.backgroundColor = [UIColor redColor];
//        contentView0.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    
    table1 *contentView1 = [[table1 alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    UITableView *contentView2 = [UITableView new];
    contentView2.backgroundColor = [UIColor blueColor];
    UITableView *contentView3 = [UITableView new];
    contentView3.backgroundColor = [UIColor redColor];
    [contentViews addObject:contentView0];
    [contentViews addObject:contentView1];
    [contentViews addObject:contentView2];
    [contentViews addObject:contentView3];
    
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
    ZWHorizonPagingView *pagingView = [ZWHorizonPagingView pagingWithTopView:header segmentHeight:40.f segmentBtnTitles:btnArr contentViews:contentViews];

//    pagingView.segmentView.backgroundColor = [UIColor orangeColor];
    
//    [self.view addSubview:contentView0];
    UIViewController *vc = [UIViewController new];
    [vc.view addSubview:pagingView];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
