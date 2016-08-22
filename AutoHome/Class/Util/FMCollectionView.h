//
//  FMCollectionView.h
//  AutoHome
//
//  Created by qianfeng on 15/5/13.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMCollectionView;

@protocol FMCollectionViewDelegate <NSObject>

@optional
-(NSInteger)numberOfSections:(FMCollectionView*)collectionView;

-(void)FMCollectionView:(FMCollectionView *)collectionView configHeaderView:(UICollectionReusableView*)view atIndexPath:(NSIndexPath*)indexPath;

-(void)FMCollectionView:(FMCollectionView *)collectionView configFooterView:(UICollectionReusableView*)view atIndexPath:(NSIndexPath*)indexPath;

-(void)FMCollectionView:(FMCollectionView *)collectionView withCV:(UICollectionView*)oriCV didSelectedCellAtIndexPath:(NSIndexPath*)indexPath;

@required
-(NSInteger)FMCollectionView:(FMCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

-(void)FMCollectionView:(FMCollectionView *)collectionView configCell:(UICollectionViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;

@end


@interface FMCollectionView : UIView

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, weak)id<FMCollectionViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame withEdgeInsets:(UIEdgeInsets)edgeInsets withLineSpace:(CGFloat)lineSpace withVerSpace:(CGFloat)verSpace withItemSize:(CGSize)itemSize;

-(void)registerCell;
-(void)registerCellWithXibName:(NSString*)xibName;

-(void)registerReuseView;

-(void)reloadData;


@end
