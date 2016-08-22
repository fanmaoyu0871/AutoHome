//
//  FMPriceDownViewController.m
//  AutoHome
//
//  Created by 范茂羽 on 15/5/17.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMPriceDownViewController.h"
#import "FMChooseButton.h"
#import "FMTableView.h"
#import "AFHTTPRequestOperationManager.h"
#import "PriceDownModel.h"
#import "PriceDownCell.h"

@interface FMPriceDownViewController ()<FMTableViewDelegate>
{
    NSArray *_channelArray;
    FMTableView *_tableView;
}

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation FMPriceDownViewController

-(NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [FMProgressHUD showOnView:self.view];
    [self downloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _channelArray = @[@"品牌", @"价格", @"级别", @"排序", @"北京"];
    [self createScrollView];
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
            NSDictionary *resultDict = dict[@"result"];
            NSArray *carlistArray = resultDict[@"carlist"];
            
            for(NSDictionary *dealerDict in carlistArray)
            {
                PriceDownModel *model = [[PriceDownModel alloc]init];
                PriceDownModel2 *model2 = [[PriceDownModel2 alloc]init];
                [model setValuesForKeysWithDictionary:dealerDict[@"dealer"]];
                
                [model2 setValuesForKeysWithDictionary:dealerDict];
                model.model2 = model2;
                [self.dataArray addObject:model];
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

-(void)createScrollView
{
   
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    
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
    [_tableView reloadData];
}

-(void)createTableView
{
    _tableView = [[FMTableView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-49-64-44) withStyle:UITableViewStyleGrouped isLoadXib:NO];
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
}
#pragma  mark - FMTableView协议方法
-(NSInteger)numberOfSections:(FMTableView *)tableView
{
    return self.dataArray.count;
}

-(NSInteger)FMTableView:(FMTableView *)tableView numberOfRowsAtSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)FMTableView:(FMTableView *)tableView withTableView:(UITableView *)tb atIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =  [tb dequeueReusableCellWithIdentifier:@"priceDownCellID" forIndexPath:indexPath];
    
    PriceDownCell *pCell = (PriceDownCell*)cell;
    
    [pCell configWithModel:self.dataArray[indexPath.section]];
    
    return cell;
}

-(void)FMTableView:(FMTableView *)tableView registerCellWithTableView:(UITableView *)tb
{
    [tb registerNib:[UINib nibWithNibName:@"PriceDownCell" bundle:nil] forCellReuseIdentifier:@"priceDownCellID"];
}


-(CGFloat)FMtableView:(FMTableView *)tableView highForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return 140.0f;
}


-(CGFloat)FMtableView:(FMTableView *)tableView highForHeaderViewAtSection:(NSInteger)section
{
    return 10.0f;
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
