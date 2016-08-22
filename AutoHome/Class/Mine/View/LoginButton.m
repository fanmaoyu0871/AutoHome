//
//  LoginButton.m
//  AutoHome
//
//  Created by 范茂羽 on 15/5/21.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "LoginButton.h"

@implementation LoginButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 60, contentRect.size.width, 20);
}


-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
      return CGRectMake(contentRect.size.width/2-20, 20, 40, 40);
}

@end
