//
//  FMNavView.h
//  AutoHome
//
//  Created by qianfeng on 15/5/13.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMNavView : UIView<UIScrollViewDelegate>

@property (nonatomic, weak)UIScrollView *scrollView;

@property (nonatomic, copy)void (^channelChangeBlock)(NSInteger index);

-(instancetype)initWithFrame:(CGRect)frame withInset:(CGFloat)inset withArray:(NSArray*)array withBtnFont:(UIFont*)font;

-(void)hideScrollLine;

-(void)reloadButton:(NSArray*)btnArray withTitleFont:(UIFont*)font;

-(void)reloadLineViewAtIndex:(NSInteger)index;

@end
