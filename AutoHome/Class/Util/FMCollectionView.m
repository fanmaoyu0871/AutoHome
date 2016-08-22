//
//  FMCollectionView.m
//  AutoHome
//
//  Created by qianfeng on 15/5/13.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMCollectionView.h"

@interface FMCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
}
@end

@implementation FMCollectionView


-(instancetype)initWithFrame:(CGRect)frame withEdgeInsets:(UIEdgeInsets)edgeInsets withLineSpace:(CGFloat)lineSpace withVerSpace:(CGFloat)verSpace withItemSize:(CGSize)itemSize
{
    if(self = [super initWithFrame:frame])
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = lineSpace;
        layout.minimumInteritemSpacing = verSpace;
        layout.sectionInset = edgeInsets;
        layout.itemSize = itemSize;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_collectionView];
    }
    
    return self;
}


#pragma  mark - 协议方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger sections = 0;
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(numberOfSections:)])
        {
            sections =  [self.delegate numberOfSections:self];
        }
    }
    
    return sections;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger items = 0;
    if(self.delegate)
    {
        items = [self.delegate FMCollectionView:self numberOfItemsInSection:section];
    }
    
    return items;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if(self.delegate)
    {
        [self.delegate FMCollectionView:self configCell:cell atIndexPath:indexPath];
    }
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *reuseView = nil;
    if(kind == UICollectionElementKindSectionHeader)
    {
        reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerViewID" forIndexPath:indexPath];
        
        [reuseView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if(self.delegate)
        {
            [self.delegate FMCollectionView:self configHeaderView:reuseView atIndexPath:indexPath];
        }
        
    }
    else if(kind == UICollectionElementKindSectionFooter)
    {
        reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerViewID" forIndexPath:indexPath];
        
        [reuseView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if(self.delegate)
        {
            [self.delegate FMCollectionView:self configFooterView:reuseView atIndexPath:indexPath];
        }
    }

    
    return reuseView;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.bounds.size.width,20);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
     return CGSizeMake(self.bounds.size.width,20);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate)
    {
        
        if([self.delegate respondsToSelector:@selector(FMCollectionView:withCV:didSelectedCellAtIndexPath:)])
        {
            [self.delegate FMCollectionView:self withCV:_collectionView didSelectedCellAtIndexPath:indexPath];
        }
    }
}


#pragma  mark - 提供的接口
-(void)registerCell
{
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
}

-(void)registerCellWithXibName:(NSString*)xibName
{
    [_collectionView registerNib:[UINib nibWithNibName:xibName bundle:nil] forCellWithReuseIdentifier:@"cellID"];
}

-(void)registerReuseView
{
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerViewID"];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerViewID"];
}

-(void)reloadData
{
    [_collectionView reloadData];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
