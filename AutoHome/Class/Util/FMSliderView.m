//
//  FMSliderView.m
//  AutoHome
//
//  Created by qianfeng on 15/5/15.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMSliderView.h"
#import "FMTableView.h"

@interface FMSliderView ()
{
    UILabel *_titleLabel;
    UIView *_rightView;
    
    NSString *_title;
}

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation FMSliderView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame withRightViewFrame:(CGRect)rightViewFrame withNavTitle:(NSString*)title
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
        
        //导航栏标题
        _title = title;
        
        //创建右半边视图
        _rightView = [[UIView alloc]initWithFrame:rightViewFrame];
        _rightView.backgroundColor = [UIColor clearColor];
        [self addSubview:_rightView];
        
        //创建右半边视图的导航
        [self createSliderNav];
        
        //创建左半边
        UIView *tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.bounds.size.width-rightViewFrame.size.width, _rightView.bounds.size.height)];
        tapView.backgroundColor = [UIColor clearColor];
        [self addSubview:tapView];
        
        //左半边视图加一个点击手势
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes)];
        [tapView addGestureRecognizer:tapGes];
        
    }
    
    return self;
}

-(void)tapGes
{
    [self rightSlideView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, USEC_PER_SEC*500), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

-(void)addTableView:(UITableView*)tableView
{
    [_rightView addSubview:tableView];
    [_rightView bringSubviewToFront:tableView];
}



//创建侧滑视图导航栏
-(void)createSliderNav
{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _rightView.bounds.size.width, 44)];
    navView.backgroundColor = [UIColor whiteColor];
    [_rightView addSubview:navView];
    
    _titleLabel = [FMUtil createLabelWithFrame:navView.bounds withFont:[UIFont systemFontOfSize:15] withTextColor:[UIColor blackColor] withTitle:nil];
    _titleLabel.text = _title;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:_titleLabel];
    
    UIButton *closeBtn = [FMUtil createButtonWithFrame:CGRectMake(navView.bounds.size.width-45, 0, 40, navView.bounds.size.height) withTitle:@"关闭" withImageName:nil withSelImageName:nil withHigImageName:nil withTarget:self withAction:@selector(closeBtnClick)];
    [closeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [navView addSubview:closeBtn];
}

-(void)closeBtnClick
{
    [self tapGes];
}

-(void)leftSlideView
{
    __block CGRect frame = _rightView.frame;
    
    [UIView animateWithDuration:0.3f animations:^{
        frame.origin.x = self.bounds.size.width - _rightView.bounds.size.width;
        _rightView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)rightSlideView
{
    __block CGRect frame = _rightView.frame;
    
    [UIView animateWithDuration:0.3f animations:^{
        frame.origin.x = self.bounds.size.width;
        _rightView.frame = frame;
    } completion:^(BOOL finished) {
        [_rightView removeFromSuperview];
    }];
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
