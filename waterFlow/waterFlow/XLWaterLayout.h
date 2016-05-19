//
//  XLWaterLayout.h
//  0-瀑布流
//
//  Created by xianglinios on 15/6/20.
//  Copyright © 2015年 xianglinios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLWaterLayout;

@protocol XLWaterLayoutDelegate <NSObject>

/**
 *  传入宽度和indexPath,算出高度
 */
- (CGFloat)waterLayout:(XLWaterLayout *)waterLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;

@end

@interface XLWaterLayout : UICollectionViewFlowLayout

@property (nonatomic,weak) id<XLWaterLayoutDelegate> delegate;

@end
