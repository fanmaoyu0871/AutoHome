//
//  FMRefreshHeaderView.h
//  AutoHome
//
//  Created by qianfeng on 15/5/20.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMRefreshHeaderView : UIView

@property (nonatomic, copy)void (^refreshingBlock)();

- (void)FMRefrshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)FMRefrshScrollViewDidEndDragging:(UIScrollView *)scrollView;

@end
