//
//  FMBrandSliderController.m
//  AutoHome
//
//  Created by qianfeng on 15/5/18.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMBrandSliderController.h"
#import "SelectedBrandModel.h"
#import "SliderBrandCell.h"

@interface FMBrandSliderController ()<FMTableViewDelegate>

@end

@implementation FMBrandSliderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNav];
    [self createTabelView];
    
    [FMProgressHUD showOnView:self.view];

    [self reloadData];
}

-(void)createNav
{
    
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc]initWithFrame:CGRectMake(10, 7, 180, 30)];
    [segCtrl insertSegmentWithTitle:@"在售" atIndex:0 animated:NO];
    [segCtrl insertSegmentWithTitle:@"全部" atIndex:1 animated:NO];
    segCtrl.selectedSegmentIndex = 0;
    [segCtrl addTarget:self action:@selector(segCtrlValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.navBar addSubview:segCtrl];

    UIButton *closeBtn = [FMUtil createButtonWithFrame:CGRectMake(self.navBar.bounds.size.width-45, 0, 40, self.navBar.bounds.size.height) withTitle:@"关闭" withImageName:nil withSelImageName:nil withHigImageName:nil withTarget:self withAction:@selector(closeBtnClick)];
    [closeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.navBar addSubview:closeBtn];
}

-(void)segCtrlValueChange:(UISegmentedControl*)seg
{
    if(self.segCtrlValueChange)
    {
        self.segCtrlValueChange(seg.selectedSegmentIndex);
    }
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
    [tb registerNib:[UINib nibWithNibName:@"SliderBrandCell" bundle:nil] forCellReuseIdentifier:@"categoryCellID"];
}

-(UITableViewCell*)FMTableView:(FMTableView *)tableView withTableView:(UITableView *)tb atIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [tb dequeueReusableCellWithIdentifier:@"categoryCellID"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"categoryCellID"];
    }
    
    SelectedBrandModel *model = self.dataArray[indexPath.row];
    SliderBrandCell *selCell = (SliderBrandCell*)cell;
    [selCell config:model];
    
    return selCell;
}


-(CGFloat)FMtableView:(FMTableView *)tableView highForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(void)FMTableView:(FMTableView *)tableView didSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    //进行网络请求
    
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
