//
//  FMUtil.m
//  AutoHome
//
//  Created by qianfeng on 15/5/13.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMUtil.h"

@interface FMButton : UIButton

@end

@implementation FMButton

-(void)setHighlighted:(BOOL)highlighted
{
    
}

@end


@implementation FMUtil

+(UIButton*)createButtonWithFrame:(CGRect)frame withTitle:(NSString*)title withImageName:(NSString*)imageName withSelImageName:(NSString*)selImageName withHigImageName:(NSString*)higImageName withTarget:(id)target withAction:(SEL)action
{
    UIButton *btn = nil;
    if(selImageName)
    {
        btn = [FMButton buttonWithType:UIButtonTypeCustom];
    }
    else
    {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    btn.frame = frame;
    
    if(imageName)
    {
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if(higImageName)
    {
        [btn setImage:[UIImage imageNamed:higImageName] forState:UIControlStateHighlighted];
    }
    if(selImageName)
    {
        [btn setImage:[UIImage imageNamed:selImageName] forState:UIControlStateSelected];
    }
    
    if(title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    if(target && action)
    {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }

    return btn;
}

+(UILabel*)createLabelWithFrame:(CGRect)frame withFont:(UIFont*)font withTextColor:(UIColor*)color withTitle:(NSString*)title;
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = title;
    label.font = font;
    label.textColor = color;
    return label;
}

@end





