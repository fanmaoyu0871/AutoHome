//
//  FMChooseViewController.m
//  AutoHome
//
//  Created by 范茂羽 on 15/5/17.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMChooseViewController.h"
#import "FMTableView.h"
#import "ChooseCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "FMNavigationController.h"
#import "FMBrandSliderController.h"
#import "FMSliderView.h"
#import "FMChooseSliderBingoController.h"
#import "FMChooseSliderGroupController.h"
#import "FindCar.h"


@interface FMChooseViewController ()<FMTableViewDelegate>
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

@implementation FMChooseViewController

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
    _MainArray = @[@"品牌", @"价格", @"级别", @"国别", @"变速箱", @"结构", @"排量", @"燃料", @"配置"];
    
    _childArray =  @[@[@"不限", @"5万以下", @"5-8万", @"8-10万", @"10-15万", @"15-20万", @"20-25万", @"25-35万", @"35-50万", @"50-70万", @"70-100万", @"100万以上"], @[@"不限", @"微型车", @"小型车", @"紧凑型车", @"中型车", @"中大型车", @"大型车", @"跑车", @"MPV", @"全部SUV", @"微面", @"微卡", @"轻客", @"皮卡"], @[@"不限", @"中国", @"德国", @"日本", @"美国", @"韩国", @"法国", @"英国", @"意大利", @"瑞典", @"荷兰", @"捷克"], @[@"不限", @"手动", @"自动"], @[@"不限", @"两厢", @"三厢", @"掀背", @"旅行版", @"硬顶敞篷车", @"软顶敞篷车", @"硬顶跑车", @"客车", @"货车"], @[@"不限", @"1.0L及以下", @"1.1-1.6L", @"1.7-2.0L", @"2.1-2.5L", @"2.6-3.0L", @"3.1-4.0L", @"4.0以上"], @[@"不限", @"汽油", @"柴油", @"电动", @"油电混合"], @[@"不限", @"天窗", @"电动调节座椅", @"ESP", @"GPS导航", @"定速巡航", @"真皮座椅", @"倒车雷达", @"全自动空调", @"多功能方向盘"]];
    
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
         [tempCell configTitle:_MainArray[indexPath.row] withName:_childArray[indexPath.row-1][row]];
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
        title = @"选择品牌";
        [self createSliderViewWithNavTitle:title];
        return;
    }
    else if(indexPath.row == 1)
    {
        title = @"价格";
    }
    else if(indexPath.row == 2)
    {
        title = @"级别";
    }
    else if(indexPath.row == 3)
    {
         title = @"国别";
    }
    else if(indexPath.row == 4)
    {
         title = @"变速箱";
    }
    else if(indexPath.row == 5)
    {
         title = @"结构";
    }
    else if(indexPath.row == 6)
    {
         title = @"排量";
    }
    else if(indexPath.row == 7)
    {
        title = @"燃量";
    }
    
    [self createSliderViewWithArray:_childArray[indexPath.row-1] withNavTitle:title];
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
