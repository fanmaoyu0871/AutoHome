//
//  FMSliderGroupController.h
//  AutoHome
//
//  Created by qianfeng on 15/5/18.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMBingoController.h"

@interface FMSliderGroupController : FMBingoController

@property (nonatomic, strong)NSMutableArray *letterArray;
@property (nonatomic, strong)NSMutableArray *brandArray;
@property (nonatomic, strong)NSMutableArray *resultArray;

@property (nonatomic, copy)void (^closeBtnBlock)();
@property (nonatomic, copy)void (^selectCellBlock)(NSInteger index);

//上次点击的cell索引
@property (nonatomic, strong)NSIndexPath* selectedIndexPath;

@property (nonatomic, copy)NSString *urlStr;

@end
