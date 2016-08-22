//
//  MenuView.h
//  AutoHome
//
//  Created by qianfeng on 15/5/13.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuView : UIView

@property (nonatomic, copy)void (^menuViewBlock)();

@property (nonatomic, copy)void (^hideTabBar)(BOOL isHidden);

@end
