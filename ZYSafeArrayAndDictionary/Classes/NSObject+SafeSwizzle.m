//
//  NSObject+SafeSwizzle.m
//  MJYPCore
//
//  Created by zhengyin on 2019/10/22.
//  Copyright © 2019 xiaomi. All rights reserved.
//

#import "NSObject+SafeSwizzle.h"
#import <objc/runtime.h>

@implementation NSObject (SafeSwizzle)

- (void)swizzleMethod:(SEL)origSel withMethod:(SEL)altSel
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, origSel);
    Method swizzledMethod = class_getInstanceMethod(class, altSel);
    
    BOOL didAddMethod = class_addMethod(class, origSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, altSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)swizzleMethods:(Class)curClass originalSelector:(SEL)origSel swizzledSelector:(SEL)swizSel {
    if (curClass) {
        Method origMethod = class_getInstanceMethod(curClass, origSel);
        Method swizMethod = class_getInstanceMethod(curClass, swizSel);
        
        //class_addMethod will fail if original method already exists
        BOOL didAddMethod = class_addMethod(curClass, origSel, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod));
        if (didAddMethod) {
            class_replaceMethod(curClass, swizSel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
        } else {
            //origMethod and swizMethod already exist
            method_exchangeImplementations(origMethod, swizMethod);
        }
    }
}

@end
