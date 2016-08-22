//
//  FMForumController.m
//  AutoHome
//
//  Created by qianfeng on 15/5/14.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMForumController.h"
#import "FMTableView.h"

@interface FMForumController ()<FMTableViewDelegate>
{
    FMTableView *_tableView;
}
@end

@implementation FMForumController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createTableView];
    
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)createTableView
{
    _tableView = [[FMTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) withStyle:UITableViewStylePlain isLoadXib:NO];
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark -FMTableViewDelegate协议方法
-(NSInteger)numberOfSections:(FMTableView *)tableView
{
    return 1;
}

-(NSInteger)FMTableView:(FMTableView *)tableView numberOfRowsAtSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell*)FMTableView:(FMTableView*)tableView withTableView:(UITableView*)tb atIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tb dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    
    return cell;
}

-(void)FMTableView:(FMTableView *)tableView registerCellWithTableView:(UITableView *)tb
{
    [tb registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
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
