//
//  ViewController.m
//  0-瀑布流
//
//  Created by xianglinios on 15/6/20.
//  Copyright © 2015年 xianglinios. All rights reserved.
//

#import "ViewController.h"
#import "XLShop.h"
#import "XLShopCell.h"
#import "XLWaterLayout.h"
@interface ViewController ()<UICollectionViewDataSource,XLWaterLayoutDelegate>

@property (nonatomic,strong) NSArray *shops;
@end

@implementation ViewController
 static NSString *ID = @"shop";
- (NSArray *)shops
{
    if (_shops == nil) {
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"2.plist"ofType:nil]];
        NSMutableArray *nmArr = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            [nmArr addObject:[XLShop shopWithDict:dict]];
        }
        _shops = nmArr;
    }
    return _shops;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //0.创建布局--设置代理
    XLWaterLayout *layout = [[XLWaterLayout alloc]init];
    layout.delegate = self;
    
    //1.创建collectionView
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    
    //2.添加至view
    [self.view addSubview:collectionView];
    
    //3.设置数据源
    collectionView.dataSource = self;
    
    //4.注册
    [collectionView registerNib:[UINib nibWithNibName:@"XLShopCell" bundle:nil] forCellWithReuseIdentifier:ID];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shops.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    XLShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.shop = self.shops[indexPath.item];
    
    return cell;
    
}

/**
 *  瀑布流中计算行高的代理方法
 */
- (CGFloat)waterLayout:(XLWaterLayout *)waterLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    //1.获取模型
    XLShop *shop = self.shops[indexPath.item];
    
    //2.根据模型中算出的宽高比和屏幕上显示的宽度,计算出在屏幕上应显示的高度
    return shop.height/shop.width*width;
}


@end
