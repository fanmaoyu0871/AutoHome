//
//  NewsPicCell.m
//  AutoHome
//
//  Created by 范茂羽 on 15/5/17.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "NewsPicCell.h"
#import "UIImageView+WebCache.h"

@interface NewsPicCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *midImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation NewsPicCell

-(void)config:(NewsModel *)model
{
    self.titleLabel.text = model.title;
    self.dateLabel.text = model.time;
    
    NSString *str = [NSString stringWithFormat:@"%ld图片", [model.replycount integerValue]];
    self.numberLabel.text = str;
    
    NSString *picStr = model.indexdetail;
    NSArray *picNameArray = [picStr componentsSeparatedByString:@","];
    
    //第一张路径特殊需处理
    NSRange indexRange = [picNameArray[0] rangeOfString:@"http"];
    if(indexRange.location != NSNotFound)
    {
        NSString *firstName = [picNameArray[0] substringWithRange:NSMakeRange(indexRange.location, [picNameArray[0] length]-indexRange.location)] ;
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:firstName] placeholderImage:IMAGE_PLACEHODER];
    }
    
    [self.midImageView sd_setImageWithURL:[NSURL URLWithString:picNameArray[1]]];
     [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:picNameArray[2]] placeholderImage:IMAGE_PLACEHODER];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
