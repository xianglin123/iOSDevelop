//
//  XLShopCell.m
//  0-瀑布流
//
//  Created by xianglinios on 15/6/20.
//  Copyright © 2015年 xianglinios. All rights reserved.
//

#import "XLShopCell.h"
#import "XLShop.h"

@interface XLShopCell ()
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end
@implementation XLShopCell

- (void)setShop:(XLShop *)shop
{
    _shop = shop;
    self.shopImage.image = [UIImage imageNamed:shop.icon];
    self.priceLabel.text = shop.price;
    
}

- (void)awakeFromNib {
    // Initialization code
}

@end
