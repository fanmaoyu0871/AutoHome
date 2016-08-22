//
//  FMRefreshHeaderView.m
//  AutoHome
//
//  Created by qianfeng on 15/5/20.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMRefreshHeaderView.h"

#define REFRESH_H 60.0f

typedef NS_ENUM(NSInteger, FMRefreshState)
{
    FMRefreshState_NORMAL,
    FMRefreshState_LOADING,
    FMRefreshState_PULLING
};

@implementation FMRefreshHeaderView
{
    UIImageView *_animateImageView;
    UILabel *_label;
    
    FMRefreshState _curState;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.center.x-60, frame.size.height-40, 40, 40)];
        bgImageView.image = [UIImage imageNamed:@"load_icon_dial"];
        [self addSubview:bgImageView];
        
        _animateImageView = [[UIImageView alloc]initWithFrame:bgImageView.bounds];
        _animateImageView.image = [UIImage imageNamed:@"load_icon_pointer"];
        _animateImageView.layer.transform = CATransform3DIdentity;
        [bgImageView addSubview:_animateImageView];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(self.center.x-20, frame.size.height-30, 200, 20)];
        _label.font = [UIFont systemFontOfSize:12];
        _label.text = @"下拉刷新...";
        _label.textColor = [UIColor grayColor];
        [self addSubview:_label];
        
        //把初始状态设置为normal
        [self setState:FMRefreshState_NORMAL];
    }
    
    return self;
}



-(void)setState:(FMRefreshState)state
{
    switch (state) {
        case FMRefreshState_NORMAL:
            [_animateImageView.layer removeAllAnimations];
           // _animateImageView.layer.transform =CATransform3DIdentity;
            _curState = FMRefreshState_NORMAL;
            break;
        case FMRefreshState_LOADING:
            _curState = FMRefreshState_LOADING;
            break;
        case FMRefreshState_PULLING:
            _curState = FMRefreshState_PULLING;
            break;
        default:
            break;
    }
}

- (void)FMRefrshScrollViewDidScroll:(UIScrollView *)scrollView
{
    //判断是否正在加载
    if(_curState == FMRefreshState_LOADING)
    {
        //判断y偏移量在0上面还是下面
        CGFloat offsetY = MAX(-scrollView.contentOffset.y, 0);
        offsetY = MIN(offsetY, REFRESH_H);
        scrollView.contentInset = UIEdgeInsetsMake(offsetY, 0, 0, 0);
    }
    else if(scrollView.dragging)
    {
        if(scrollView.contentOffset.y > -REFRESH_H-20.f && scrollView.contentOffset.y < -20.f)
        {
            CGFloat perAngle=  (M_PI+M_PI_2)/(REFRESH_H);
            CGFloat offsetAngle = (-scrollView.contentOffset.y-20)* perAngle;
            
            _animateImageView.transform = CGAffineTransformMakeRotation(offsetAngle);
            [self setState:FMRefreshState_NORMAL];
            
            _label.text = @"下拉刷新...";
        }
        else if(scrollView.contentOffset.y < -REFRESH_H)
        {
            _label.text = @"松开刷新...";
            [self setState:FMRefreshState_PULLING];
        }
    }
}

- (void)FMRefrshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    
    if(_curState == FMRefreshState_LOADING)
    {
        scrollView.contentInset = UIEdgeInsetsMake(REFRESH_H, 0, 0, 0);
        [self setState:FMRefreshState_LOADING];
        return;
    }
    else
    {
        if(scrollView.contentOffset.y <= -REFRESH_H)
        {
            [self setState:FMRefreshState_LOADING];
            scrollView.contentInset = UIEdgeInsetsMake(REFRESH_H, 0, 0, 0);
            
            //动画
            CATransform3D oriTransform = _animateImageView.layer.transform;
            CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            keyAnimation.values = @[[NSValue valueWithCATransform3D:oriTransform],[NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI, 0, 0, 1)], [NSValue valueWithCATransform3D:oriTransform]];
            keyAnimation.duration = 5.0f;
            keyAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            keyAnimation.keyTimes = @[@(0.0f), @(0.1f), @(1.0)];
            keyAnimation.repeatCount = 10000;
            [_animateImageView.layer addAnimation:keyAnimation forKey:nil];
            
            _label.text = @"正在刷新...";
          
        }
        else
        {
            _label.text = @"下拉刷新...";
            [self setState:FMRefreshState_NORMAL];
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }
    
}


@end
