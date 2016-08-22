//
//  BrandModel.h
//  AutoHome
//
//  Created by 范茂羽 on 15/5/18.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandModel : NSObject

//"id": 35,
//"name": "阿斯顿·马丁",
//"imgurl": "http://x.autoimg.cn/app/image/brands/35.png"

@property (nonatomic, copy)NSNumber* Id;
@property (nonatomic, copy)NSString* name;
@property (nonatomic, copy)NSString* imgurl;

@end
