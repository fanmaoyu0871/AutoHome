//
//  FMLabel.m
//  AutoHome
//
//  Created by 范茂羽 on 15/5/20.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMLabel.h"

@implementation FMLabel

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

    [self.text drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
}


@end
