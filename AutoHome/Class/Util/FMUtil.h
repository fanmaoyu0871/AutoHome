//
//  FMUtil.h
//  AutoHome
//
//  Created by qianfeng on 15/5/13.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FMUtil : NSObject


+(UIButton*)createButtonWithFrame:(CGRect)frame withTitle:(NSString*)title withImageName:(NSString*)imageName withSelImageName:(NSString*)selImageName withHigImageName:(NSString*)higImageName withTarget:(id)target withAction:(SEL)action;

+(UILabel*)createLabelWithFrame:(CGRect)frame withFont:(UIFont*)font withTextColor:(UIColor*)color withTitle:(NSString*)title;

@end
