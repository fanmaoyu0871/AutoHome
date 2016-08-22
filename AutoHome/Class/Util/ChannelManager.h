//
//  ChannelManager.h
//  AutoHome
//
//  Created by qianfeng on 15/5/13.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelManager : NSObject

@property (nonatomic, readonly)NSArray *items;
@property (nonatomic, readonly)NSArray *comments;
@property (nonatomic, readonly)NSArray *findcars;

+(instancetype)sharedChannelManager;

-(BOOL)saveItems:(id)object withKey:(NSString*)key;

@end
