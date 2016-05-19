//
//  XLLineLayOut.m
//  collectionView-otherLayout
//
//  Created by xianglinios on 15/6/22.
//  Copyright © 2015年 xianglinios. All rights reserved.
//

#import "XLLineLayout.h"
static const CGFloat XLItemWH = 100;

@implementation XLLineLayout
/**
 *  重写初始化方法
 */
- (instancetype)init
{
    if (self = [super init]) {
        //1.设置item的大小
        self.itemSize = CGSizeMake(XLItemWH, XLItemWH);
        
        //2.设置滚动方式
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}
/**
 *  准备布局
 *  一些初始化设置,也可写到这里,问:和写在init中的区别??
 */
- (void)prepareLayout
{
    [super prepareLayout];
    //3.设置间距
    //(此处self.collectionView.frame.size.width为0,因为布局初始化时,collectionview还未初始化成功)
    CGFloat inset = (self.collectionView.frame.size.width-XLItemWH)*0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    
    //4.设置每行每列的间距
    self.minimumLineSpacing = 80;
}
/**
 *  只要显示的边界发生改变就重新布局:
    内部会重新调用prepareLayout和layoutAttributesForElementsInRect方法获得所有cell的布局属性
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

/** 有效距离:当item的中间x距离屏幕的中间x在HMActiveDistance以内,才会开始放大, 其它情况都是缩小 */
static CGFloat const XLActiveDistance = 150;

/** 缩放因素: 值越大, item就会越大 */
static CGFloat const XLScaleFactor = 0.6;


/**
 *  取出布局属性的方法
 *  想要实现越靠近屏幕中央的图片越大,靠两侧逐渐缩小,需要修改布局属性
 */
- (NSArray <UICollectionViewLayoutAttributes *>*)layoutAttributesForElementsInRect:(CGRect)rect
{
    //0.计算当前屏幕的rect
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.frame.size;
    
    //1.取出父类布局中所有rect范围的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    //2.获取collectionView的中心点 = contentOffset.x+屏幕的一半
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width*0.5;
    //3.遍历属性数组,修改属性
    for (UICollectionViewLayoutAttributes *attrs in array) {
        
        //判断CGRectIntersectsRect(<#CGRect rect1#>, <#CGRect rect2#>)
        //rect1与rect2是否相交
        if (!CGRectIntersectsRect(visibleRect, attrs.frame)) continue;
        
        //分析:获取每一个item的x值和屏幕最中间的x比较
        //绝对值的差值越小,则放大倍数越大,反之,越小.
        //4.获取每个item的中点(属性中有center)
        CGFloat itemX = attrs.center.x;
        
        //5.根据差值,定义缩放比例, XLActiveDistance进入这个距离才开始变大,这样不会出现图片突然消失在屏幕中.因为本来图片不应该消失,但因为它虽然靠近边缘,但根据缩放比例的计算,他还是大于1的(放大状态),但图片实际大小较小一点,但判断是以屏幕的原始frame作为条件的,所以会有突然消失的情况
        CGFloat scale = 1 + XLScaleFactor*(1-ABS(itemX - centerX)/XLActiveDistance);
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
        
        //6.这样效率较低,不在屏幕中的item,都计算了中心,可以优化,只计算在当前屏幕的item中心点
        //可进行判断,在当前屏幕的item则计算中点x值
    }
    return array;
}
/**
 *  想实现每次拖动相册,最终停留的位置都是一张图片的最中央
 *  此方法用来设置collectionView停止滚动那一刻的位置
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //分析:1.先计算最后停留的rect,算出最终的中心x值
    //    2.计算最终屏幕中的item的中心x值与屏幕的x的差值,求出最小的差值a
    //    3.让其item再偏移a即可(有正有负)
    
    //1.定义最后的rect
    CGRect lastRect;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
    
    //2.求最后的中心x
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width*0.5;
    
    //3.求出在lastRect中item的中心x值与centerX值得最小差值
    //3.1先取出lastRect范围内的所有item的属性
    NSArray *lastArray = [self layoutAttributesForElementsInRect:lastRect];
    
    //4.先假定一个最小差值,为一个很大的数
    CGFloat minX = MAXFLOAT;
    
    //5遍历所有属性
    for (UICollectionViewLayoutAttributes *attrs in lastArray) {
        //6.判断差值
        if (ABS(attrs.center.x - centerX) < ABS(minX)) {
            minX = attrs.center.x - centerX;//可正可负
        }
    }
    //要返回的是CGPoint,x值:即是 要偏移的值(最小的差值)+proposedContentOffset(计划.预计偏移)的x值
    return CGPointMake(minX + proposedContentOffset.x, 0);
}

@end
