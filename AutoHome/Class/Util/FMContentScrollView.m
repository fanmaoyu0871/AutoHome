//
//  FMContentScrollView.m
//  AutoHome
//
//  Created by qianfeng on 15/5/14.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMContentScrollView.h"

@implementation FMContentScrollView

-(instancetype)initWithFrame:(CGRect)frame withContentCount:(NSInteger)count
{
    if(self = [super initWithFrame:frame])
    {
        self.contentSize = CGSizeMake(SCREEN_WIDTH*count, 0);
        self.pagingEnabled = YES;
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
