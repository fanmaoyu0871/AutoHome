//
//  NewsModel.h
//  AutoHome
//
//  Created by 范茂羽 on 15/5/16.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

@property (nonatomic, copy)NSString* ID;
@property (nonatomic, copy)NSString* title;
@property (nonatomic, copy)NSNumber* mediatype;
@property (nonatomic, copy)NSString* type;
@property (nonatomic, copy)NSString* time;
@property (nonatomic, copy)NSString* indexdetail;
@property (nonatomic, copy)NSString* smallpic;
@property (nonatomic, strong)NSNumber* replycount;
@property (nonatomic, copy)NSString* jumppage;
@property (nonatomic, copy)NSString* lasttime;
@property (nonatomic, copy)NSNumber* newstype;
@property (nonatomic, copy)NSString* updatetime;

@end
