//
//  XLShop.m
//  0-瀑布流
//
//  Created by xianglinios on 15/6/20.
//  Copyright © 2015年 xianglinios. All rights reserved.
//

#import "XLShop.h"

@implementation XLShop

+ (instancetype)shopWithDict:(NSDictionary *)dict{
    
    XLShop *shop = [[XLShop alloc] init];
    
    [shop setValuesForKeysWithDictionary:dict];

    return shop;
}


@end
