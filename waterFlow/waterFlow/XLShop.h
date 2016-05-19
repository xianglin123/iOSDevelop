//
//  XLShop.h
//  0-瀑布流
//
//  Created by xianglinios on 15/6/20.
//  Copyright © 2015年 xianglinios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLShop : NSObject
@property (nonatomic,assign) double height;
@property (nonatomic,assign) double width;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *price;

+ (instancetype)shopWithDict:(NSDictionary *)dict;


@end
