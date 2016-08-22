//
//  FMButton.m
//  AutoHome
//
//  Created by qianfeng on 15/5/14.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMRectButton.h"

@implementation FMRectButton

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(10, 0, 40, 20);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(40, (contentRect.size.height-5)/2, 5, 5);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
