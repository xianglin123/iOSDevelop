//
//  XLStackLayOut.m
//  collectionView-otherLayout
//
//  Created by xianglinios on 15/6/22.
//  Copyright © 2015年 xianglinios. All rights reserved.
//

#import "XLStackLayout.h"

@implementation XLStackLayout
#pragma mark - 自定义布局必须要实现的方法一
/**
 *  布局改变,要执行的方法
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
#pragma mark - 自定义布局必须要实现的方法二
/**
 *  返回具体每个item的属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //0.angelArray存一些角度
    NSArray *angelArray = @[@0, @(-0.2), @(-0.5), @(0.2), @(0.5)];
    
    //3.2创建属性对象,设置属性
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //4.设置堆布局item的属性
    attrs.size = CGSizeMake(100, 100);
    attrs.center = CGPointMake(self.collectionView.frame.size.width*0.5, self.collectionView.frame.size.height*0.5);
    
    //5.要实现只显示前五张图片,且第一张是正的,其余有一些角度
    if (indexPath.item >= 5) {
        attrs.hidden = YES;
    }else{
        //6.可定义一个数组,按顺序存一些角度angelArray,
        //一次取出角度,并转换为float值
        attrs.transform = CGAffineTransformMakeRotation([angelArray[indexPath.item] floatValue]);
        //7.按顺序显示图片,第一张在最上面
        attrs.zIndex = [self.collectionView numberOfItemsInSection:indexPath.section] - indexPath.item;
        
    }
    return attrs;
}
#pragma mark - 自定义布局必须要实现的方法三
/**
 *  返回rect范围内所有item的属性
 *  若布局继承自流水布局,则不用实现方法二,系统已经实现了
 *  自定义布局不实现方法二则,布局切换时会报错
 *  方法二就是方法三的部分封装
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    //1.因为stack(堆布局)继承自空的布局,没有父类的属性,不用调用父类方法
    //定义一个可变数组存储属性
    NSMutableArray *nmArray = [NSMutableArray array];
    
    //2.for循环,设置属性,添加至nmArray中
    //调用numberOfItemsInSection方法,得到第0组有多少个item
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < count; i++) {
        //3.1创建属性对象,设置属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        [nmArray addObject:attrs];
    }
    return nmArray;
    
    
}



@end
