//
//  MenuView.m
//  AutoHome
//
//  Created by qianfeng on 15/5/13.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "MenuView.h"
#import "FMNavView.h"
#import "FMCollectionView.h"
#import "ChannelManager.h"

@interface MenuView ()<FMCollectionViewDelegate>
{
    UIView *_bgView;
    FMNavView *_navView;
    FMCollectionView *_collectionView;
}

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation MenuView

-(NSMutableArray *)dataArray
{
    if(!_dataArray)
    {
        NSArray *array = [[ChannelManager sharedChannelManager] items];
        
        //由于userdefault中读出来的是不可变的,这里要转换成可变的
        
       // _dataArray = [array mutableCopy];
        _dataArray = [NSMutableArray array];
        for(NSArray *arr in array)
        {
            NSMutableArray *a = [NSMutableArray arrayWithArray:arr];
            [_dataArray addObject:a];
        }

    }
    
    return _dataArray;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7f];
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, -(SCREEN_HEIGHT-64)/2, SCREEN_WIDTH, (SCREEN_HEIGHT-64)/2)];
        _bgView.hidden = YES;
        [self addSubview:_bgView];
        [self createNav];
        [self createCollectionView];
        [self createUpButton];
        [self animate];
    }
    
    return self;
}

-(void)animate
{
    [UIView animateWithDuration:0.3f animations:^{
        _navView.scrollView.transform = CGAffineTransformMakeTranslation(_navView.scrollView.bounds.size.width, 0);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2f animations:^{
            [self bringSubviewToFront:_bgView];
            _bgView.hidden = NO;
            _bgView.frame = CGRectMake(0, 44, SCREEN_WIDTH, (SCREEN_HEIGHT-64)/2);
        }];
    }];
    
 
}

-(void)createNav
{
    _navView = [[FMNavView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44) withInset:90 withArray:@[@"全部频道"] withBtnFont:[UIFont systemFontOfSize:15]];
    CGRect svFrame = _navView.scrollView.frame;
    _navView.scrollView.frame = CGRectMake(-svFrame.size.width, svFrame.origin.y, svFrame.size.width, svFrame.size.height);
    [self addSubview:_navView];
    
    UIButton *finishBtn = [FMUtil createButtonWithFrame:CGRectMake(_navView.frame.size.width-40, 0, 40, _navView.frame.size.height) withTitle:@"完成" withImageName:nil withSelImageName:nil withHigImageName:nil withTarget:self withAction:@selector(finishAction)];
    [_navView addSubview:finishBtn];
}

-(void)finishAction
{
    
    [UIView animateWithDuration:0.2f animations:^{
        _bgView.frame = CGRectMake(0, -(SCREEN_HEIGHT-64)/2, SCREEN_WIDTH, (SCREEN_HEIGHT-64)/2);
        _bgView.hidden = NO;
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        [UIView animateWithDuration:0.4f animations:^{
            _navView.scrollView.transform = CGAffineTransformMakeTranslation(-_navView.scrollView.bounds.size.width, 0);
        } completion:^(BOOL finished) {
            if(self.hideTabBar)
            {
                self.hideTabBar(NO);
            }
            
            if(self.menuViewBlock)
            {
                self.menuViewBlock();
            }
            [_navView removeFromSuperview];
            [self removeFromSuperview];
        }];
    }];
    
  
    
}

-(void)createCollectionView
{
    CGSize itemSize = CGSizeMake((self.bounds.size.width - 35)/4, 40);
    _collectionView = [[FMCollectionView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, _bgView.bounds.size.height-44) withEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5) withLineSpace:10 withVerSpace:5 withItemSize:itemSize];
    _collectionView.delegate = self;
    [_collectionView registerCell];
    [_collectionView registerReuseView];
    [_collectionView reloadData];
    [_bgView addSubview:_collectionView];
}

-(void)createUpButton
{
    UIButton *btn = [FMUtil createButtonWithFrame:CGRectMake((_bgView.bounds.size.width-44)/2, CGRectGetMaxY(_collectionView.frame), 44, 44) withTitle:nil withImageName:@"ah_groupView_back" withSelImageName:nil withHigImageName:nil withTarget:self withAction:@selector(finishAction)];
    [_bgView addSubview:btn];
}


