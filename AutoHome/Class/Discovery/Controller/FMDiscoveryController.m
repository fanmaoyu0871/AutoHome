//
//  FMDiscoveryController.m
//  AutoHome
//
//  Created by qianfeng on 15/5/13.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMDiscoveryController.h"
#import "FMNavView.h"
#import "FMTableView.h"
#import "AppRecommendCell.h"

#import "FMRefreshHeaderView.h"
#import "FMDisSecondCarController.h"
#import "FMDisActivyController.h"
#import "FMDisRadioController.h"
#import "FMDisDiffController.h"

@interface FMDiscoveryController ()<FMTableViewDelegate, UIScrollViewDelegate>
{
    FMNavView *_navView;
    FMTableView *_tableView;
    
    //下拉刷新
    FMRefreshHeaderView *_headerRefresh;
}

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation FMDiscoveryController

-(NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
        
        NSDictionary *dict0 = @{@"title":@"活动&团购", @"image":@"discoveryfunction_14"};
        NSArray *array0 = @[dict0];
        
        NSDictionary *dict1 = @{@"title":@"汽车电台", @"image":@"discoveryfunction_13"};
        NSArray *array1 = @[dict1];
        
        NSDictionary *dict2_0 = @{@"title":@"车型对比", @"image":@"discoveryfunction_6"};
        NSDictionary *dict2_1 = @{@"title":@"购车计算", @"image":@"discoveryfunction_7"};
        NSDictionary *dict2_2 = @{@"title":@"违章查询", @"image":@"discoveryfunction_8"};
        NSDictionary *dict2_3 = @{@"title":@"找二手车", @"image":@"discoveryfunction_9"};
        NSArray *array2 = @[dict2_0, dict2_1, dict2_2, dict2_3];
        
        
        NSDictionary *dict3_0 = @{@"title":@"车商城", @"image":@"discoveryfunction_11"};
        NSDictionary *dict3_1 = @{@"title":@"养车特惠", @"image":@"discoveryfunction_10"};
        NSArray *array3 = @[dict3_0, dict3_1];
        
        NSDictionary *dict4= @{@"title":@"电动车之家", @"image":@"discoveryfunction_12"};
        NSArray *array4 = @[dict4];
        
        [_dataArray addObject:array0];
        [_dataArray addObject:array1];
        [_dataArray addObject:array2];
        [_dataArray addObject:array3];
        [_dataArray addObject:array4];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createNav];
    [self createTableView];
    [_tableView reloadData];
}

-(void)createNav
{
    _navView = [[FMNavView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 43) withInset:90 withArray:@[@"发现"] withBtnFont:[UIFont systemFontOfSize:15]];
    [self.navBar addSubview:_navView];
}

-(void)createTableView
{
    _tableView = [[FMTableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) withStyle:UITableViewStylePlain isLoadXib:NO];
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _headerRefresh = [[FMRefreshHeaderView alloc]initWithFrame:CGRectMake(0, -_tableView.bounds.size.height, _tableView.bounds.size.width, _tableView.bounds.size.height)];
    [_tableView.tableView addSubview:_headerRefresh];
}


#pragma  mark - scrollview协议方法
-(void)FMTableView:(FMTableView *)tableView didScroll:(UITableView *)tb
{
    [_headerRefresh FMRefrshScrollViewDidScroll:tb];
}

-(void)FMTableView:(FMTableView *)tableView didEndDraging:(UITableView *)tb
{
    [_headerRefresh FMRefrshScrollViewDidEndDragging:tb];
}

#pragma  mark - FMTableView协议方法
-(NSInteger)numberOfSections:(FMTableView *)tableView
{
    return self.dataArray.count;
}

-(NSInteger)FMTableView:(FMTableView *)tableView numberOfRowsAtSection:(NSInteger)section
{
    if(section != 5)
    {
        return [self.dataArray[section] count];
    }
    
    return 1;
}

-(UITableViewCell *)FMTableView:(FMTableView *)tableView withTableView:(UITableView *)tb atIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    
    if(indexPath.section == 5)
    {
        cell = [tb dequeueReusableCellWithIdentifier:@"appRecomCellID" forIndexPath:indexPath];
        AppRecommendCell *appCell = (AppRecommendCell*)cell;
        [appCell config:nil];
        
    }
    else
    {
        cell = [tb dequeueReusableCellWithIdentifier:@"discoveryCellID" forIndexPath:indexPath];
        
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        NSArray *array = self.dataArray[indexPath.section];
        NSDictionary *dict = array[indexPath.row];
        
        cell.imageView.image = [UIImage imageNamed:dict[@"image"]];
        cell.textLabel.text = dict[@"title"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    return cell;
}

-(UIView *)headerViewInFMtableView:(FMTableView *)tableView
{
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    imageView.image = [UIImage imageNamed:@"loading_logo"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return imageView;
}

-(void)FMTableView:(FMTableView *)tableView registerCellWithTableView:(UITableView *)tb
{
    [tb registerClass:[UITableViewCell class] forCellReuseIdentifier:@"discoveryCellID"];
    [tb registerNib:[UINib nibWithNibName:@"AppRecommendCell" bundle:nil] forCellReuseIdentifier:@"appRecomCellID"];
}


-(CGFloat)FMtableView:(FMTableView *)tableView highForCellAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 5)
    {
        return 100;
    }
    return 44.0f;
}

-(CGFloat)FMtableView:(FMTableView *)tableView highForHeaderViewAtSection:(NSInteger)section
{
    if(section == 5)
    {
        return 30.0f;
    }
    return 15.0f;
}

-(UIView*)FMtableView:(FMTableView *)tableView headerViewAtSection:(NSInteger)section
{
    UIView *view;
    if(section == 5)
    {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
        UILabel *label = [FMUtil createLabelWithFrame:CGRectMake(100, 0, 100, 20) withFont:[UIFont systemFontOfSize:12] withTextColor:[UIColor grayColor] withTitle:@"应用推荐"];
        [view addSubview:label];
    }
    return view;
}

-(void)FMTableView:(FMTableView *)tableView didSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        //活动与团购
        if(indexPath.row == 0)
        {
            FMDisActivyController *activyVC = [[FMDisActivyController alloc]init];
            activyVC.title = @"活动&团购";
            [self.navigationController pushViewController:activyVC animated:YES];
        }
    }
    else if(indexPath.section == 1)
    {
        //汽车电台
        if(indexPath.row == 0)
        {
            FMDisRadioController *radioVC = [[FMDisRadioController alloc]init];
            [self.navigationController pushViewController:radioVC animated:YES];
        }
    }
    else if(indexPath.section == 2)
    {
        //车型对比
        if(indexPath.row == 0)
        {
            FMDisDiffController *diffVC = [[FMDisDiffController alloc]init];
            diffVC.title = @"车型对比";
            [self.navigationController pushViewController:diffVC animated:YES];
        }
        else if(indexPath.row == 1) //购车计算
        {
            
        }
        else if(indexPath.row == 2) //违章查询
        {
            
        }
        else if(indexPath.row == 3) //找二手车
        {
            FMDisSecondCarController *secondCarVC = [[FMDisSecondCarController alloc]init];
            secondCarVC.title = @"找二手车";
            [self.navigationController pushViewController:secondCarVC animated:YES];
        }
    }
    else if (indexPath.section == 3)
    {
        //车商城
        if(indexPath.row == 0)
        {
            
        }
        else if(indexPath.row == 1) //养车特惠
        {
            
        }
    }
    else if (indexPath.section == 4)
    {
        if(indexPath.row == 0)
        {
            
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
