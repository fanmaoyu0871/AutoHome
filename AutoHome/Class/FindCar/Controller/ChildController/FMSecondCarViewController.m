//
//  FMSecondCarViewController.m
//  AutoHome
//
//  Created by 范茂羽 on 15/5/17.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMSecondCarViewController.h"
#import "FMTableView.h"
#import "FMChooseSliderBingoController.h"
#import "FMSliderView.h"
#import "ChooseCell.h"
#import "FMChooseSliderGroupController.h"
#import "FindCar.h"
#import "FMNavigationController.h"

@interface FMSecondCarViewController ()<FMTableViewDelegate>
{
    NSArray *_MainArray;
    NSArray *_childArray;
    
    NSInteger _section;
    
    FMChooseSliderBingoController *_sliderVC;
    FMChooseSliderGroupController *_sliderGroupVC;
    FMSliderView *_sliderView;
    FMTableView *_tableView;
    FMTableView *_sliderTableView;
}

@property (nonatomic, strong)NSMutableDictionary *seletedDict;

@end

@implementation FMSecondCarViewController

-(NSMutableDictionary *)seletedDict
{
    if(_seletedDict == nil)
    {
        _seletedDict = [NSMutableDictionary dictionary];
    }
    
    return _seletedDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _section = -1;
    _MainArray = @[@"地区", @"品牌", @"价格", @"里程", @"车龄", @"级别", @"来源"];
    
    _childArray =  @[@[@"不限", @"3万以下", @"3-5万", @"5-8万",@"8-10万", @"10-15万", @"15-20万", @"20-30万", @"30-50万", @"50万以上"], @[@"不限", @"1万公里内", @"3万公里内", @"6万公里内", @"10万公里内"], @[@"不限", @"1年内", @"2年内", @"3年内", @"5年内", @"8年内", @"10年内"],@[@"不限", @"微型车", @"小型车", @"紧凑型车", @"中型车", @"中大型车", @"大型车", @"跑车", @"MPV", @"全部SUV", @"微面", @"微卡", @"轻客", @"皮卡"], @[@"不限", @"个人", @"商家", @"认证"]];
    
    [self createTableView];
    [_tableView reloadData];
}

-(void)createTableView
{
    _tableView = [[FMTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) withStyle:UITableViewStylePlain isLoadXib:NO];
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma  mark - FMTableView协议方法
-(NSInteger)numberOfSections:(FMTableView *)tableView
{
    return 1;
}

-(NSInteger)FMTableView:(FMTableView *)tableView numberOfRowsAtSection:(NSInteger)section
{
    return _MainArray.count;
}

-(UITableViewCell *)FMTableView:(FMTableView *)tableView withTableView:(UITableView *)tb atIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =  [tb dequeueReusableCellWithIdentifier:@"chooseCellID" forIndexPath:indexPath];
    
    ChooseCell *tempCell = (ChooseCell*)cell;
    
    NSString *sectionStr = [NSString stringWithFormat:@"%ld", indexPath.row];
    
    NSString *rowStr = [self.seletedDict objectForKey:sectionStr];
    if(rowStr)
    {
        NSInteger row = [rowStr integerValue];
        [tempCell configTitle:_MainArray[indexPath.row] withName:_childArray[indexPath.row-2][row]];
    }
    else
    {
        [tempCell configTitle:_MainArray[indexPath.row] withName:@"不限"];
    }
    
    return tempCell;
}

-(void)FMTableView:(FMTableView *)tableView registerCellWithTableView:(UITableView *)tb
{
    [tb registerNib:[UINib nibWithNibName:@"ChooseCell" bundle:nil] forCellReuseIdentifier:@"chooseCellID"];
}


-(CGFloat)FMtableView:(FMTableView *)tableView highForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(NSString*)FMTableView:(FMTableView *)tableView titleForHeaderAtSection:(NSInteger)section
{
    NSString *str;
    if(section == 0)
    {
        str = @"筛选条件";
    }
    
    return str;
}


-(CGFloat)FMtableView:(FMTableView *)tableView highForHeaderViewAtSection:(NSInteger)section
{
    return 20;
}

-(void)FMTableView:(FMTableView *)tableView didSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    
    _section = indexPath.row;
    
    NSString *title = nil;
    
    if(indexPath.row == 0)
    {
        title = @"选择省份";
    }
    else if(indexPath.row == 1)
    {
        title = @"选择品牌";
        [self createSliderViewWithNavTitle:title];
        return;
    }
    else if(indexPath.row == 2)
    {
        title = @"选择价格";
    }
    else if(indexPath.row == 3)
    {
        title = @"选择里程";
    }
    else if(indexPath.row == 4)
    {
        title = @"选择车龄";
    }
    else if(indexPath.row == 5)
    {
        title = @"选择级别";
    }
    else if(indexPath.row == 6)
    {
        title = @"选择来源";
    }
    
    [self createSliderViewWithArray:_childArray[indexPath.row-2] withNavTitle:title];
}

-(void)createSliderViewWithNavTitle:(NSString*)title;
{
    [self createBgView];
    
    //添加侧滑视图和控制器
    _sliderGroupVC = [[FMChooseSliderGroupController alloc]init];
    _sliderGroupVC.navTitle = title;
    _sliderGroupVC.urlStr = CHOOSE_SLIDERBRAND_URL;
    _sliderGroupVC.selectCellBlock = ^(NSInteger index){
        
        NSString *section = [NSString stringWithFormat:@"%ld", _section];
        NSString *row = [NSString stringWithFormat:@"%ld", index];
        [self.seletedDict setValue:row forKey:section];
        
        [_tableView reloadData];
    };
    
    FMNavigationController *nav = [[FMNavigationController alloc]initWithRootViewController:_sliderGroupVC];
    [_sliderView addSubview:_sliderGroupVC.view];
    [self addChildViewController:nav];
    
    _sliderGroupVC.closeBtnBlock = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, USEC_PER_SEC*500), dispatch_get_main_queue(), ^{
            [_sliderGroupVC.view removeFromSuperview];
            [_sliderView removeFromSuperview];
            [nav removeFromParentViewController];
            _sliderView = nil;
        });
    };
    
    //左滑动画
    [_sliderGroupVC leftSlide];
    
}


-(void)createSliderViewWithArray:(NSArray*)array withNavTitle:(NSString*)title;
{
    [self createBgView];
    
    //添加侧滑视图和控制器
    
    _sliderVC = [[FMChooseSliderBingoController alloc]init];
    _sliderVC.dataArray = array;
    _sliderVC.navTitle = title;
    _sliderVC.selectCellBlock = ^(NSInteger index){
        
        NSString *section = [NSString stringWithFormat:@"%ld", _section];
        NSString *row = [NSString stringWithFormat:@"%ld", index];
        [self.seletedDict setValue:row forKey:section];
        
        [_tableView reloadData];
    };
    
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

#pragma mark - 创建侧滑视图
-(void)createBgView
{
    _sliderView = [[FMSliderView alloc]initWithFrame:CGRectMake(0, 20,SCREEN_WIDTH, SCREEN_HEIGHT-20)];
    [[UIApplication sharedApplication].keyWindow addSubview:_sliderView];
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
