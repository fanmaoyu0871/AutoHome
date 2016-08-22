//
//  FMNavView.m
//  AutoHome
//
//  Created by qianfeng on 15/5/13.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMNavView.h"

#define SPACE 10

@implementation FMNavView
{
    UIImageView *_rShadowView;
    UILabel *_lineView;
    
    //上一个被点击的按钮
    UIButton *_preBtn;
}

-(instancetype)initWithFrame:(CGRect)frame withInset:(CGFloat)inset withArray:(NSArray*)array withBtnFont:(UIFont*)font
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self createScrollViewWithInset:inset];
        [self createOtherView];
        
        [self reloadButton:array withTitleFont:font];
    }
    
    return self;
}

-(void)createScrollViewWithInset:(CGFloat)inset
{
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width-inset, self.bounds.size.height-1)];
    sv.showsHorizontalScrollIndicator = NO;
    sv.delegate = self;
    [self addSubview:sv];
    self.scrollView = sv;
}

-(void)reloadButton:(NSArray*)btnArray withTitleFont:(UIFont*)font;
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat btnX = SPACE;
    CGFloat btnW = 0.0f;
    CGFloat btnH = self.bounds.size.height-5;
    for(int i = 0; i < btnArray.count; i++)
    {
        btnX += btnW;
        btnW = [btnArray[i] length]*20.0f;
        
        UIButton *btn = [FMUtil createButtonWithFrame:CGRectMake(btnX, 0, btnW, btnH) withTitle:btnArray[i] withImageName:nil withSelImageName:nil withHigImageName:nil withTarget:self withAction:@selector(changeBtn:)];
        btn.titleLabel.font = font;
        btn.tag = 100+i;
        [self.scrollView addSubview:btn];
        if(i == 0)
        {
            //创建线条
            _lineView = [[UILabel alloc]initWithFrame:CGRectMake(SPACE, CGRectGetMaxY(self.scrollView.frame)-SPACE, btn.frame.size.width, 5)];
            _lineView.backgroundColor = [UIColor blueColor];
            [self.scrollView addSubview:_lineView];
            
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            _preBtn = btn;
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(btnX+btnW+5, 0);
    if(self.scrollView.contentSize.width> self.scrollView.bounds.size.width)
    {
        _rShadowView.hidden = NO;
    }
    self.scrollView.contentOffset = CGPointZero;
    
}

#pragma mark - changeBtn
-(void)changeBtn:(UIButton*)btn
{
    NSInteger index = btn.tag - 100;
    if(self.channelChangeBlock)
    {
        if(btn != _preBtn)
        {
            [_preBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _preBtn = btn;
        }
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.channelChangeBlock(index);
        [UIView animateWithDuration:0.2f animations:^{
            CGRect lineFrame = _lineView.frame;
            lineFrame.size.width = 20.0f * [btn.currentTitle length];
            lineFrame.origin.x = btn.frame.origin.x;
            _lineView.frame = lineFrame;
        }];
        
        [self.scrollView scrollRectToVisible:CGRectMake(btn.bounds.size.width*index, 0, self.scrollView.frame.size.width, self.scrollView.bounds.size.height) animated:YES];
    }
}

-(void)createOtherView
{
    //创建阴影
    _rShadowView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.scrollView.frame)+1, 0, 5, self.scrollView.bounds.size.height)];
    _rShadowView.image = [UIImage imageNamed:@"bar_bg_mask_right"];
    [self addSubview:_rShadowView];
    _rShadowView.hidden = YES;
}

-(void)reloadLineViewAtIndex:(NSInteger)index
{
    UIButton *btn = (UIButton*)[self viewWithTag:100+index];
    [self changeBtn:btn];
}

-(void)hideScrollLine
{
    [_lineView setHidden:YES];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
