//
//  XLWaterLayout.m
//  0-瀑布流
//
//  Created by xianglinios on 15/6/20.
//  Copyright © 2015年 xianglinios. All rights reserved.
//

#import "XLWaterLayout.h"
NSInteger const colColumn = 3;
@interface XLWaterLayout ()
/**
 *  存放每列最大的Y的数组
 */
@property (nonatomic,strong) NSMutableArray *maxYarray;
@end

@implementation XLWaterLayout

//完全自定义布局要实现的方法,此处不是完全自定义,是继承UICollectionViewFlowLayout


- (NSMutableArray *)maxYarray
{
   
    if (_maxYarray == nil) {
        
        _maxYarray = [NSMutableArray array];
    }
    return _maxYarray;
}

/**
 *  返回每个item的属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //1.设置item的间距.行,列距,列数
    CGFloat rowMargin = 10;
    CGFloat colMargin = 10;
    UIEdgeInsets edge = UIEdgeInsetsMake(10, 10, 10, 10);
    NSInteger colColumn = 3;
    
    //2.设置尺寸
    CGFloat itemW = (self.collectionView.frame.size.width - edge.left - edge.right - (colColumn - 1)*colMargin)/colColumn;
    
    //高度用随机数是不可取的,应在pilst文件中告诉高度或者告诉宽高比,模型数据中存储有h值
    //但布局不应该依赖于某个模型,这样扩展性很低,
    //这里可以用代理,让控制器算出高度
    //添加协议-设置代理-实现方法
//    CGFloat itemH = 100 + arc4random_uniform(100);
    
    //用代理对象调用代理方法
    CGFloat itemH = [self.delegate waterLayout:self heightForWidth:itemW atIndexPath:indexPath];
    
    //item的x,y值的确定,需要确定当前item添加在哪一列. 原则:从最短的列开始添加
    //定义一个数组存储每列的y值,便于找出最小的y值
    
    //2.1找出y值最小的那一列和记录那一列,先假定一个最大的y
    CGFloat colY = MAXFLOAT;
    NSInteger colMin = 0;
    
    //2.2循环数组,比较谁的y最小
    for (int i = 0; i<colColumn; i++) {
        //2.3取出数组存储的每一列的y
        CGFloat arrY = [self.maxYarray[i] doubleValue];
        if (arrY < colY) {
            colY = arrY;
            colMin = i;
        }
    }
    
    //3.设置位置
    CGFloat itemX = edge.left + (itemW +colMargin)*colMin;
    CGFloat itemY = colY + rowMargin;
    
    //4.获取item的原始属性,便于修改
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //5.修改属性
    attr.frame = CGRectMake(itemX, itemY, itemW, itemH);
    
    //6.记录添加item后的y值
    self.maxYarray[colMin] = @(CGRectGetMaxY(attr.frame));
    
    return attr;
    
}
/**
 *  返回所有item的属性的集合
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //0.清空原来的所有的值
    [self.maxYarray removeAllObjects];
    
    //1.初始化数组的值为0,便于比较y值
    for (int i = 0 ; i < colColumn;i ++) {
        [self.maxYarray addObject:@(0)];
    }
    
    //2.定义可变数组存储属性
    NSMutableArray *nmArray = [NSMutableArray array];
    
    //3.循环遍历所有item,item的个数根据数据确定
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < count; i++) {
        
        //4.调用layoutAttributesForItemAtIndexPath方法,可得到每个item的属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        //5.添加到数组中
        [nmArray addObject:attrs];
    }
    return nmArray;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

/**
 *  要实现可以滚动,需设置contentSize
 */
- (CGSize)collectionViewContentSize
{
    CGFloat maxY = 0;

    //1.获得所有列中最大的y值,遍历存储y值得数组,假定最大的y值是第一列
    if (self.maxYarray.count) {
        maxY = [self.maxYarray[0] doubleValue];
        for (int i = 1; i< colColumn; i++) {
            CGFloat newY = [self.maxYarray[i] doubleValue];
            if (maxY < newY) {
                maxY = newY;
            }
        }
    }
    return CGSizeMake(0, maxY);
}


@end
