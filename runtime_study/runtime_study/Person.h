//
//  Person.h
//  runtime_test
//
//  Created by 汤文灿 on 16/6/29.
//  Copyright © 2016年 tcan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject<NSCopying>

@property(nonatomic,copy)NSString *name; //名字
@property(nonatomic,assign)NSInteger age;//年龄

- (void)say:(NSString *)message;         //对象方法
+ (void)say;                             //类方法

- (void)doSomething;                     //做一些事情
- (void)doOtherthing;                    //做其他事情

+ (instancetype)getPerson;               //获得一个对象

@end
