//
//  OriVideoModel.h
//  AutoHome
//
//  Created by 范茂羽 on 15/5/23.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OriVideoModel : NSObject

//"id": 36117,
//"title": "奔驰C级 正向自动泊车入位功能展示",
//"type": "原创",
//"time": "2015-05-23",
//"indexdetail": "<p>&nbsp;&nbsp;&nbsp; 奔驰C级正向自动泊车功能展示</p>",
//"smallimg": "http://www0.autoimg.cn/zx/video/carimg/2015/5/21/120x90_0_2015052117034389100.jpg",
//"replycount": 35,
//"playcount": 9704,
//"nickname": "姬振嘉",
//"videoaddress": "http://v.youku.com/player/getM3U8/vid/XOTYwODAzNzA0/type/mp4/v.m3u8",
//"shareaddress": "http://v.autohome.com.cn/v_8_36117.html",
//"updatetime": "20150521170544",
//"lastid": "2015052301000036117"

@property (nonatomic, copy)NSString *Id;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *indexdetail;
@property (nonatomic, copy)NSString *smallimg;
@property (nonatomic, copy)NSNumber *replycount;
@property (nonatomic, copy)NSNumber *playcount;
@property (nonatomic, copy)NSString *nickname;
@property (nonatomic, copy)NSString *videoaddress;
@property (nonatomic, copy)NSString *shareaddress;
@property (nonatomic, copy)NSString *updatetime;
@property (nonatomic, copy)NSString *lastid;

@end
