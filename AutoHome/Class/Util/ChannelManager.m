//
//  ChannelManager.m
//  AutoHome
//
//  Created by qianfeng on 15/5/13.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "ChannelManager.h"

@interface ChannelManager()

//Recommand数据源
@property (nonatomic, strong)NSMutableArray *itemsArray;

//Comment数据源
@property (nonatomic, strong)NSMutableArray *commentArray;

//FindCar数据源
@property (nonatomic, strong)NSMutableArray *findCardArray;

@end

@implementation ChannelManager

-(NSMutableArray *)itemsArray
{
    if (_itemsArray == nil) {
        
        NSArray *array = [USER_DEFAULT objectForKey:ITEMS];
        if(array)
        {
            _itemsArray = [array mutableCopy];
        }
        else
        {
            NSMutableArray *array0 = [NSMutableArray array];
            [array0 addObject:@{@"title":@"最新", @"vcName":@"FMNewViewController", @"url":@"http://app.api.autohome.com.cn/autov4.7/news/newslist-pm1-c0-nt0-p1-s30-l0.json"}];
            
            NSArray *plistArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Recommend" ofType:@"plist"]];
            NSMutableArray *array1 = [plistArray mutableCopy];
            
            _itemsArray = [NSMutableArray array];
            
            [_itemsArray addObject:array0];
            [_itemsArray addObject:array1];
            
            [USER_DEFAULT setObject:_itemsArray forKey:ITEMS];
            [USER_DEFAULT synchronize];
            
        }
        
    }
    
    return _itemsArray;
}

-(NSMutableArray *)commentArray
{
    if (_commentArray == nil) {
        NSArray *plistArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Comment" ofType:@"plist"]];
        _commentArray = [plistArray mutableCopy];
    }
    
    return _commentArray;
}

-(NSMutableArray *)findCardArray
{
    if (_findCardArray == nil) {
        NSArray *plistArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"FindCar" ofType:@"plist"]];
        _findCardArray = [plistArray mutableCopy];
    }
    
    return _findCardArray;
}

+(instancetype)sharedChannelManager
{
    static ChannelManager *manager = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        if(manager == nil)
        {
            manager = [[self alloc]init];
        }
    });
    
    return manager;
}

-(NSArray *)items
{
    self.itemsArray;
    return [USER_DEFAULT objectForKey:ITEMS];

}

-(NSArray *)comments
{
    return self.commentArray;
}

-(NSArray *)findcars
{
    return self.findCardArray;

}


-(BOOL)saveItems:(id)object withKey:(NSString*)key;
{
    [USER_DEFAULT setObject:object forKey:key];
    return [USER_DEFAULT synchronize];
}



@end
