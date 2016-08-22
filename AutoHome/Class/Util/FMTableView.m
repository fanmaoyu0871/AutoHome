//
//  FMTableView.m
//  AutoHome
//
//  Created by qianfeng on 15/5/15.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMTableView.h"


@interface FMTableView ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
  //  UITableView *_tableView;
    BOOL _isXib;
}
@end

@implementation FMTableView

-(instancetype)initWithFrame:(CGRect)frame withStyle:(UITableViewStyle)style isLoadXib:(BOOL)isXib
{
    if(self = [super initWithFrame:frame])
    {
        [self createTabelViewStyle:style];
        _isXib = isXib;
    }
    
    return self;
}

-(void)createTabelViewStyle:(UITableViewStyle)style
{
    _tableView = [[UITableView alloc]initWithFrame:self.bounds style:style];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self addSubview:_tableView];
    
}



-(void)reloadData
{
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(headerViewInFMtableView:)])
        {
            _tableView.tableHeaderView = [self.delegate headerViewInFMtableView:self];
        }
    }
    [_tableView reloadData];
}


#pragma mark - tableView协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger num = 0;
    if(self.delegate)
    {
        num = [self.delegate numberOfSections:self];
    }
    
    return num;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    if(self.delegate)
    {
        num = [self.delegate FMTableView:self numberOfRowsAtSection:section];
    }
    
    return num;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(FMTableView:registerCellWithTableView:)])
        {
            [self.delegate FMTableView:self registerCellWithTableView:_tableView];
        }
    }
    
    if(self.delegate)
    {
        
        cell = [self.delegate FMTableView:self withTableView:_tableView atIndexPath:indexPath];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(FMTableView:didSelectedAtIndexPath:)])
        {
            [self.delegate FMTableView:self didSelectedAtIndexPath:indexPath];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h;
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(FMtableView:highForCellAtIndexPath:)])
        {
           h = [self.delegate FMtableView:self highForCellAtIndexPath:indexPath];
        }
    }
    
    return h;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *str = nil;
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(FMTableView:titleForHeaderAtSection:)])
        {
            str = [self.delegate FMTableView:self titleForHeaderAtSection:section];
        }
    }
    
    return str;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = nil;
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(FMtableView:headerViewAtSection:)])
        {
            view =  [self.delegate FMtableView:self headerViewAtSection:section];
        }
    }
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat h = 0;
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(FMtableView:highForHeaderViewAtSection:)])
        {
            h =  [self.delegate FMtableView:self highForHeaderViewAtSection:section];
        }
    }
    
    return h;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(FMTableView:didScroll:)])
        {
            [self.delegate FMTableView:self didScroll:_tableView];
        }
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(FMTableView:didEndDraging:)])
        {
            [self.delegate FMTableView:self didEndDraging:_tableView];
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
