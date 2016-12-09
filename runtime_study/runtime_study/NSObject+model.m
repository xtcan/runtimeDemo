//
//  NSObject+model.m
//  runtime_study
//
//  Created by tcan on 16/7/24.
//  Copyright © 2016年 tcan. All rights reserved.
//

#import "NSObject+model.h"
#import <objc/message.h>


@implementation NSObject (model)

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    
    id objc = [[self alloc]init];
    
    unsigned int count = 0;
    
    //runtime：遍历模型中所有属性，去字典中查找
    
    //获得指向该类所有属性的指针
    objc_property_t *properties = class_copyPropertyList(self, &count);
    
    for (int i =0; i < count; i ++) {
        
        objc_property_t property = properties[i];
        //获取属性名
        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
        //获取字典的value
        id value = dict[key];
        if (value) {
            
            [objc setValue:value forKey:key];
        }
    }
    return objc;
}

@end
