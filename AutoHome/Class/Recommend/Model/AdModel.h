//
//  AdModel.h
//  AutoHome
//
//  Created by 范茂羽 on 15/5/16.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdModel : NSObject

@property (nonatomic, copy)NSString* updatetime;
@property (nonatomic, copy)NSString* ID;
@property (nonatomic, copy)NSString* imgurl;
@property (nonatomic, copy)NSString* title;
@property (nonatomic, copy)NSString* type;
@property (nonatomic, strong)NSNumber* replycount;
@property (nonatomic, copy)NSNumber* pageindex;
@property (nonatomic, copy)NSNumber* jumpType;
@property (nonatomic, copy)NSString* jumpurl;
@property (nonatomic, copy)NSNumber* mediatype;


@end
