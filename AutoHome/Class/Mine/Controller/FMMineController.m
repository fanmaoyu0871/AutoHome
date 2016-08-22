//
//  FMMineController.m
//  AutoHome
//
//  Created by qianfeng on 15/5/13.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMMineController.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "FMNavView.h"
#import "FMTableView.h"
#import "LoginButton.h"

@interface FMMineController ()<FMTableViewDelegate>
{
    FMNavView *_navView;
    FMTableView *_tableView;
}

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation FMMineController

-(NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
        
        NSDictionary *dict0_0 = @{@"title":@"我的收藏", @"image":@"me_favourite"};
        NSDictionary *dict0_1 = @{@"title":@"浏览历史", @"image":@"me_history"};
        NSDictionary *dict0_2 = @{@"title":@"草稿箱", @"image":@"me_draft"};
        NSArray *array0 = @[dict0_0, dict0_1, dict0_2];
        
        NSDictionary *dict1 = @{@"title":@"设置", @"image":@"me_setting"};
        NSArray *array1 = @[dict1];
        
        
        
        [_dataArray addObject:array0];
        [_dataArray addObject:array1];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createNav];
    
    [self createTableView];
    [_tableView reloadData];
    
}

-(void)createNav
{
    _navView = [[FMNavView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 43) withInset:90 withArray:@[@"我"] withBtnFont:[UIFont systemFontOfSize:15]];
    [self.navBar addSubview:_navView];
}
-(void)createTableView
{
    _tableView = [[FMTableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) withStyle:UITableViewStyleGrouped isLoadXib:NO];
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
    if(section == 0)
    {
        return 3;
    }
    
    return 1;
}

-(UITableViewCell *)FMTableView:(FMTableView *)tableView withTableView:(UITableView *)tb atIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    cell = [tb dequeueReusableCellWithIdentifier:@"mineCellID" forIndexPath:indexPath];
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSArray *array = self.dataArray[indexPath.section];
    NSDictionary *dict = array[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:dict[@"image"]];
    cell.textLabel.text = dict[@"title"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    
    return cell;
}

-(UIView *)headerViewInFMtableView:(FMTableView *)tableView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    UIButton *upBtn = [FMUtil createButtonWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) withTitle:@"立即登录，更多体验" withImageName:nil withSelImageName:nil withHigImageName:nil withTarget:self withAction:@selector(loginBtnClick)];
    upBtn.contentEdgeInsets = UIEdgeInsetsMake(40, 0, 0, 0);
    [view addSubview:upBtn];
    
    NSArray *titles = @[@"账号登录", @"QQ登录", @"微博登录"];
    NSArray *images = @[@"me_person", @"me_qq", @"me_weibo"];
    
    NSArray *selArray = @[@"accountLogin", @"qqLogin", @"weiboLogin"];
    
    CGFloat btnW = SCREEN_WIDTH/3;
    for(int i = 0; i < 3; i++)
    {
        UIButton *btn = [[LoginButton alloc]initWithFrame:CGRectMake(i*btnW, 80, btnW, 80)];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:NSSelectorFromString(selArray[i]) forControlEvents:UIControlEventTouchUpInside];
        
        if(i == 1 || i == 2)
        {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(btn.bounds.size.width*i, 110, 1, 30)];
            line.backgroundColor = [UIColor lightGrayColor];
            [view addSubview:line];
        }
        
        [view addSubview:btn];
    }
    
    return view;
}

-(void)loginBtnClick
{
    
}

//账号登录
-(void)accountLogin
{
    
}


//qq登录
-(void)qqLogin
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        }});
    
    //获取accestoken以及QQ用户信息，得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
    }];
    
    
}

//weibo登录
-(void)weiboLogin
{
    
}


-(void)FMTableView:(FMTableView *)tableView registerCellWithTableView:(UITableView *)tb
{
    [tb registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mineCellID"];
}


-(CGFloat)FMtableView:(FMTableView *)tableView highForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(CGFloat)FMtableView:(FMTableView *)tableView highForHeaderViewAtSection:(NSInteger)section
{
    return 15.0f;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
