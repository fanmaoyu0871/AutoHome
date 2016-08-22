//
//  FMCommentController.m
//  AutoHome
//
//  Created by qianfeng on 15/5/13.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMCommentController.h"
#import "FMNavView.h"
#import "FMSearchController.h"
#import "ChannelManager.h"
#import "FMSliderView.h"
#import "FMContentScrollView.h"
#import "FMCategorySliderController.h"
#import "FMNavigationController.h"
#import "FMDailyPaperController.h"
#import "CommentURL.h"


@interface FMCommentController ()<UIScrollViewDelegate>
{
    UIView *_bgView;
    FMNavView *_navView;
    FMNavView *_channelView;
    FMSliderView *_sliderView;
    NSArray *_channel;
    NSArray *_idArray;
    
    //当前频道索引
    NSInteger _channelIndex;
    
    //主页面滚动视图
    FMContentScrollView *_contentSV;
    
    //精选日报页面
    FMDailyPaperController *_channelVC;
    
    //侧滑视图
    FMCategorySliderController *_sliderVC;
}

@property (nonatomic, strong)NSMutableArray *commentArray;

@end

@implementation FMCommentController

-(NSMutableArray *)commentArray
{
    if(_commentArray == nil)
    {
        _commentArray = [NSMutableArray array];
        
        NSArray *array = [[ChannelManager sharedChannelManager] comments];
        [_commentArray addObjectsFromArray:array];
    }
    
    return _commentArray;
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
    for(NSDictionary *dict in self.commentArray)
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

-(void)createChannelScrollView
{
    _channel = @[@"全部", @"媳妇当车模", @"美人\"记\"", @"论坛名人堂", @"论坛讲师", @"精挑细选", @"现身说法",@"高端阵地", @"电动车", @"汇买车", @"行车点评", @"超级驾驶员", @"海外购车", @"经典老车", @"妹子选车", @"优惠购车", @"顶配风采", @"原创大片", @"改装有理", @"养车有道", @"首发阵营", @"新车直播", @"历史选题", @"精彩视频", @"蜜月之旅", @"摩友天地", @"甜蜜婚礼", @"摄影课堂", @"车友聚会", @"单车部落", @"杂谈俱乐部", @"华北游记", @"西南游记", @"东北游记",@"西北游记",@"华中游记",@"华南游记",@"华东游记",@"港澳台游记", @"海外游记", @"沧海遗珠"];
    _idArray = @[@"0", @"104", @"110", @"172", @"230", @"121", @"106", @"118", @"210", @"199", @"198", @"168", @"113", @"109", @"191", @"196",@"105", @"107", @"122", @"194", @"119", @"191", @"112", @"120", @"227", @"108", @"184", @"124",  @"123",@"185", @"186", @"214", @"218", @"223", @"221", @"222", @"220", @"224", @"219", @"225", @"226", @"212"];
    
    _channelView = [[FMNavView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 43) withInset:44 withArray:_channel withBtnFont:[UIFont systemFontOfSize:13]];
    [_channelView hideScrollLine];
    [_contentSV addSubview:_channelView];
    _channelView.channelChangeBlock = ^(NSInteger index){
        _channelIndex = index;
        
        //加载对应频道的页面
        [_channelVC downloadDataWithUrlStr:[NSString stringWithFormat:CHANNEL_URL, _idArray[index]]];
        
    };
    
    //创建下拉菜单按钮
    UIButton *menuBtn = [FMUtil createButtonWithFrame:CGRectMake(SCREEN_WIDTH-40, 0, 40, _channelView.bounds.size.height) withTitle:nil withImageName:@"bar_btn_icon_album" withSelImageName:nil withHigImageName:nil withTarget:self withAction:@selector(channelMenuClick)];
    [_channelView addSubview:menuBtn];
}


-(void)channelMenuClick
{
    [self createSliderView];
    
    //添加侧滑视图和控制器
    _sliderVC = [[FMCategorySliderController alloc]init];

    FMNavigationController *nav = [[FMNavigationController alloc]initWithRootViewController:_sliderVC];
    [_sliderView addSubview:_sliderVC.view];
    [self addChildViewController:nav];
    
    _sliderVC.dataArray = _channel;
    _sliderVC.navTitle = @"精品分类";
    [_sliderVC setSelectedIndex:_channelIndex];
    _sliderVC.closeBtnBlock = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, USEC_PER_SEC*500), dispatch_get_main_queue(), ^{
            [_sliderVC.view removeFromSuperview];
            [_sliderView removeFromSuperview];
            [nav removeFromParentViewController];
            _sliderView = nil;
        });
    };
    _sliderVC.selectCellBlock = ^(NSInteger index){
        [_channelView reloadLineViewAtIndex:index];
    };
    [_sliderVC reloadData];
    
    //左滑动画
    [_sliderVC leftSlide];

}

#pragma mark - 创建侧滑视图
-(void)createSliderView
{
    _sliderView = [[FMSliderView alloc]initWithFrame:CGRectMake(0, 20,SCREEN_WIDTH, SCREEN_HEIGHT-20)];
    [[UIApplication sharedApplication].keyWindow addSubview:_sliderView];
}

//创建主界面滚动视图
-(void)createContentScrollView
{
    _contentSV = [[FMContentScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) withContentCount:self.commentArray.count];
    _contentSV.delegate = self;
    _contentSV.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_contentSV];
    
    [self addchildControllers];
}

-(void)addchildControllers
{
    NSArray *array = self.commentArray;
    
    for(int i = 0; i < array.count; i++)
    {
        NSDictionary *dict = array[i];
        NSString *vcName = dict[@"vcName"];
        Class cls = NSClassFromString(vcName);
        if(i == 0)
        {
            FMDailyPaperController *vc = [[cls alloc] init];
            vc.urlStr = dict[@"url"];
            vc.view.frame = CGRectMake(i*SCREEN_WIDTH, 44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44);
            [self createChannelScrollView];
            
            _channelVC = vc;
            
            [self addChildViewController:vc];
            [_contentSV addSubview:vc.view];
        }
        else
        {
            UIViewController *vc = [[cls alloc] init];
            vc.view.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
            
            [self addChildViewController:vc];
            [_contentSV addSubview:vc.view];
        }
    }
    
    _contentSV.contentSize = CGSizeMake(array.count*SCREEN_WIDTH, 0);
}

#pragma  mark - scrollView协议方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    [_navView reloadLineViewAtIndex:offset.x/SCREEN_WIDTH];
}


#pragma mark - 搜索按钮事件
-(void)searchBtnClick:(UIButton*)btn
{
    FMSearchController *searchVC = [[FMSearchController alloc]init];
    [self.navigationController pushViewController:searchVC animated:NO];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
