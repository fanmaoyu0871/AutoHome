//
//  FMChannelBaseController.m
//  AutoHome
//
//  Created by qianfeng on 15/5/14.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMChannelBaseController.h"
#import "FMTableView.h"
#import "AFHTTPRequestOperationManager.h"
#import "NewsModel.h"
#import "NewsCell.h"
#import "AdModel.h"
#import "UIImageView+WebCache.h"
#import "NewsPicCell.h"
#import "RecommendURL.h"
#import "FMWebController.h"
#import "NSString+Tools.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface FMChannelBaseController ()<FMTableViewDelegate, UIScrollViewDelegate, EGORefreshTableDelegate>
{
    FMTableView *_tableView;
    UIScrollView *_adHeaderView;
    UIPageControl *_pageControl;
    NSTimer *_timer;
    NSMutableArray *_newAdArray;
    
    //EGO上拉下拉刷新
    EGORefreshTableHeaderView *_headerView;
    EGORefreshTableFooterView *_footerView;
    
    BOOL _isLoading;
    
    NSInteger _curPage;
}

@end

@implementation FMChannelBaseController

-(NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

-(NSMutableArray *)adArray
{
    if(_adArray == nil)
    {
        _adArray = [NSMutableArray array];
    }
    
    return _adArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.view.backgroundColor = RGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
    self.view.backgroundColor = [UIColor whiteColor];
    _curPage = 1;
    
    [self createTableView];
    
    void (^tapBlock)() = ^{
        [self downloadData];
    };
    [FMProgressHUD showOnView:self.view setTapBlock:tapBlock];
    [self downloadData];
  
}

-(void)downloadData
{
    _isLoading = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(_curPage == 1)
        {
            [self.adArray removeAllObjects];
            [self.dataArray removeAllObjects];
            self.adArray = nil;
            self.dataArray = nil;
        }
        
       id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = obj;
            NSDictionary *result =  dict[@"result"];
            
            //滚动广告栏数据
            for(NSDictionary *adDict in result[@"focusimg"])
            {
                AdModel *adModel = [[AdModel alloc]init];
                adModel.ID = adDict[@"id"];
                [adModel setValuesForKeysWithDictionary:adDict];
                [self.adArray addObject:adModel];
            }
            
            //头条数据
            if(result[@"headlineinfo"])
            {
                if(![result[@"headlineinfo"] isEqualToDictionary:@{}])
                {
                    NewsModel *model = [[NewsModel alloc]init];
                    NSDictionary *topDict = result[@"headlineinfo"];
                    model.ID = topDict[@"id"];
                    [model setValuesForKeysWithDictionary:topDict];
                    [self.dataArray addObject:model];
                }
            }
            
            
            //普通数据
            for(NSDictionary *modelDict in result[@"newslist"])
            {
                NewsModel *model = [[NewsModel alloc]init];
                model.ID = modelDict[@"id"];
                [model setValuesForKeysWithDictionary:modelDict];
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
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //首页面加载成功了后，继续加载每个cell对应的html页面，保存到本地
            [self downloadWebDataWithModelArray:self.dataArray];
        });
        
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

-(void)downloadWebDataWithModelArray:(NSArray*)modelArray;
{
    for (int i = 0; i < modelArray.count; i++)
    {
        NewsModel *model = modelArray[i];
        NSString *urlString = [NSString stringWithFormat:SELECTED_NEWS_URL, [model.ID integerValue]];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSData *data = responseObject;
            
            NSString *htmlPath = [NSString stringForHtmlPath:urlString];
            
            [data writeToFile:htmlPath atomically:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
    
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

-(UITableViewCell*)FMTableView:(FMTableView*)tableView withTableView:(UITableView*)tb atIndexPath:(NSIndexPath*)indexPath
{
    NewsModel *model = self.dataArray[indexPath.row];
    UITableViewCell *cell = nil;
    
    if([model.mediatype integerValue] != 6)
    {
        cell = [tb dequeueReusableCellWithIdentifier:@"NewsCellID" forIndexPath:indexPath];
        
        NewsCell *newsCell = (NewsCell*)cell;
        [newsCell config:model];
    }
    else
    {
        cell = [tb dequeueReusableCellWithIdentifier:@"NewsPicCellID" forIndexPath:indexPath];
        
        NewsPicCell *picCell = (NewsPicCell*)cell;
        [picCell config:model];
    }
    return cell;
}

-(void)FMTableView:(FMTableView *)tableView registerCellWithTableView:(UITableView *)tb
{
    [tb registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:@"NewsCellID"];
    [tb registerNib:[UINib nibWithNibName:@"NewsPicCell" bundle:nil] forCellReuseIdentifier:@"NewsPicCellID"];
}

-(void)FMTableView:(FMTableView *)tableView didSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    NewsModel *model = self.dataArray[indexPath.row];
    NSString *urlStr = [NSString stringWithFormat:SELECTED_NEWS_URL, [model.ID integerValue]];
    
    FMWebController *webVC = [[FMWebController alloc]init];
    NSString *htmlPath = [NSString stringForHtmlPath:urlStr];
    webVC.url = [NSURL URLWithString:htmlPath];
    [self.navigationController pushViewController:webVC animated:YES];
}

-(CGFloat)FMtableView:(FMTableView *)tableView highForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NewsModel *model = self.dataArray[indexPath.row];
    
    if([model.mediatype integerValue] == 6)
    {
        return 150.0f;
    }
    else
    {
        return 80.0f;
    }
    
}

-(UIView *)headerViewInFMtableView:(FMTableView *)tableView
{
    //如果该页面没有广告数据，直接返回nil
    if(_adArray == nil)
    {
        return nil;
    }
    
    //创建背景视图
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)];
    
    //创建scrollview
    _adHeaderView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)];
    
    //实现无缝循环滚动
    _newAdArray = [NSMutableArray array];
    [_newAdArray addObject:self.adArray[self.adArray.count-1]];
    [_newAdArray addObjectsFromArray:self.adArray];
    [_newAdArray addObject:self.adArray[0]];
    [bgView addSubview:_adHeaderView];
    
    for(int i = 0; i < _newAdArray.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*_adHeaderView.bounds.size.width, 0, _adHeaderView.bounds.size.width, _adHeaderView.bounds.size.height)];
        imageView.userInteractionEnabled = YES;
        
        //创建点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [imageView addGestureRecognizer:tap];
        
        AdModel *adModel = _newAdArray[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:adModel.imgurl]];
        [_adHeaderView addSubview:imageView];
    }
    
    //创建完所有图片,将contentOffset移到第二张
    _adHeaderView.contentOffset = CGPointMake(_adHeaderView.bounds.size.width, 0);
    
    _adHeaderView.delegate = self;
    _adHeaderView.contentSize = CGSizeMake(_newAdArray.count*_adHeaderView.bounds.size.width, 0);
    _adHeaderView.showsHorizontalScrollIndicator = NO;
    _adHeaderView.pagingEnabled = YES;
    
    //创建pageControl
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame)-20, _adHeaderView.bounds.size.width, 20)];
    _pageControl.numberOfPages = self.adArray.count;
    [bgView addSubview:_pageControl];
    [bgView bringSubviewToFront:_pageControl];
    
    
    //创建定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
    return bgView;
}

//点击手势操作
-(void)tapAction
{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _adHeaderView) {
        
        if(scrollView.contentOffset.x == 0)
        {
            scrollView.contentOffset = CGPointMake(scrollView.contentSize.width-2*scrollView.bounds.size.width, 0);
            
        }
        
        if(scrollView.contentOffset.x == scrollView.contentSize.width-scrollView.bounds.size.width)
        {
            scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        }
        
        _pageControl.currentPage = (scrollView.contentOffset.x-scrollView.bounds.size.width)/_adHeaderView.bounds.size.width + 0.5;
        
    }
    
    
}


-(void)updateTimer
{
    [_adHeaderView setContentOffset:CGPointMake(_adHeaderView.contentOffset.x+_adHeaderView.bounds.size.width, 0) animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
