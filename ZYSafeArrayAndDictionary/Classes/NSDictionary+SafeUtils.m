//
//  NSDictionary+SafeUtils.m
//  MJYPCore
//
//  Created by zhengyin on 2019/10/21.
//  Copyright © 2019 xiaomi. All rights reserved.
//

#import "NSDictionary+SafeUtils.h"
#import "NSObject+SafeSwizzle.h"
#import <objc/runtime.h>

@implementation NSDictionary (SafeUtils)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = objc_getClass("__NSPlaceholderDictionary");
        [self swizzleMethods:class originalSelector:@selector(initWithObjects:forKeys:count:) swizzledSelector:@selector(mjyp_initWithObjects:forKeys:count:)];
        [self swizzleMethods:class originalSelector:@selector(dictionaryWithObjects:forKeys:count:) swizzledSelector:@selector(mjyp_dictionaryWithObjects:forKeys:count:)];
    });
}

+ (instancetype)mjyp_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key) {
            NSAssert(key, ([NSString stringWithFormat:@"attempt to insert nil key from key[%lu]", (unsigned long)i]));
            continue;
        }
        if (!obj) {
            NSAssert(obj, ([NSString stringWithFormat:@"attempt to insert nil object from objects[%lu]", (unsigned long)i]));
            continue;
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self mjyp_dictionaryWithObjects:safeObjects forKeys:safeKeys count:j];
}

- (instancetype)mjyp_initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key) {
            NSAssert(key, ([NSString stringWithFormat:@"attempt to insert nil key from key[%lu]", (unsigned long)i]));
            continue;
        }
        if (!obj) {
            NSAssert(obj, ([NSString stringWithFormat:@"attempt to insert nil object from objects[%lu]", (unsigned long)i]));
            continue;
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self mjyp_initWithObjects:safeObjects forKeys:safeKeys count:j];
}

@end

@implementation NSMutableDictionary (SafeUtils)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"__NSDictionaryM");
        [self swizzleMethods:class originalSelector:@selector(setObject:forKey:) swizzledSelector:@selector(mjyp_setObject:forKey:)];
        [self swizzleMethods:class originalSelector:@selector(setObject:forKeyedSubscript:) swizzledSelector:@selector(mjyp_setObject:forKeyedSubscript:)];
        [self swizzleMethods:class originalSelector:@selector(removeObjectForKey:) swizzledSelector:@selector(mjyp_removeObjectForKey:)];
    });
}

- (void)mjyp_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    NSAssert(anObject, ([NSString stringWithFormat:@"object cannot be nil (key = %@)", aKey]));
    NSAssert(aKey, ([NSString stringWithFormat:@"key cannot be nil (object = %@)", anObject]));
    
    if (anObject && aKey) {
        [self mjyp_setObject:anObject forKey:aKey];
    }
}

- (void)mjyp_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    NSAssert(key, ([NSString stringWithFormat:@"key cannot be nil (object = %@)", obj]));
    
    if (obj && key) {
        [self mjyp_setObject:obj forKeyedSubscript:key];
    }
}

- (void)mjyp_removeObjectForKey:(id)aKey {
    NSAssert(aKey, @"key cannot be nil");
    
    if (aKey) {
        [self mjyp_removeObjectForKey:aKey];
    }
}

@end
