//
//  NSString+Tools.m
//  AutoHome
//
//  Created by qianfeng on 15/5/19.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "NSString+Tools.h"

@implementation NSString (Tools)
+(NSString*)stringForHtmlPath:(NSString*)urlString
{
    NSArray *component = [urlString componentsSeparatedByString:@"/"];
    NSString *subStr = [component lastObject];
    NSArray *array = [subStr componentsSeparatedByString:@"."];
    NSString *prefixStr = [array firstObject];
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/tmp/%@.html", prefixStr]];

    
    return path;
}
@end
