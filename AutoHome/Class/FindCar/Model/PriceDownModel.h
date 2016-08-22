//
//  PriceDownModel.h
//  AutoHome
//
//  Created by qianfeng on 15/5/18.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PriceDownModel2;

@interface PriceDownModel : NSObject

@property (nonatomic, copy)NSNumber *Id;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *shortname;
@property (nonatomic, copy)NSString *city;
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *phone;
@property (nonatomic, copy)NSString *phonestyled;
@property (nonatomic, copy)NSNumber *is400;
@property (nonatomic, copy)NSNumber *is24hour;
@property (nonatomic, copy)NSString *lat;
@property (nonatomic, copy)NSString *lon;
@property (nonatomic, copy)NSString *major;
@property (nonatomic, copy)NSString *isauth;
@property (nonatomic, copy)NSNumber *ispromotion;
@property (nonatomic, copy)NSString *specprice;
@property (nonatomic, copy)NSString *seriesprice;
@property (nonatomic, copy)NSString *scopestatus;
@property (nonatomic, copy)NSString *scopename;
@property (nonatomic, copy)NSString *loworminprice;
@property (nonatomic, copy)NSNumber *ishavelowprice;
@property (nonatomic, copy)NSString *price;
@property (nonatomic, copy)NSString *teltext;
@property (nonatomic, copy)NSString *orderrange;

@property (nonatomic, strong)PriceDownModel2 *model2;

@end


@interface PriceDownModel2 : NSObject

//"specid": 20442,
//"specname": "2015款 XJL 2.0T 两驱尊享商务版",
//"specpic": "http://www.autoimg.cn/upload/2014/9/25/m_20140925094633673510410.jpg",
//"seriesid": 178,
//"seriesname": "捷豹XJ",
//"inventorystate": 1,
//"styledinventorystate": "http://x.autoimg.cn/dealer/minisite/images/icon/InventoryState1.png",
//"dealerprice": "71.37",
//"fctprice": "109.80",
//"specstatus": "",
//"articletype": 0,
//"articleid": 30118723,
//"ordercount": 1,
//"enddate": "2015-05-24",
//"assellphone": null,
//"orderrangetitle": "可销往全国",

@property (nonatomic, copy)NSNumber *specid;
@property (nonatomic, copy)NSString *specname;
@property (nonatomic, copy)NSString *specpic;
@property (nonatomic, copy)NSNumber *seriesid;
@property (nonatomic, copy)NSString *seriesname;
@property (nonatomic, copy)NSString *inventorystate;
@property (nonatomic, copy)NSString *styledinventorystate;
@property (nonatomic, copy)NSString *dealerprice;
@property (nonatomic, copy)NSString *fctprice;
@property (nonatomic, copy)NSString *specstatus;
@property (nonatomic, copy)NSNumber *articletype;
@property (nonatomic, copy)NSNumber *articleid;
@property (nonatomic, copy)NSNumber *ordercount;
@property (nonatomic, copy)NSString *enddate;
@property (nonatomic, copy)NSString *assellphone;
@property (nonatomic, copy)NSString *orderrangetitle;
@property (nonatomic, copy)NSString *orderrange;

@end
