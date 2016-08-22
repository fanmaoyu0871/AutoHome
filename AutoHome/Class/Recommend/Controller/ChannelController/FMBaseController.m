//
//  FMBaseController.m
//  AutoHome
//
//  Created by qianfeng on 15/5/13.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMBaseController.h"

@interface FMBaseController ()

@end

@implementation FMBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBar];
    
}


-(void)createNavigationBar
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.opaque = YES;
    
    //画一条线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 63, self.view.frame.size.width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:line];
    
    [self.view addSubview:bgView];
    self.navBar = bgView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
