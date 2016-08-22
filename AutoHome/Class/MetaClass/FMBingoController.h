//
//  FMBingoController.h
//  AutoHome
//
//  Created by qianfeng on 15/5/15.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMBaseController.h"
#import "FMTableView.h"

@interface FMBingoController : FMBaseController
{
    UILabel *_titleLabel;
    FMTableView *_tableView;
}

@property (nonatomic, copy)void (^closeBtnBlock)();
//导航栏上的标题
@property (nonatomic, copy)NSString *navTitle;

@property (nonatomic, copy)NSArray *dataArray;

-(void)createNav;

-(void)leftSlide;

-(void)rightSlide;

-(void)reloadData;

@end
