//
//  FMOriginalVideoViewController.m
//  AutoHome
//
//  Created by qianfeng on 15/5/13.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMOriginalVideoViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "OriVideoModel.h"
#import "FMTableView.h"
#import "NewsCell.h"
#import "NewsModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FMWebController.h"

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface FMOriginalVideoViewController ()<FMTableViewDelegate, EGORefreshTableDelegate>
{
    FMTableView *_tableView;
    //EGO上拉下拉刷新
    EGORefreshTableHeaderView *_headerView;
    EGORefreshTableFooterView *_footerView;
    
    BOOL _isLoading;
    
    NSInteger _curPage;
}

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation FMOriginalVideoViewController

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
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    _curPage = 1;
    
    [self createTableView];
    
    void (^tapBlock)() = ^{
        [self downloadData];
    };
    [FMProgressHUD showOnView:self.view setTapBlock:tapBlock];
    [self downloadData];
}


-(void)createTableView
{
    _tableView = [[FMTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) withStyle:UITableViewStylePlain isLoadXib:YES];
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    
    //EGO上拉下拉刷新
    _headerView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -_tableView.tableView.bounds.size.height, _tableView.tableView.bounds.size.width, _tableView.tableView.bounds.size.height)];
    _headerView.delegate = self;
    [_tableView.tableView addSubview:_headerView];
    
    _footerView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectZero];
    CGFloat height = MAX(_tableView.tableView.bounds.size.height, _tableView.tableView.contentSize.height);
    
    _footerView.frame = CGRectMake(0, height, _tableView.tableView.bounds.size.width, 0);
    _footerView.delegate = self;
    [_tableView.tableView addSubview:_footerView];
    
    //修改时间
    [_headerView refreshLastUpdatedDate];
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
            
            for(NSDictionary *listDict in resultDict[@"list"])
            {
                OriVideoModel *model = [[OriVideoModel alloc]init];
                [model setValuesForKeysWithDictionary:listDict];
                [self.dataArray addObject:model];
            }
        
        }
        
        [_tableView reloadData];
        [FMProgressHUD hideAfterSuccessOnView:self.view];
        _isLoading = NO;
        //设置上拉下拉刷新视图
        [_headerView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView.tableView];
        [_footerView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView.tableView];
        [self resetFooterFrame];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //提示网络问题
        [FMProgressHUD hideAfterFailOnView:self.view];
    }];
}

//设置上拉加载更多视图的位置
- (void)resetFooterFrame
{
    CGFloat height = MAX(_tableView.tableView.bounds.size.height, _tableView.tableView.contentSize.height);
    
    _footerView.frame = CGRectMake(0, height, _tableView.tableView.bounds.size.width, 0);
    
}



#pragma mark - EGORefreshTable代理
//是否正在刷新
-(BOOL)egoRefreshTableDataSourceIsLoading:(UIView *)view
{
    return _isLoading;
}

//刷新的时间
- (NSDate *)egoRefreshTableDataSourceLastUpdated:(UIView *)view
{
    return [NSDate date];
}
//刷新时的操作
-(void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    if (_isLoading) {
        return;
    }
    
    if (aRefreshPos == EGORefreshHeader) {
        //下拉刷新
        _curPage = 1;
        [self downloadData];
        
    }else if (aRefreshPos == EGORefreshFooter){
        //上拉加载更多
        _curPage += 1;
        [self downloadData];
    }
}

#pragma mark - UIScrollView代理
-(void)FMTableView:(FMTableView *)tableView didScroll:(UITableView *)tb
{
    [_headerView egoRefreshScrollViewDidScroll:tb];
    [_footerView egoRefreshScrollViewDidScroll:tb];
}

-(void)FMTableView:(FMTableView *)tableView didEndDraging:(UITableView *)tb
{
    [_headerView egoRefreshScrollViewDidEndDragging:tb];
    [_footerView egoRefreshScrollViewDidEndDragging:tb];
}

#pragma mark - FMTableViewDelegate
-(NSInteger)numberOfSections:(FMTableView *)tableView
{
    return 1;
}

-(NSInteger)FMTableView:(FMTableView *)tableView numberOfRowsAtSection:(NSInteger)section
{
    return self.dataArray.count;
}

// model->model
-(NewsModel*)transferOriVideoModel:(OriVideoModel*)model
{
    NewsModel *newsModel = [[NewsModel alloc]init];
    newsModel.ID = model.Id;
    newsModel.title = model.title;
    newsModel.mediatype = nil;
    newsModel.type= model.type;
    newsModel.time = model.updatetime;
    newsModel.indexdetail = model.indexdetail;
    newsModel.smallpic = model.smallimg;
    newsModel.replycount = model.playcount;
    newsModel.jumppage = nil;
    newsModel.lasttime = nil;
    newsModel.newstype = [NSNumber numberWithInt:100];
    newsModel.updatetime = model.updatetime;
    
    return newsModel;
}

-(UITableViewCell*)FMTableView:(FMTableView*)tableView withTableView:(UITableView*)tb atIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = nil;
    
    cell = [tb dequeueReusableCellWithIdentifier:@"NewsCellID" forIndexPath:indexPath];
    
    NewsCell *newsCell = (NewsCell*)cell;
    
    NewsModel *model = [self transferOriVideoModel:self.dataArray[indexPath.row]];
    
    [newsCell config:model];
    return cell;
}

-(void)FMTableView:(FMTableView *)tableView registerCellWithTableView:(UITableView *)tb
{
    [tb registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:@"NewsCellID"];
    [tb registerNib:[UINib nibWithNibName:@"NewsPicCell" bundle:nil] forCellReuseIdentifier:@"NewsPicCellID"];
}

-(void)FMTableView:(FMTableView *)tableView didSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    OriVideoModel *model = self.dataArray[indexPath.row];
  
    FMWebController *webVC = [[FMWebController alloc]init];
    webVC.url = [NSURL URLWithString:model.shareaddress];
    [self.navigationController pushViewController:webVC animated:YES];
    
}

-(CGFloat)FMtableView:(FMTableView *)tableView highForCellAtIndexPath:(NSIndexPath *)indexPath
{

    return 80.0f;
    
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
