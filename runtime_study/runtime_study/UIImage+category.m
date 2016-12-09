//
//  UIImage+category.m
//  runtime_study
//
//  Created by tcan on 16/7/15.
//  Copyright © 2016年 tcan. All rights reserved.
//

#import "UIImage+category.h"
#import <objc/message.h>

@implementation UIImage (category)

+ (void)load{
    
    Method oldMethod = class_getClassMethod([UIImage class], @selector(imageNamed:));
    Method newMethod = class_getClassMethod([UIImage class], @selector(t_imageNamed:));
    
    //交换方法实现
    method_exchangeImplementations(oldMethod, newMethod);
}

+ (UIImage *)t_imageNamed:(NSString *)imageName{
    
    UIImage *img = [UIImage t_imageNamed:imageName];
    if (imageName.length == 0) {
        
        NSLog(@"警告：传入图片名为空字符串！");
    }
    return img;
}

@end