#pragma  mark - FMCollectionView协议方法

-(NSInteger)numberOfSections:(FMCollectionView *)collectionView
{
    return self.dataArray.count;
}

-(NSInteger)FMCollectionView:(FMCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

-(void)FMCollectionView:(FMCollectionView *)collectionView configCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.bounds];
    imageView.userInteractionEnabled = YES;
    cell.backgroundView = imageView;
    
    NSDictionary *dict = self.dataArray[indexPath.section][indexPath.item];
    NSString *title = dict[@"title"];
    
    UIButton *btn = [FMUtil createButtonWithFrame:cell.bounds withTitle:title withImageName:nil withSelImageName:nil withHigImageName:nil withTarget:nil withAction:nil];
    if(indexPath.section == 0  && indexPath.row == 0)
    {
        btn.userInteractionEnabled = YES;
    }
    else
    {
        imageView.image = [UIImage imageNamed:@"ah_gropView_item_bg"];
        [btn setBackgroundImage:[UIImage imageNamed:@"ad_bg"] forState:UIControlStateNormal];
         btn.userInteractionEnabled = NO;
    }
    [cell.contentView addSubview:btn];
}

-(void)FMCollectionView:(FMCollectionView *)collectionView configHeaderView:(UICollectionReusableView *)view atIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        UILabel *bigLabel = [FMUtil createLabelWithFrame:CGRectMake(0, 0, 80, 20) withFont:[UIFont systemFontOfSize:15] withTextColor:[UIColor blackColor] withTitle:@"  已选频道"];
        [view addSubview:bigLabel];
        
        UILabel *smallLabel = [FMUtil createLabelWithFrame:CGRectMake(90, 0, 200, 20) withFont:[UIFont systemFontOfSize:12] withTextColor:[UIColor lightGrayColor] withTitle:@"长按拖动排序/点击删除"];
        [view addSubview:smallLabel];
    }
    else if (indexPath.section == 1)
    {
        UILabel *bigLabel = [FMUtil createLabelWithFrame:CGRectMake(0, 0, 80, 20) withFont:[UIFont systemFontOfSize:15] withTextColor:[UIColor blackColor] withTitle:@"  待选频道"];
        [view addSubview:bigLabel];
        
        UILabel *smallLabel = [FMUtil createLabelWithFrame:CGRectMake(90, 0, 200, 20) withFont:[UIFont systemFontOfSize:12] withTextColor:[UIColor lightGrayColor] withTitle:@"点击添加"];
        [view addSubview:smallLabel];
    }
}

-(void)FMCollectionView:(FMCollectionView *)collectionView configFooterView:(UICollectionReusableView *)view atIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)FMCollectionView:(FMCollectionView *)collectionView withCV:(UICollectionView *)oriCV didSelectedCellAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionView *cv = oriCV;
    [cv performBatchUpdates:^{
        
        //delete之前先保存数据
        id object = self.dataArray[indexPath.section][indexPath.item];
        
        //delete data
        [self.dataArray[indexPath.section] removeObjectAtIndex:indexPath.item];
        
        if(indexPath.section == 0)
        {
            //insert data
            NSInteger count = [self.dataArray[1] count];
            [self.dataArray[1] addObject:object];
            
            //保存用户数据
            [[ChannelManager sharedChannelManager]saveItems:self.dataArray withKey:ITEMS];
            
            //move cell
            [cv moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:count  inSection:1]];
            
        }
        else if(indexPath.section == 1)
        {
            //insert data
            NSInteger count = [self.dataArray[0] count];
            [self.dataArray[0] addObject:object];
            
            //保存用户数据
           [[ChannelManager sharedChannelManager]saveItems:self.dataArray withKey:ITEMS];
            
            //move cell
            [cv moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:count  inSection:0]];
            
        }
        

        
    } completion:^(BOOL finished) {
        [cv reloadData];
    }];

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
