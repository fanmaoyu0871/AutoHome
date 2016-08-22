//
//  FMSearchController.m
//  AutoHome
//
//  Created by qianfeng on 15/5/14.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMSearchController.h"
#import "FMRectButton.h"
#import "FMTextField.h"

@interface FMSearchController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    FMTextField *_tf;
    UITableView *_tableView;
}

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation FMSearchController

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
    [self createNav];
    [self createTableView];
    
    self.navBar.frame = CGRectMake(0, -64, SCREEN_WIDTH, 64);
    [UIView animateWithDuration:0.1f animations:^{
        self.navBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        [_tf becomeFirstResponder];
    } completion:^(BOOL finished) {
    }];
}

-(void)createNav
{
    _tf = [[FMTextField alloc]initWithFrame:CGRectMake(10, 32, SCREEN_WIDTH-10-60, 20)];
    _tf.backgroundColor = [UIColor lightGrayColor];
    _tf.borderStyle = UITextBorderStyleRoundedRect;
    _tf.placeholder = @"搜索关键词";
    _tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.navBar addSubview:_tf];
    
    UIView *blowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 20)];
    blowView.backgroundColor = [UIColor clearColor];
    
    FMRectButton *btn = [[FMRectButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    [btn setTitle:@"综合" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"search_button_triangle"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.imageView.contentMode = UIViewContentModeCenter;
    [blowView addSubview:btn];
    
    //分割线
    UIView *spView = [[UIView alloc]initWithFrame:CGRectMake(50, 0, 1, 20)];
    spView.backgroundColor = [UIColor grayColor];
    [blowView addSubview:spView];
    
    //image
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(52, 3, 15, 15)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = [UIImage imageNamed:@"searchBar_search"];
    [blowView addSubview:imageView];
    
    _tf.leftView = blowView;
    _tf.leftViewMode = UITextFieldViewModeAlways;
    _tf.returnKeyType = UIReturnKeySearch;
   [ _tf addTarget:self action:@selector(tfEndAction) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    //取消按钮
    UIButton *cancelBtn = [FMUtil createButtonWithFrame:CGRectMake(CGRectGetMaxX(_tf.frame), 32, 60, 20) withTitle:@"取消" withImageName:nil withSelImageName:nil withHigImageName:nil withTarget:self withAction:@selector(cancelClick)];
    [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.navBar addSubview:cancelBtn];
    
}

-(void)tfEndAction
{
    
}

-(void)btnClick
{
    
}

-(void)cancelClick
{
    [UIView animateWithDuration:0.2f animations:^{
        self.navBar.frame = CGRectMake(0, -64, SCREEN_WIDTH, 64);
        [_tf resignFirstResponder];
    } completion:^(BOOL finished) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
}


-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

#pragma mark - tableView协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.dataArray.count;
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, cell.bounds.size.height)]; 
    label.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20, 11, 10, 10)];
    imageView.image = [UIImage imageNamed:@"search_buton_arrowhead_white"];
    [cell.contentView addSubview:imageView];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor lightGrayColor];
    UILabel *label = [FMUtil createLabelWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-50, view.bounds.size.height) withFont:[UIFont systemFontOfSize:12] withTextColor:[UIColor grayColor] withTitle:@"搜索历史"];
    [view addSubview:label];
    
    UIButton *clearBtn = [FMUtil createButtonWithFrame:CGRectMake(SCREEN_WIDTH-30, 0, 30, 30) withTitle:nil withImageName:@"searchBar_delete" withSelImageName:nil withHigImageName:nil withTarget:self withAction:@selector(clearBtnClick)];
    [view addSubview:clearBtn];
    
    return view;
}

-(void)clearBtnClick
{
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_tf resignFirstResponder];
}

#pragma mark - textField协议方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
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
