//
//  table0.m
//  ZWHorizonPagingView
//
//  Created by 曾威 on 16/4/30.
//  Copyright © 2016年 曾威. All rights reserved.
//

#import "table0.h"

@implementation table0

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
        header.backgroundColor = [UIColor lightGrayColor];
        UIButton *test = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        [test addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
        test.backgroundColor = [UIColor redColor];
        [header addSubview:test];
        self.tableHeaderView = header;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [UITableViewCell  new];
    cell.textLabel.text = [NSString stringWithFormat:@"tableFirst%lu",indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)test{
    NSLog(@"click");
}
@end
