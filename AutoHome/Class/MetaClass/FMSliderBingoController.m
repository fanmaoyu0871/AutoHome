//
//  FMSliderBingoController.m
//  AutoHome
//
//  Created by qianfeng on 15/5/18.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMSliderBingoController.h"
#import "FMTableView.h"

@interface FMSliderBingoController ()<FMTableViewDelegate>
{
    FMTableView *_tableView;
}
@end

@implementation FMSliderBingoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNav];
    [self createTabelView];
    [self reloadData];
}

-(void)createNav
{
    _titleLabel = [FMUtil createLabelWithFrame:self.navBar.bounds withFont:[UIFont systemFontOfSize:15] withTextColor:[UIColor blackColor] withTitle:nil];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navBar addSubview:_titleLabel];
    
    UIButton *closeBtn = [FMUtil createButtonWithFrame:CGRectMake(self.navBar.bounds.size.width-45, 0, 40, self.navBar.bounds.size.height) withTitle:@"关闭" withImageName:nil withSelImageName:nil withHigImageName:nil withTarget:self withAction:@selector(closeBtnClick)];
    [closeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.navBar addSubview:closeBtn];
}

-(void)closeBtnClick
{
    [self rightSlide];
    if(self.closeBtnBlock)
    {
        self.closeBtnBlock();
    }
}

-(void)createTabelView
{
    _tableView = [[FMTableView alloc]initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height) withStyle:UITableViewStyleGrouped isLoadXib:NO];
    _tableView.backgroundColor = [UIColor blueColor];
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}


-(NSInteger)numberOfSections:(FMTableView *)tableView
{
    return 1;
}

-(NSInteger)FMTableView:(FMTableView *)tableView numberOfRowsAtSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(void)FMTableView:(FMTableView *)tableView registerCellWithTableView:(UITableView *)tb
{
    [tb registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    
}

-(UITableViewCell*)FMTableView:(FMTableView *)tableView withTableView:(UITableView *)tb atIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [tb dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    cell.accessoryView = nil;
    
    if(indexPath.row == self.selectedIndex)
    {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 25)];
        imgView.image = [UIImage imageNamed:@"forms_icon_select"];
        cell.accessoryView = imgView;
    }
    
    return cell;
}


-(CGFloat)FMtableView:(FMTableView *)tableView highForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(void)FMTableView:(FMTableView *)tableView didSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    //进行网络请求
    
    self.selectedIndex = indexPath.row;
    [tableView reloadData];
    
    if(self.selectCellBlock)
    {
        self.selectCellBlock(indexPath.row);
    }
    
}

-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    [_tableView reloadData];
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