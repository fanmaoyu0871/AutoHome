//
//  FMBrandSliderController.h
//  AutoHome
//
//  Created by qianfeng on 15/5/18.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMBingoController.h"

@interface FMBrandSliderController : FMBingoController
@property (nonatomic, copy)void (^closeBtnBlock)();
@property (nonatomic, copy)void (^segCtrlValueChange)(int index);
@end
