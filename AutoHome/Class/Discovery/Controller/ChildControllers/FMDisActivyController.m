//
//  FMDisActivyController.m
//  AutoHome
//
//  Created by 范茂羽 on 15/5/23.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMDisActivyController.h"
#import "FMChooseButton.h"

@interface FMDisActivyController ()
{
    NSArray *_channelArray;
}

@end

@implementation FMDisActivyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _channelArray = @[@"北京"];
    [self createScrollView];
}

-(void)createScrollView
{
    
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
    
    CGFloat btnW = SCREEN_WIDTH/5;
    CGFloat btnX = 0.0f;
    
    for (int i = 0; i < _channelArray.count; i++) {
        FMChooseButton *btn = [[FMChooseButton alloc]initWithFrame:CGRectMake(btnX, 0, btnW, 43)];
        [btn setTitle:_channelArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"filterbar_icon_arrow"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btnX += btnW;
        [sv addSubview:btn];
        
        //分割线
        UIView *verline = [[UIView alloc]initWithFrame:CGRectMake(btnX+2, 12, 1, 20)];
        verline.backgroundColor = [UIColor lightGrayColor];
        [sv addSubview:verline];
        
        UIView *horline = [[UIView alloc]initWithFrame:CGRectMake(0, 43, sv.bounds.size.width, 1)];
        horline.backgroundColor = [UIColor lightGrayColor];
        [sv addSubview:horline];
    }
    
    sv.contentSize = CGSizeMake(btnX, 0);
    sv.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:sv];
//    [_tableView reloadData];
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
