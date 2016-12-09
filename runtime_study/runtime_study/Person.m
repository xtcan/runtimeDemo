//
//  Person.m
//  runtime_test
//
//  Created by 汤文灿 on 16/6/29.
//  Copyright © 2016年 tcan. All rights reserved.
//

#import "Person.h"
#import <objc/message.h>

@interface Person ()
{

    NSString *_job;
}
@end

@implementation Person

+ (instancetype)getPerson{
    
    return [[Person alloc]init];
}

- (void)say:(NSString *)message{
    
    NSLog(@"%@",message);
}

+ (void)say{
    
    NSLog(@"类消息传递");
}

- (void)doSomething{
    
    NSLog(@"做一些事情");
}

- (void)doOtherthing{
    
    NSLog(@"做另外一些事情");
}

void eat(id self, SEL _cmd)
{
    NSLog(@"动态添加了方法eat");
}



//解档
- (void)encodeWithCoder:(NSCoder *)encoder{
    
    unsigned int count = 0;
    
    //获得指向该类所有属性的指针
    objc_property_t *properties = class_copyPropertyList([Person class], &count);
    
    for (int i =0; i < count; i ++) {
       
        objc_property_t property = properties[i];

        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
        
        // 编码每个属性,利用KVC取出每个属性对应的数值
        [encoder encodeObject:[self valueForKeyPath:key] forKey:key];
    }
}

//归档
- (instancetype)initWithCoder:(NSCoder *)decoder{

    unsigned int count = 0;
    
    //获得指向该类所有属性的指针
    objc_property_t *properties = class_copyPropertyList([Person class], &count);
    
    for (int i =0; i < count; i ++) {
        
        objc_property_t property = properties[i];

        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
        
        //解码每个属性,利用KVC取出每个属性对应的数值
        [self setValue:[decoder decodeObjectForKey:key] forKeyPath:key];
    }
    return self;
}




//runtime动态添加对象方法
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    
    if (sel == @selector(eat:)) {
        
        class_addMethod(self, sel, (IMP)eat, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

@end
