//
//  FMTabBar.m
//  AutoHome
//
//  Created by qianfeng on 15/5/13.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMTabBar.h"

@implementation FMTabBar
{
    UIButton *_preBtn;
}

-(instancetype)initWithFrame:(CGRect)frame withImageArray:(NSArray *)imageArray withSelImageArray:(NSArray *)selImageArray

{
    if(self = [super initWithFrame:frame])
    {
        CGFloat btnW = frame.size.width/imageArray.count;
        CGFloat btnH = frame.size.height;
        
        for(int i = 0; i < imageArray.count; i++)
        {
            UIButton *btn = [FMUtil createButtonWithFrame:CGRectMake(i*btnW, 0, btnW, btnH) withTitle:nil withImageName:imageArray[i] withSelImageName:selImageArray[i] withHigImageName:nil withTarget:self withAction:@selector(action:)];
            btn.tag = 100+i;
            [self addSubview:btn];
            
            if(i == 0)
            {
                btn.selected = YES;
                _preBtn = btn;
            }
        }
    }
    
    return self;
}


-(void)action:(UIButton*)btn
{
    _preBtn.selected = NO;
    
    btn.selected = YES;
    
    _preBtn = btn;
    
    NSInteger index = btn.tag - 100;
    
    if(self.selectedBlock)
    {
        self.selectedBlock(index);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
