//
//  ViewController.m
//  collectionView-otherLayout
//
//  Created by xianglinios on 15/6/22.
//  Copyright © 2015年 xianglinios. All rights reserved.
//

#import "ViewController.h"
#import "XLImageCell.h"
#import "XLLineLayout.h"
#import "XLStackLayout.h"
#import "XLCircleLayout.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) NSMutableArray *images;

@property (nonatomic,weak) UICollectionView *collectionView;
@end

@implementation ViewController
static NSString *ID = @"image";
/**
 *  加载图片
 */
- (NSMutableArray *)images
{
    if (_images == nil) {
        NSMutableArray *nmArr = [NSMutableArray array];
        for (int i = 1; i<=20; i++) {
            NSString *imgStr = [NSString stringWithFormat:@"%d",i];
            [nmArr addObject:imgStr];
        }
        _images = nmArr;
    }
    return _images;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    //1.创建collectionView
    CGFloat viewW = self.view.frame.size.width;
    CGRect rectView = CGRectMake(0, 100, viewW, 200);
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:rectView collectionViewLayout:[[XLLineLayout alloc]init]];
    
    //后加的:赋值给全局属性
    self.collectionView = collectionView;
    
    //2.设置数据源和代理
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    //3.添加至父控件
    [self.view addSubview:collectionView];
    
    //4.注册
    [collectionView registerNib:[UINib nibWithNibName:@"XLImageCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
    //布局方式为collectionView的流水布局,想自定义布局,要不继承自
    //UICollectionViewFlowLayout和UICollectionViewLayout(纯洁的)
    //线性布局(有流水效果,可继承自流水布局,能节省很多)

}

#pragma mark - 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XLImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.images = self.images[indexPath.item];
    
    return cell;
}

/**
 *  点击屏幕,实现切换布局(线性布局和流水布局)
    需要用到collectionView
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    
    if ([self.collectionView.collectionViewLayout isKindOfClass:[XLStackLayout class]]) {
        [self.collectionView setCollectionViewLayout:[[XLCircleLayout alloc]init] animated:YES];
    }else if([self.collectionView.collectionViewLayout isKindOfClass:[XLCircleLayout class]]){
        [self.collectionView setCollectionViewLayout:[[XLLineLayout alloc]init] animated:YES];
    }else {
        [self.collectionView setCollectionViewLayout:[[XLStackLayout alloc]init] animated:YES];
    }
}
#pragma mark - 代理方法
/**
 *  点击某张图片,删除它
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //1.先要从模型中删除,要改为可变数组存储图片
    [self.images removeObjectAtIndex:indexPath.item];
    
    //2.删除界面中的图片(刷新数据)
    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
}



@end
