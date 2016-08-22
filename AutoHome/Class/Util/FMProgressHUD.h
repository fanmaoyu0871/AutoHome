//
//  FMProgressHUD.h
//  AutoHome
//
//  Created by qianfeng on 15/5/19.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMProgressHUD : UIView

+(void)showOnView:(UIView*)view setTapBlock:(void (^)())tapBlock;

+(void)showOnView:(UIView*)view;

+(void)hideAfterSuccessOnView:(UIView *)view;

+(void)hideAfterFailOnView:(UIView *)view;


@end
