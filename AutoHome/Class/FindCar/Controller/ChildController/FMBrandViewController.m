//
//  FMBrandViewController.m
//  AutoHome
//
//  Created by 范茂羽 on 15/5/17.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMBrandViewController.h"
#import "BrandModel.h"
#import "FMTableView.h"
#import "FMBrandSliderController.h"
#import "FMSliderView.h"
#import "FMNavigationController.h"
#import "FindCar.h"
#import "AFHTTPRequestOperationManager.h"
#import "BrandModel.h"
#import "BrandCell.h"
#import "SelectedBrandModel.h"

@interface FMBrandViewController ()<FMTableViewDelegate>
{
    //侧滑视图
    FMBrandSliderController *_sliderVC;
    FMSliderView *_sliderView;
    FMTableView *_tableView;
    FMTableView *_sliderTableView;
    
    BrandModel* _curModel;
}

@property (nonatomic, strong)NSMutableArray *letterArray;
@property (nonatomic, strong)NSMutableArray *brandArray;

@property (nonatomic, strong)NSMutableArray *resultArray;

@end

@implementation FMBrandViewController

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

-(void)downloadWithModel:(BrandModel*)model withType:(int)index
{
    //保存当前的model
    _curModel = model;
    
    //进行网络请求
    NSString *urlString = [NSString stringWithFormat:SELECTEDBRAND_URL, [model.Id integerValue], index];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //清空数据
        [self.resultArray removeAllObjects];
        
        id object = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = object;
            NSDictionary *resultDict =dict[@"result"];
            NSArray *fctlistArray = resultDict[@"fctlist"];
            NSDictionary *fctlistDict = [fctlistArray firstObject];
            NSArray *serieslistArray = fctlistDict[@"serieslist"];
            for(NSDictionary *modelDict in serieslistArray)
            {
                SelectedBrandModel *model = [[SelectedBrandModel alloc]init];
                model.Id = modelDict[@"id"];
                [model setValuesForKeysWithDictionary:modelDict];
                [self.resultArray addObject:model];
            }
            
        }
        
        _sliderVC.dataArray = self.resultArray;
        [_sliderVC reloadData];
        [_sliderTableView reloadData];
        
        [FMProgressHUD hideAfterSuccessOnView:_sliderVC.view];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [FMProgressHUD hideAfterFailOnView:_sliderVC.view];
    }];

}


-(void)FMTableView:(FMTableView *)tableView didSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    
    //点击了一个品牌就创建
    [self createSliderView];
    
    
    //加载对应id的数据
    BrandModel *model = self.brandArray[indexPath.section-2][indexPath.row];
    
    [self downloadWithModel:model withType:1];
    
}

-(void)createSliderView
{
    [self createBgView];
    
    //添加侧滑视图和控制器
    _sliderVC = [[FMBrandSliderController alloc]init];
    
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
    
    _sliderVC.segCtrlValueChange = ^(int index){
        [self downloadWithModel:_curModel withType:index+1];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [FMProgressHUD showOnView:self.view];
    [self downloadData];
}



-(void)downloadData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id object = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = object;
            NSDictionary *resultDict =dict[@"result"];
            NSArray *letterArray = resultDict[@"brandlist"];
            for(NSDictionary *letDict in letterArray)
            {
                [self.letterArray addObject:letDict[@"letter"]];
                NSMutableArray *array = [NSMutableArray array];
                for(NSDictionary *brandDict in letDict[@"list"])
                {
                    BrandModel *model = [[BrandModel alloc]init];
                    model.Id = brandDict[@"id"];
                    model.name = brandDict[@"name"];
                    model.imgurl = brandDict[@"imgurl"];
                    [model setValuesForKeysWithDictionary:brandDict];
                    [array addObject:model];
                }
                
                [self.brandArray addObject:array];
            }
        }
        
        //加载完数据在创建tableview，在不然没法玩
        [self createTableView];
        [_tableView reloadData];
        
        [FMProgressHUD hideAfterSuccessOnView:self.view];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [FMProgressHUD hideAfterFailOnView:self.view];
    }];
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
    return self.letterArray.count+2;
}

-(NSInteger)FMTableView:(FMTableView *)tableView numberOfRowsAtSection:(NSInteger)section
{
    if(section == 0 || section == 1)
    {
        return 1;
    }
    else
    {
        return [self.brandArray[section-2] count];
    }
}

-(UITableViewCell *)FMTableView:(FMTableView *)tableView withTableView:(UITableView *)tb atIndexPath:(NSIndexPath *)indexPath
{
    BrandCell *cell =  [tb dequeueReusableCellWithIdentifier:@"brandCellID" forIndexPath:indexPath];
    
    
    if(indexPath.section == 0)
    {
        cell.nameLabel.text = @"我的收藏";
        cell.picImageView.image = [UIImage imageNamed:@"findcar_icon_collect"];
    }
    else if(indexPath.section == 1)
    {
        cell.nameLabel.text = @"热销车";
        cell.picImageView.image = [UIImage imageNamed:@"icon_hot"];
    }
    else
    {
        BrandModel *model = self.brandArray[indexPath.section-2][indexPath.row];
        
        [cell config:model];
    }
    return cell;
}

-(void)FMTableView:(FMTableView *)tableView registerCellWithTableView:(UITableView *)tb
{
    [tb registerNib:[UINib nibWithNibName:@"BrandCell" bundle:nil] forCellReuseIdentifier:@"brandCellID"];
}


-(CGFloat)FMtableView:(FMTableView *)tableView highForCellAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 || indexPath.section == 1)
    {
        return 60;
    }
    else
    {
        return 44;
    }
}

-(NSString*)FMTableView:(FMTableView *)tableView titleForHeaderAtSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"星星";
    }
    else if(section == 1)
    {
        return @"推荐";
    }
    else
    {
        return self.letterArray[section-2];
    }
}


-(CGFloat)FMtableView:(FMTableView *)tableView highForHeaderViewAtSection:(NSInteger)section
{
    return 20;
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
