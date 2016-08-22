//
//  FMDisSecondCarController.m
//  AutoHome
//
//  Created by 范茂羽 on 15/5/23.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMDisSecondCarController.h"
#import "FMSecondCarViewController.h"

@interface FMDisSecondCarController ()

@end

@implementation FMDisSecondCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self addchildVC];
}



-(void)addchildVC
{
    FMSecondCarViewController *mainVC = [[FMSecondCarViewController alloc]init];
    mainVC.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self addChildViewController:mainVC];
    [self.view addSubview:mainVC.view];
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
