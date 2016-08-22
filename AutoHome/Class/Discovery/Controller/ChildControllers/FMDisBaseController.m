//
//  FMDisBaseController.m
//  AutoHome
//
//  Created by 范茂羽 on 15/5/23.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMDisBaseController.h"

@interface FMDisBaseController ()

@end

@implementation FMDisBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNav];
}

-(void)createNav
{
    UIButton *backBtn = [FMUtil createButtonWithFrame:CGRectMake(5, 15, 60, self.navBar.bounds.size.height-10) withTitle:@"返回" withImageName:@"bar_btn_icon_returntext" withSelImageName:nil withHigImageName:nil withTarget:self withAction:@selector(backAction)];
    [backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.navBar addSubview:backBtn];
    
    
    UILabel *titleLabel = [FMUtil createLabelWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 10, 200, self.navBar.bounds.size.height) withFont:[UIFont systemFontOfSize:18] withTextColor:[UIColor grayColor] withTitle:self.title];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navBar addSubview:titleLabel];
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
