//
//  XLImageCell.m
//  collectionView-otherLayout
//
//  Created by xianglinios on 15/6/22.
//  Copyright © 2015年 xianglinios. All rights reserved.
//

#import "XLImageCell.h"

@interface XLImageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
@implementation XLImageCell

- (void)awakeFromNib {

    //设置每张图片的相框效果
    self.image.layer.borderWidth = 3;
    self.image.layer.borderColor = [UIColor whiteColor].CGColor;
    self.image.layer.cornerRadius = 3;
    self.image.clipsToBounds = YES;
    
}

- (void)setImages:(NSString *)images
{
    _images = [images copy];
    self.image.image = [UIImage imageNamed:images];
}
@end
