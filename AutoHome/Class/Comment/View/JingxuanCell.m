//
//  JingxuanCell.m
//  AutoHome
//
//  Created by 范茂羽 on 15/5/17.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "JingxuanCell.h"
#import "UIImageView+WebCache.h"

@interface JingxuanCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation JingxuanCell


-(void)configJingxuanModel:(JingxuanModel*)model
{
    //清理
    self.typeLabel.text  = @"";
    self.typeLabel.backgroundColor = [UIColor whiteColor];
    
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.smallpic] placeholderImage:IMAGE_PLACEHODER];
    self.titleLabel.text = model.title;
    self.dateLabel.text = model.bbsname;
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"%ld回", [model.replycounts integerValue]];
    
    self.commentLabel.text = str;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
