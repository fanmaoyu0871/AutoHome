//
//  FMDisCarTypeSliderController.m
//  AutoHome
//
//  Created by 范茂羽 on 15/5/24.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMDisCarTypeSliderController.h"

@interface FMDisCarTypeSliderController ()

@end

@implementation FMDisCarTypeSliderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = CGRectMake(SCREEN_WIDTH, 0, 250, SCREEN_HEIGHT-20);
    [self createNavigationBar];
}

-(void)createNavigationBar
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.opaque = YES;
    
    [self.view addSubview:bgView];
    self.navBar = bgView;
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
