//
//  XLCircleLayOut.m
//  collectionView-otherLayout
//
//  Created by xianglinios on 15/6/22.
//  Copyright © 2015年 xianglinios. All rights reserved.
//

#import "XLCircleLayout.h"

@implementation XLCircleLayout

/**
 *  方法一
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
/**
 *  方法二
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //3设置size
    attrs.size = CGSizeMake(50, 50);
    
    //4定义圆心,半径
    CGPoint circleCenter = CGPointMake(self.collectionView.frame.size.width*0.5, self.collectionView.frame.size.height*0.5);
    CGFloat circleRadius = 80;
    
    //5计算每个item之间的角度
    CGFloat angel = M_PI * 2 / [self.collectionView numberOfItemsInSection:indexPath.section];
    
    //6.假设右侧水平位置的item为第0个,角度为0,计算每个item的角度
    CGFloat itemAngel = indexPath.item * angel;
    
    //7.计算每个item的中心点位置
    CGFloat itemX = circleCenter.x + cosf(itemAngel) * circleRadius;
    CGFloat itemY = circleCenter.y - sinf(itemAngel) * circleRadius;
    attrs.center = CGPointMake(itemX, itemY);
    
    //8.设置图片排列,靠前添加的在上面
    attrs.zIndex = [self.collectionView numberOfItemsInSection:indexPath.section] - indexPath.item;

    return attrs;
}
/**
 *  方法三
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //1.定义可变数组存储属性
    NSMutableArray *nmArray = [NSMutableArray array];
    
    //2.循环设置item的属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        //9.添加进数组
        [nmArray addObject:attrs];
    }
    //10.返回数组
    return nmArray;
}
@end
