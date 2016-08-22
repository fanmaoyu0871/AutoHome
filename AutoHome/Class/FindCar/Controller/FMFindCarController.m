//
//  FMFindCarController.m
//  AutoHome
//
//  Created by qianfeng on 15/5/13.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMFindCarController.h"
#import "ChannelManager.h"
#import "FMNavView.h"
#import "FMSearchController.h"
#import "FMContentScrollView.h"
#import "FMTableView.h"
#import "FMFindCarBaseController.h"

@interface FMFindCarController ()<UIScrollViewDelegate>
{
    FMNavView *_navView;
    FMContentScrollView *_contentSV;
}

@property (nonatomic, strong)NSMutableArray *findcarArray;

@end

@implementation FMFindCarController

-(NSMutableArray *)findcarArray
{
    if(_findcarArray == nil)
    {
        _findcarArray = [NSMutableArray array];
        
        NSArray *array = [[ChannelManager sharedChannelManager] findcars];
        [_findcarArray addObjectsFromArray:array];
    }
    
    return _findcarArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self createContentScrollView];
}


//创建导航条
-(void)createNav
{
    //加载频道数据
    NSMutableArray *titles = [NSMutableArray array];
    for(NSDictionary *dict in self.findcarArray)
    {
        NSString *title = dict[@"title"];
        [titles addObject:title];
    }
    
    _navView = [[FMNavView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 43) withInset:90 withArray:titles withBtnFont:[UIFont systemFontOfSize:15]];
    [self.navBar addSubview:_navView];
    _navView.channelChangeBlock = ^(NSInteger index){
        [_contentSV setContentOffset:CGPointMake(index*SCREEN_WIDTH, 0) animated:YES];
    };
    
    //创建搜索按钮
    UIButton *searchBtn = [FMUtil createButtonWithFrame:CGRectMake(SCREEN_WIDTH-40, 0, 40, _navView.bounds.size.height) withTitle:nil  withImageName:@"bar_btn_icon_search" withSelImageName:nil withHigImageName:nil withTarget:self withAction:@selector(searchBtnClick:)];
    [_navView addSubview:searchBtn];
}


-(void)createContentScrollView
{
    _contentSV = [[FMContentScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) withContentCount:self.findcarArray.count];
    _contentSV.delegate = self;
    _contentSV.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_contentSV];
    
    [self addchildControllers];
}

#pragma  mark - 加入子视图
-(void)addchildControllers
{
    NSArray *array = self.findcarArray;
    
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    [_contentSV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for(int i = 0; i < array.count; i++)
    {
        NSDictionary *dict = array[i];
        NSString *vcName = dict[@"vcName"];
        Class cls = NSClassFromString(vcName);
        FMFindCarBaseController *vc = [[cls alloc] init];
        vc.urlStr = dict[@"url"];
        vc.view.frame = CGRectMake(i*SCREEN_WIDTH, 0,SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [self addChildViewController:vc];
        [_contentSV addSubview:vc.view];
    }
    
    _contentSV.contentSize = CGSizeMake(array.count*SCREEN_WIDTH, 0);
}

#pragma mark - 搜索按钮事件
-(void)searchBtnClick:(UIButton*)btn
{
    FMSearchController *searchVC = [[FMSearchController alloc]init];
    [self.navigationController pushViewController:searchVC animated:NO];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    [_navView reloadLineViewAtIndex:offset.x/SCREEN_WIDTH];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
