//
//  PriceDownCell.m
//  AutoHome
//
//  Created by qianfeng on 15/5/18.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "PriceDownCell.h"
#import "UIImageView+WebCache.h"

@interface PriceDownCell ()
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *downPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderrangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ordercountLabel;

@end

@implementation PriceDownCell

-(void)configWithModel:(PriceDownModel*)model
{
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.model2.specpic] placeholderImage:IMAGE_PLACEHODER];
    self.titleLabel.text = model.model2.specname;
    
    float price = [model.model2.fctprice floatValue];
    float nowPrice = [model.model2.dealerprice floatValue];
    NSString *downPrice = [NSString stringWithFormat:@"降%.2f万", price-nowPrice];
    self.downPriceLabel.text = downPrice;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f万", nowPrice];
    
    self.cityLabel.text = model.city;
    self.shopNameLabel.text = model.shortname;
    self.orderrangeLabel.text = model.model2.orderrange;
    
    if([model.model2.ordercount integerValue] > 10)
    {
        self.ordercountLabel.text = @"现车充足";
    }
    else
    {
        self.ordercountLabel.text = @"少量现车";
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
