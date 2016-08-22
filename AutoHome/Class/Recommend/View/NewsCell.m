//
//  NewsCell.m
//  AutoHome
//
//  Created by 范茂羽 on 15/5/16.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "NewsCell.h"
#import "UIImageView+WebCache.h"

@interface NewsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation NewsCell


-(void)config:(NewsModel*)model
{
    //清理
    self.typeLabel.text  = @"";
    self.typeLabel.backgroundColor = [UIColor whiteColor];
    
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.smallpic] placeholderImage:IMAGE_PLACEHODER];
    self.titleLabel.text = model.title;
    self.dateLabel.text = model.time;
    
   NSMutableString *str = [NSMutableString stringWithFormat:@"%ld", [model.replycount integerValue]];
    
    if(model.newstype == nil)
    {
        self.typeLabel.text = @"头条";
        self.typeLabel.backgroundColor = [UIColor blueColor];
    }

    if([model.mediatype integerValue] == 3)
    {
        [str appendString:@"播放"];
    }
    else if([model.mediatype integerValue] == 2)
    {
        self.typeLabel.text = @"说客";
        self.typeLabel.backgroundColor = [UIColor orangeColor];
        [str appendString:@"评论"];
    }
    else
    {
        [str appendString:@"评论"];
    }
    
    self.commentLabel.text = str;
    
    if([model.replycount integerValue] == 0)
    {
        self.commentLabel.text = @"";
    }
}






- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
