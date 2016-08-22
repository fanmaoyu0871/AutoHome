//
//  BrandCell.m
//  AutoHome
//
//  Created by qianfeng on 15/5/18.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "BrandCell.h"
#import "UIImageView+WebCache.h"

@interface BrandCell ()

@end

@implementation BrandCell

-(void)config:(BrandModel*)model
{
    self.nameLabel.text = model.name;
    self.picImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"carBrandpic_default"]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
