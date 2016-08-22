//
//  FMTableView.h
//  AutoHome
//
//  Created by qianfeng on 15/5/15.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMTableView;

@protocol FMTableViewDelegate <NSObject>

@required
-(NSInteger)FMTableView:(FMTableView*)tableView numberOfRowsAtSection:(NSInteger)section;


-(UITableViewCell*)FMTableView:(FMTableView*)tableView withTableView:(UITableView*)tb atIndexPath:(NSIndexPath*)indexPath;

@optional
-(NSInteger)numberOfSections:(FMTableView*)tableView;
-(void)FMTableView:(FMTableView*)tableView didSelectedAtIndexPath:(NSIndexPath*)indexPath;

-(CGFloat)FMtableView:(FMTableView*)tableView highForCellAtIndexPath:(NSIndexPath*)indexPath;

-(CGFloat)FMtableView:(FMTableView*)tableView highForHeaderViewAtSection:(NSInteger)section;

//headerView for section
-(UIView*)FMtableView:(FMTableView*)tableView headerViewAtSection:(NSInteger)section;


//headerView for tableHeaderView
-(UIView*)headerViewInFMtableView:(FMTableView*)tableView;


//register
-(void)FMTableView:(FMTableView *)tableView registerCellWithTableView:(UITableView*)tb;

-(NSString*)FMTableView:(FMTableView*)tableView titleForHeaderAtSection:(NSInteger)section;


//scrollview
-(void)FMTableView:(FMTableView *)tableView didScroll:(UITableView*)tb;

-(void)FMTableView:(FMTableView *)tableView didEndDraging:(UITableView*)tb;

@end

@interface FMTableView : UIView

@property (nonatomic, weak)id<FMTableViewDelegate> delegate;

@property (nonatomic ,copy)NSString *navTitle;

@property (nonatomic, strong)UITableView *tableView;


-(instancetype)initWithFrame:(CGRect)frame withStyle:(UITableViewStyle)style isLoadXib:(BOOL)isXib;


-(void)reloadData;

@end
