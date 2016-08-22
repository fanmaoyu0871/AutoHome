//
//  FMTabBar.h
//  AutoHome
//
//  Created by qianfeng on 15/5/13.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMTabBar : UIView

@property (nonatomic, copy)void (^selectedBlock)(NSInteger index);

-(instancetype)initWithFrame:(CGRect)frame withImageArray:(NSArray*)imageArray withSelImageArray:(NSArray*)selImageArray;


@end
