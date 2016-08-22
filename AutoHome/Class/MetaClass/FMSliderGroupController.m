//
//  FMSliderGroupController.m
//  AutoHome
//
//  Created by qianfeng on 15/5/18.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMSliderGroupController.h"
#import "FMTableView.h"
#import "AFHTTPRequestOperationManager.h"
#import "BrandModel.h"

@interface FMSliderGroupController ()<FMTableViewDelegate>



@end

@implementation FMSliderGroupController

-(NSMutableArray *)letterArray
{
    if(_letterArray == nil)
    {
        _letterArray = [NSMutableArray array];
    }
    
    return _letterArray;
}

-(NSMutableArray *)brandArray
{
    if(_brandArray == nil)
    {
        _brandArray = [NSMutableArray array];
    }
    
    return _brandArray;
}

-(NSMutableArray *)resultArray
{
    if(_resultArray == nil)
    {
        _resultArray = [NSMutableArray array];
    }
    
    return _resultArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNav];
//    [self createTabelView];
//    [self reloadData];
    [self downloadData];
}

-(void)createTabelView
{
    _tableView = [[FMTableView alloc]initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height) withStyle:UITableViewStylePlain isLoadXib:NO];
    _tableView.backgroundColor = [UIColor blueColor];
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
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
            NSDictionary *resultDict =dict[@"result"];
            NSArray *letterArray = resultDict[@"brandlist"];
            for(NSDictionary *letDict in letterArray)
            {
                [self.letterArray addObject:letDict[@"letter"]];
                NSMutableArray *array = [NSMutableArray array];
                for(NSDictionary *brandDict in letDict[@"list"])
                {
                    BrandModel *model = [[BrandModel alloc]init];
                    model.Id = brandDict[@"id"];
                    model.name = brandDict[@"name"];
                    model.imgurl = brandDict[@"imgurl"];
                    [model setValuesForKeysWithDictionary:brandDict];
                    [array addObject:model];
                }
                
                [self.brandArray addObject:array];
            }
        }
        
        //加载完数据在创建tableview，在不然没法玩
        [self createTabelView];
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@", error);
    }];

}


-(void)createNav
{
    _titleLabel = [FMUtil createLabelWithFrame:self.navBar.bounds withFont:[UIFont systemFontOfSize:15] withTextColor:[UIColor blackColor] withTitle:self.navTitle];
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


#pragma  mark - FMTableView协议方法
-(NSInteger)numberOfSections:(FMTableView *)tableView
{
    return self.letterArray.count+1;
}

-(NSInteger)FMTableView:(FMTableView *)tableView numberOfRowsAtSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else
    {
        return [self.brandArray[section-1] count];
    }
}

-(UITableViewCell *)FMTableView:(FMTableView *)tableView withTableView:(UITableView *)tb atIndexPath:(NSIndexPath *)indexPath
{
   
    UITableViewCell *cell =  [tb dequeueReusableCellWithIdentifier:@"brandCellID" forIndexPath:indexPath];
    
    
    if(indexPath.section == 0)
    {
       cell.textLabel.text = @"不限";
    }
    else
    {
        BrandModel *model = self.brandArray[indexPath.section-1][indexPath.row];
        cell.textLabel.text = model.name;
    }
    
    cell.accessoryView = nil;
    
    if(indexPath.section == self.selectedIndexPath.section)
    {
        if(indexPath.row == self.selectedIndexPath.row)
        {
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 25)];
            imgView.image = [UIImage imageNamed:@"forms_icon_select"];
            cell.accessoryView = imgView;
        }
    }
    
    return cell;
}

-(void)FMTableView:(FMTableView *)tableView registerCellWithTableView:(UITableView *)tb
{
    [tb registerClass:[UITableViewCell class] forCellReuseIdentifier:@"brandCellID"];
}


-(CGFloat)FMtableView:(FMTableView *)tableView highForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(NSString*)FMTableView:(FMTableView *)tableView titleForHeaderAtSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"";
    }
    else
    {
        return self.letterArray[section-1];
    }
}


-(CGFloat)FMtableView:(FMTableView *)tableView highForHeaderViewAtSection:(NSInteger)section
{
    if(section == 0)
    {
        return 40;
    }
    return 20;
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
