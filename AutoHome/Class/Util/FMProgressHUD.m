//
//  FMProgressHUD.m
//  AutoHome
//
//  Created by qianfeng on 15/5/19.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMProgressHUD.h"

#define HUD_TAG 999


@implementation FMProgressHUD
{
    UIView *_loadView;
    UIImageView *_animateImageView;
    UILabel *_alterLabel;
    NSTimer *_timer;
    void (^_tapBlcok)();
}

-(instancetype)initWithFrame:(CGRect)frame withBlock:(void(^)())block
{
    if(self = [super initWithFrame:frame])
    {
        _loadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 99, 99)];
        
        _tapBlcok = block;
        
        //加一个点击手势
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [_loadView addGestureRecognizer:tapGes];
        
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 79, 79)];
        bgImageView.image = [UIImage imageNamed:@"loadingpage_bg"];
        [_loadView addSubview:bgImageView];
        
        _animateImageView = [[UIImageView alloc]initWithFrame:bgImageView.frame];
        _animateImageView.image = [UIImage imageNamed:@"load_icon"];
        _animateImageView.userInteractionEnabled = YES;
        [_loadView addSubview:_animateImageView];
        
        _alterLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 79, _loadView.bounds.size.width, 20)];
        _alterLabel.text = @"点击重新加载";
        _alterLabel.textColor = [UIColor lightGrayColor];
        _alterLabel.font = [UIFont systemFontOfSize:15];
        _alterLabel.hidden = YES;
        [_loadView addSubview:_alterLabel];
        
        [self addSubview:_loadView];
    }
    
    return self;
}

-(void)tapAction
{
    [_timer setFireDate:[NSDate distantPast]];
    _animateImageView.hidden = NO;
    _alterLabel.hidden = YES;
     _loadView.userInteractionEnabled = NO;
    
    _tapBlcok();
    
}

-(void)layoutSubviews
{
//    _loadView.center = self.center;
    _loadView.center = CGPointMake(self.center.x, self.center.y-50);
    _alterLabel.frame = CGRectMake(0, _loadView.bounds.size.height-20, _loadView.bounds.size.width, 20);
}

-(void)rotateAction
{
    [UIView animateWithDuration:0.3f animations:^{
         _animateImageView.transform = CGAffineTransformRotate(_animateImageView.transform, M_PI/2);
    }];
}


-(void)show
{
    _loadView.userInteractionEnabled = NO;
    //创建定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(rotateAction) userInfo:nil repeats:YES];
}


+(void)showOnView:(UIView *)view setTapBlock:(void (^)())tapBlock
{
    FMProgressHUD *HUD =  [[self alloc]initWithFrame:view.frame withBlock:tapBlock];
    
    HUD.tag = HUD_TAG;
    [view addSubview:HUD];
    [HUD show];
}

+(void)showOnView:(UIView *)view
{
    FMProgressHUD *HUD =  [[self alloc]initWithFrame:view.frame];
    HUD.tag = HUD_TAG;
    [view addSubview:HUD];
    [HUD show];
}

-(void)hideAfterSuccess
{
    [_timer invalidate];
}

+(void)hideAfterSuccessOnView:(UIView *)view
{
    FMProgressHUD *HUD = (FMProgressHUD*)[view viewWithTag:HUD_TAG];
    [HUD hideAfterSuccess];
    [HUD removeFromSuperview];
    HUD = nil;
}


-(void)hideAfterFail
{
     _loadView.userInteractionEnabled = YES;
    _alterLabel.hidden = NO;
    [_timer setFireDate:[NSDate distantFuture]];
    _animateImageView.hidden = YES;
}

+(void)hideAfterFailOnView:(UIView *)view
{
    FMProgressHUD *HUD = (FMProgressHUD*)[view viewWithTag:HUD_TAG];
    [HUD hideAfterFail];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
