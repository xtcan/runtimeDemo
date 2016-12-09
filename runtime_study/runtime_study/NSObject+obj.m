//
//  NSObject+obj.m
//  runtime_test
//
//  Created by 汤文灿 on 16/6/29.
//  Copyright © 2016年 tcan. All rights reserved.
//

#import "NSObject+obj.h"
#import <objc/message.h>


@implementation NSObject (obj)

- (void)setName:(NSString *)name{
    
    objc_setAssociatedObject(self, @"name", name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)name{
    
   return  objc_getAssociatedObject(self, @"name");
}

@end
