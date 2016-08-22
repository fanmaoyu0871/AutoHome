//
//  FMSliderView.h
//  AutoHome
//
//  Created by qianfeng on 15/5/15.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMTableView;

@interface FMSliderView : UIView


-(instancetype)initWithFrame:(CGRect)frame withRightViewFrame:(CGRect)rightViewFrame withNavTitle:(NSString*)title;

-(void)addTableView:(UITableView*)tableView;

-(void)leftSlideView;

-(void)rightSlideView;

@end
