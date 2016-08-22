//
//  FMChooseButton.m
//  AutoHome
//
//  Created by qianfeng on 15/5/18.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMChooseButton.h"

@implementation FMChooseButton

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width-20, 15, 14, 14);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    return CGRectMake(20, 12, contentRect.size.width-20, 20);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
