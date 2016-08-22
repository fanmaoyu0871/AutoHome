//
//  FMMainTabBarController.m
//  AutoHome
//
//  Created by qianfeng on 15/5/13.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMMainTabBarController.h"
#import "FMTabBar.h"
#import "FMNavigationController.h"

#import "FMRecommendController.h"
#import "FMDiscoveryController.h"
#import "FMFindCarController.h"
#import "FMCommentController.h"
#import "FMMineController.h"

@interface FMMainTabBarController ()

@end

@implementation FMMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    [self createChildControllers];
    [self createTabBar];
}

-(void)createTabBar
{
    
    NSArray *images = @[@"item01",@"item02",@"item03",@"item04",@"item05"];
    NSArray *selImages = @[@"item01_selected",@"item02_selected",@"item03_selected",@"item04_selected",@"item05_selected"];
    
    FMTabBar *tabBar = [[FMTabBar alloc]initWithFrame:CGRectMake(0,    0, SCREEN_WIDTH, 49) withImageArray:images withSelImageArray:selImages];
    tabBar.selectedBlock = ^(NSInteger index){
        self.selectedIndex = index;
    };
    
    [self.tabBar addSubview:tabBar];
}

-(void)createChildControllers
{
    NSArray *vcNames = @[@"FMRecommendController", @"FMCommentController", @"FMFindCarController", @"FMDiscoveryController", @"FMMineController"];
    
    NSMutableArray *vcsArray = [NSMutableArray array];
    
    for(int i = 0; i < vcNames.count; i++)
    {
        Class cls = NSClassFromString(vcNames[i]);
        UIViewController *vc = [[cls alloc]init];
        FMNavigationController *nav = [[FMNavigationController alloc]initWithRootViewController:vc];
        [vcsArray addObject:nav];
    }
    
    self.viewControllers = vcsArray;
    self.selectedIndex = 0;
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
