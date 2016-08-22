//
//  FMCategorySliderController.h
//  AutoHome
//
//  Created by qianfeng on 15/5/15.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMBingoController.h"

@interface FMCategorySliderController : FMBingoController

@property (nonatomic, copy)void (^closeBtnBlock)();
@property (nonatomic, copy)void (^selectCellBlock)(NSInteger index);

//上次点击的cell索引
@property (nonatomic, assign)NSInteger selectedIndex;

@end
