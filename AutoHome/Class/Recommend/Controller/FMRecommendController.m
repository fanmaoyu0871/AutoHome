//
//  FMRecommendController.m
//  AutoHome
//
//  Created by qianfeng on 15/5/13.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMRecommendController.h"
#import "FMNavView.h"
#import "MenuView.h"
#import "FMSearchController.h"
#import "ChannelManager.h"
#import "FMContentScrollView.h"
#import "FMNewsViewController.h"
#import "RecommendURL.h"

@interface FMRecommendController ()<UIScrollViewDelegate>
{
    FMNavView *_navView;
    FMContentScrollView *_contentSV;
}

@property (nonatomic, strong)NSMutableArray *channelArray;
@property (nonatomic, strong)NSMutableArray *viewArray;

@end

@implementation FMRecommendController

-(NSMutableArray *)channelArray
{
    if(_channelArray == nil)
    {
        _channelArray = [NSMutableArray array];
        
        NSArray *array = [[ChannelManager sharedChannelManager] items];
       [_channelArray addObjectsFromArray:array];
    }
    
    return _channelArray;
}

-(NSMutableArray *)viewArray
{
    if(_viewArray == nil)
    {
        _viewArray = [NSMutableArray array];
        
        NSArray *array = [[ChannelManager sharedChannelManager] items];
        [_viewArray addObjectsFromArray:array];
    }
    
    return _viewArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    
    [self createContentScrollView];
}

-(void)createNav
{
    NSMutableArray *titles = [NSMutableArray array];
    for(NSDictionary *dict in self.channelArray[0])
    {
        NSString *title = dict[@"title"];
        [titles addObject:title];
    }
    
    _navView = [[FMNavView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 43) withInset:90 withArray: titles withBtnFont:[UIFont systemFontOfSize:15]];
    [self.navBar addSubview:_navView];
    _navView.channelChangeBlock = ^(NSInteger index){
        [_contentSV setContentOffset:CGPointMake(index*SCREEN_WIDTH, 0) animated:YES];
        
        if(index != 0)
        {
            NSDictionary *dict = self.viewArray[index+1];
            if(dict[@"isLoad"])
            {
                [_contentSV addSubview:dict[@"view"]];
                [dict setValue:[NSNumber numberWithBool:YES] forKey:@"isLoad"];
            }
        }
    };
    
    //创建下拉菜单按钮
    UIButton *menuBtn = [FMUtil createButtonWithFrame:CGRectMake(SCREEN_WIDTH-80, 0, 40, _navView.bounds.size.height) withTitle:nil withImageName:@"bar_btn_icon_album" withSelImageName:nil withHigImageName:nil withTarget:self withAction:@selector(channelMenuClick:)];
    [_navView addSubview:menuBtn];
    
    //创建搜索按钮
    UIButton *searchBtn = [FMUtil createButtonWithFrame:CGRectMake(SCREEN_WIDTH-40, 0, 40, _navView.bounds.size.height) withTitle:nil  withImageName:@"bar_btn_icon_search" withSelImageName:nil withHigImageName:nil withTarget:self withAction:@selector(searchBtnClick:)];
    [_navView addSubview:searchBtn];
}

#pragma mark - 下拉菜单按钮事件
-(void)channelMenuClick:(UIButton*)btn
{
    //隐藏tabbar
    [self hideTabBar:YES];
    
    MenuView *menu = [[MenuView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20)];
    menu.menuViewBlock = ^{
        NSArray *array = [[ChannelManager sharedChannelManager] items];
        
        [self.channelArray removeAllObjects];
        [self.channelArray addObjectsFromArray:array];
        
        NSMutableArray *titles = [NSMutableArray array];
        for(NSDictionary *dict in self.channelArray[0])
        {
            NSString *title = dict[@"title"];
            [titles addObject:title];
        }
        
        [_navView reloadButton:titles withTitleFont:[UIFont systemFontOfSize:15]];
        
        [self addchildControllers];
    };
    menu.hideTabBar = ^(BOOL isHidden){
        [self hideTabBar:isHidden];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:menu];
}

-(void)hideTabBar:(BOOL)isHidden
{
    [self.tabBarController.tabBar setHidden:isHidden];
}

#pragma mark - 搜索按钮事件
-(void)searchBtnClick:(UIButton*)btn
{
    FMSearchController *searchVC = [[FMSearchController alloc]init];
    [self.navigationController pushViewController:searchVC animated:NO];
}


#pragma mark - 创建主界面
-(void)createContentScrollView
{
    _contentSV = [[FMContentScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) withContentCount:self.channelArray.count];
    _contentSV.delegate = self;
    _contentSV.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_contentSV];
    
    [self addchildControllers];
}

#pragma  mark - 加入子视图
-(void)addchildControllers
{
    NSArray *array = self.channelArray[0];
    self.viewArray = nil;
    
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    [_contentSV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for(int i = 0; i < array.count; i++)
    {
        NSDictionary *dict = array[i];
        NSString *vcName = dict[@"vcName"];
        Class cls = NSClassFromString(vcName);
        FMChannelBaseController *vc = [[cls alloc] init];
        vc.urlStr = dict[@"url"];
        vc.view.frame = CGRectMake(i*SCREEN_WIDTH, 0,SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [self addChildViewController:vc];
        if(i == 0)
        {
            [_contentSV addSubview:vc.view];
        }
        else
        {
            NSDictionary *viewDict = @{@"isLoad":[NSNumber numberWithBool:NO], @"view":vc.view, @"title":dict[@"title"]};
            
            NSMutableDictionary *mDict = [viewDict mutableCopy];
            [self.viewArray addObject:mDict];
        }
    }
    
    _contentSV.contentSize = CGSizeMake(array.count*SCREEN_WIDTH, 0);
}

#pragma  mark - scrollView协议方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    NSInteger index = offset.x/SCREEN_WIDTH;
    [_navView reloadLineViewAtIndex:index];
    
    if(offset.x != 0)
    {
        //频道切换的时候才去加载
        NSDictionary *dict = self.viewArray[index+1];
        if(dict[@"isLoad"])
        {
            [_contentSV addSubview:dict[@"view"]];
            [dict setValue:[NSNumber numberWithBool:YES] forKey:@"isLoad"];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
