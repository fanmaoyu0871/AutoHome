//
//  FMDailyPaperControllerTableViewController.m
//  AutoHome
//
//  Created by qianfeng on 15/5/14.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMDailyPaperController.h"
#import "FMTableView.h"
#import "AFHTTPRequestOperationManager.h"
#import "JingxuanModel.h"
#import "JingxuanCell.h"

@interface FMDailyPaperController ()<FMTableViewDelegate>
{
    FMTableView *_tableView;
}

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation FMDailyPaperController

-(NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];

    [self createTableView];
    [self downloadDataWithUrlStr:self.urlStr];
}

-(void)downloadDataWithUrlStr:(NSString*)urlStr
{
    //清空数据
    [self.dataArray removeAllObjects];
    
    [FMProgressHUD showOnView:self.view];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id obj =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = obj;
            NSDictionary *result =  dict[@"result"];
            
            //普通数据
            for(NSDictionary *modelDict in result[@"list"])
            {
                JingxuanModel *model = [[JingxuanModel alloc]init];
                [model setValuesForKeysWithDictionary:modelDict];
                [self.dataArray addObject:model];
            }
            
        }
        [_tableView reloadData];
        [FMProgressHUD hideAfterSuccessOnView:self.view];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //提示网络问题
        [FMProgressHUD hideAfterFailOnView:self.view];
    }];
}


-(void)createTableView
{
    _tableView = [[FMTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) withStyle:UITableViewStylePlain isLoadXib:YES];
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}


#pragma mark - FMTableView协议方法
-(NSInteger)numberOfSections:(FMTableView *)tableView
{
    return 1;
}

-(NSInteger)FMTableView:(FMTableView *)tableView numberOfRowsAtSection:(NSInteger)section
{
    return self.dataArray.count;
}


-(UITableViewCell*)FMTableView:(FMTableView*)tableView withTableView:(UITableView*)tb atIndexPath:(NSIndexPath*)indexPath
{
    JingxuanModel *model = self.dataArray[indexPath.row];
    
    UITableViewCell *cell = nil;
    cell = [tb dequeueReusableCellWithIdentifier:@"JingxuanCellID" forIndexPath:indexPath];
    
    JingxuanCell *jingxuanCell = (JingxuanCell*)cell;
    [jingxuanCell configJingxuanModel:model];
    
    return cell;
}

-(void)FMTableView:(FMTableView *)tableView registerCellWithTableView:(UITableView *)tb
{
    [tb registerNib:[UINib nibWithNibName:@"JingxuanCell" bundle:nil] forCellReuseIdentifier:@"JingxuanCellID"];
}

-(CGFloat)FMtableView:(FMTableView *)tableView highForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
