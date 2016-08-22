//
//  FMDailyPaperControllerTableViewController.h
//  AutoHome
//
//  Created by qianfeng on 15/5/14.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMDailyPaperController : UIViewController

@property (nonatomic, copy)NSString *urlStr;

-(void)downloadDataWithUrlStr:(NSString*)urlStr;

@end
