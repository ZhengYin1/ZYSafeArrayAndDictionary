//
//  NSArray+SafeUtils.m
//  MJYPCore
//
//  Created by zhengyin on 2019/10/21.
//  Copyright © 2019 xiaomi. All rights reserved.
//

#import "NSArray+SafeUtils.h"
#import "NSObject+SafeSwizzle.h"
#import <objc/runtime.h>

@implementation NSArray (SafeUtils)

#define ArrayObjectAtIndexProtect(arrayName) \
- (id)mjyp_##arrayName##_objectAtIndex:(NSUInteger)index {\
    NSAssert([self count] > 0,      ([NSString stringWithFormat:@"index %lu beyond bounds for empty array", (unsigned long)index]));\
    NSAssert(index < [self count],  ([NSString stringWithFormat:@"index %lu beyond bounds [0...%lu]", (unsigned long)index, (unsigned long)[self count] - 1]));\
    if (index < self.count) {\
        return [self mjyp_##arrayName##_objectAtIndex:index];\
    }\
    return nil;\
}\
- (id)mjyp_##arrayName##_objectAtIndexedSubscript:(NSUInteger)index {\
    NSAssert([self count] > 0,      ([NSString stringWithFormat:@"index %lu beyond bounds for empty array", (unsigned long)index]));\
    NSAssert(index < [self count],  ([NSString stringWithFormat:@"index %lu beyond bounds [0...%lu]", (unsigned long)index, (unsigned long)[self count] - 1]));\
    if (index < self.count) {\
        return [self mjyp_##arrayName##_objectAtIndexedSubscript:index];\
    }\
    return nil;\
}

#define ArrayObjectSwizzleMethods(arrayName) \
[self swizzleMethods:objc_getClass(#arrayName) originalSelector:@selector(objectAtIndex:) swizzledSelector:@selector(mjyp_##arrayName##_objectAtIndex:)];\
[self swizzleMethods:objc_getClass(#arrayName) originalSelector:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(mjyp_##arrayName##_objectAtIndexedSubscript:)];

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ArrayObjectSwizzleMethods(__NSArray0);
        ArrayObjectSwizzleMethods(__NSArrayI);
        ArrayObjectSwizzleMethods(__NSCFArray);
        ArrayObjectSwizzleMethods(__NSArrayM);
        ArrayObjectSwizzleMethods(__NSSingleObjectArrayI);
        
        Class class = objc_getClass("__NSPlaceholderArray");
        [self swizzleMethods:class originalSelector:@selector(initWithObjects:count:) swizzledSelector:@selector(mjyp_initWithObjects:count:)];
    });
}

#pragma mark - crash保护 objectAtIndex:和objectAtIndexedSubscript:
ArrayObjectAtIndexProtect(__NSArray0);
ArrayObjectAtIndexProtect(__NSArrayI);
ArrayObjectAtIndexProtect(__NSCFArray);
ArrayObjectAtIndexProtect(__NSArrayM);
ArrayObjectAtIndexProtect(__NSSingleObjectArrayI);

#pragma mark - 数组字面量赋值保护
- (instancetype)mjyp_initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt {
    id safeObjects[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id obj = objects[i];
        if (!obj) {
            NSAssert(obj, ([NSString stringWithFormat:@"attempt to insert nil object from objects[%lu]", (unsigned long)i]));
            continue;
        }
        safeObjects[j] = obj;
        j++;
    }
    return [self mjyp_initWithObjects:safeObjects count:j];
}

@end

@implementation NSMutableArray (SafeUtils)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = objc_getClass("__NSArrayM");
        [self swizzleMethods:class originalSelector:@selector(insertObject:atIndex:) swizzledSelector:@selector(mjyp_insertObject:atIndex:)];
        [self swizzleMethods:class originalSelector:@selector(addObject:) swizzledSelector:@selector(mjyp_addObject:)];
        [self swizzleMethods:class originalSelector:@selector(replaceObjectAtIndex:withObject:) swizzledSelector:@selector(mjyp_replaceObjectAtIndex:withObject:)];
        [self swizzleMethods:class originalSelector:@selector(removeObjectAtIndex:) swizzledSelector:@selector(mjyp_removeObjectAtIndex:)];
    });
}

- (void)mjyp_insertObject:(id)anObject atIndex:(NSUInteger)index {
    NSAssert(anObject, @"object cannot be nil");
    NSAssert(index <= [self count], ([NSString stringWithFormat:@"index %lu beyond bounds [0...%lu]", (unsigned long)index, (unsigned long)[self count] -1]));
    
    if (anObject && index <= self.count) {
        [self mjyp_insertObject:anObject atIndex:index];
    }
}

- (void)mjyp_addObject:(id)anObject {
    NSAssert(anObject,  @"object cannot be nil");
    
    if (anObject) {
        [self mjyp_addObject:anObject];
    }
}

- (void)mjyp_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    NSAssert(anObject, @"object cannot be nil");
    NSAssert([self count] > 0, ([NSString stringWithFormat:@"index %lu beyond bounds for empty array", (unsigned long)index]));
    NSAssert(index < [self count], ([NSString stringWithFormat:@"index %lu beyond bounds [0...%lu]", (unsigned long)index, (unsigned long)[self count] - 1]));
    
    if (anObject && index < [self count]) {
        [self mjyp_replaceObjectAtIndex:index withObject:anObject];
    }
}

- (void)mjyp_removeObjectAtIndex:(NSUInteger)index {
    NSAssert([self count] > 0, ([NSString stringWithFormat:@"index %lu beyond bounds for empty array", (unsigned long)index]));
    NSAssert(index < [self count], ([NSString stringWithFormat:@"index %lu beyond bounds [0...%lu]", (unsigned long)index, (unsigned long)[self count] - 1]));
    
    if (index < [self count]) {
        [self mjyp_removeObjectAtIndex:index];
    }
}

@end
