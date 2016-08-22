//
//  FMDisDiffController.m
//  AutoHome
//
//  Created by 范茂羽 on 15/5/23.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMDisDiffController.h"
#import "FMDisBrandSliderController.h"
#import "FMSliderView.h"
#import "FMNavigationController.h"
#import "AFHTTPRequestOperationManager.h"
#import "BrandModel.h"
#import "FindCar.h"


@interface FMDisDiffController ()
{
    UIView *_bgView;
    
    //侧滑视图
    FMDisBrandSliderController *_sliderVC;
    FMSliderView *_sliderView;
    FMTableView *_sliderTableView;
}

@property (nonatomic, strong)NSMutableArray *letterArray;

@property (nonatomic, strong)NSMutableArray *brandArray;

@property (nonatomic, strong)NSMutableArray *resultArray;

@end

@implementation FMDisDiffController

-(NSMutableArray *)letterArray
{
    if(_letterArray == nil)
    {
        _letterArray = [NSMutableArray array];
    }
    
    return _letterArray;
}

-(NSMutableArray *)brandArray
{
    if(_brandArray == nil)
    {
        _brandArray = [NSMutableArray array];
    }
    
    return _brandArray;
}

-(NSMutableArray *)resultArray
{
    if(_resultArray == nil)
    {
        _resultArray = [NSMutableArray array];
    }
    
    return _resultArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createBackView];
    [self createBottomView];
}

-(void)createBackView
{
    _bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-44)];
    _bgView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_bgView];
    
    UILabel *label = [FMUtil createLabelWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 20) withFont:[UIFont systemFontOfSize:15] withTextColor:[UIColor blackColor] withTitle:@"车型库还空着呐!添加车型对比吧"];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:label];
}

-(void)createBottomView
{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIButton *addBtn = [FMUtil createButtonWithFrame:CGRectMake(SCREEN_WIDTH-120, 0, 60, 44) withTitle:@"添加" withImageName:nil withSelImageName:nil withHigImageName:nil withTarget:self withAction:@selector(addAction)];
    [bottomView addSubview:addBtn];
    
    UIButton *editBtn = [FMUtil createButtonWithFrame:CGRectMake(SCREEN_WIDTH-60, 0, 60, 44) withTitle:@"编辑" withImageName:nil withSelImageName:nil withHigImageName:nil withTarget:self withAction:@selector(editAction)];
    [bottomView addSubview:editBtn];
}

-(void)addAction
{
    //点击了一个品牌就创建
    [self createSliderView];
    
    //进行品牌数据请求
    [self downloadData];
    
}

-(void)downloadData
{
}

-(void)createSliderView
{
    [self createBgView];
    
    //添加侧滑视图和控制器
    _sliderVC = [[FMDisBrandSliderController alloc]init];
    _sliderVC.urlStr = CHOOSE_SLIDERBRAND_URL;
    _sliderVC.navTitle = @"选择品牌";
    
    FMNavigationController *nav = [[FMNavigationController alloc]initWithRootViewController:_sliderVC];
    [_sliderView addSubview:_sliderVC.view];
    [self addChildViewController:nav];
    
    _sliderVC.closeBtnBlock = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, USEC_PER_SEC*500), dispatch_get_main_queue(), ^{
            [_sliderVC.view removeFromSuperview];
            [_sliderView removeFromSuperview];
            [nav removeFromParentViewController];
            _sliderView = nil;
        });
    };
    
    //左滑动画
    [_sliderVC leftSlide];
    
}


-(void)createBgView
{
    _sliderView = [[FMSliderView alloc]initWithFrame:CGRectMake(0, 20,SCREEN_WIDTH, SCREEN_HEIGHT-20)];
    [[UIApplication sharedApplication].keyWindow addSubview:_sliderView];
}

-(void)editAction
{
    
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
