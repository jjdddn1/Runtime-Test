//
//  Person+MoreEatFeature.m
//  RuntimeTest
//
//  Created by Huiyuan Ren on 6/22/17.
//  Copyright © 2017 Huiyuan Ren. All rights reserved.
//

#import "Person+MoreEatFeature.h"
#import <objc/runtime.h>

// Person+MoreEatFeature.m
@implementation Person (MoreEatFeature)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class selfClass = [self class];
        
        SEL oriSEL = @selector(eat);
        Method oriMethod = class_getInstanceMethod(selfClass, oriSEL);
        
        SEL cusSEL = @selector(newEat);
        Method cusMethod = class_getInstanceMethod(selfClass, cusSEL);
        
        BOOL addSucc = class_addMethod(selfClass,
                                       oriSEL,
                                       method_getImplementation(cusMethod),
                                       method_getTypeEncoding(cusMethod));
        if (addSucc) {
            class_replaceMethod(selfClass,
                                cusSEL,
                                method_getImplementation(oriMethod),
                                method_getTypeEncoding(oriMethod));
        } else {
            method_exchangeImplementations(oriMethod, cusMethod);
        }
    });
}

- (void)newEat {
    [self newEat];
    NSLog(@"%@ vomited up all he had eaten", self.name);
}
@end
