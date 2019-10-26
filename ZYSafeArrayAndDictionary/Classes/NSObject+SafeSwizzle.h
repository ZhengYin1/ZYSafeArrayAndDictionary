//
//  NSObject+SafeSwizzle.h
//  MJYPCore
//
//  Created by zhengyin on 2019/10/22.
//  Copyright © 2019 xiaomi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SafeSwizzle)

- (void)swizzleMethod:(SEL)origSel withMethod:(SEL)altSel;

+ (void)swizzleMethods:(Class)curClass originalSelector:(SEL)origSel swizzledSelector:(SEL)swizSel;

@end

NS_ASSUME_NONNULL_END
