//
//  ViewController.m
//  RuntimeTest
//
//  Created by Huiyuan Ren on 6/20/17.
//  Copyright © 2017 Huiyuan Ren. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person *p1 = [Person new];
    p1.name = @"Huiyuan Ren";
    
    Person *p2 = [Person new];
    p2.name = @"Ren Huiyuan";
    
    [p1 eat];
    
    unsigned int count = 0;
    
    // get all the properties of a class
    objc_property_t *propertyList = class_copyPropertyList([p1 class], &count);
    for (unsigned int i = 0; i < count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSLog(@"property---->%@", [NSString stringWithUTF8String:propertyName]);
    }
    
    // get all the ivar of a class
    Ivar *ivarList = class_copyIvarList([p1 class], &count);
    for (unsigned int i = 0; i < count; i++) {
        Ivar myIvar = ivarList[i];
        const char *ivarName = ivar_getName(myIvar);
        NSLog(@"Ivar---->%@", [NSString stringWithUTF8String:ivarName]);
        NSLog(@"Ivar offset---->%td", ivar_getOffset(myIvar));
    }
    
    free(ivarList);
    
    // get all the method of a class
    Method *methodList = class_copyMethodList([p1 class], &count);
    for (unsigned int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSLog(@"method---->%@", NSStringFromSelector(method_getName(method)));
    }
    
    // get all the class method of a class
    Method *classMethodList = class_copyMethodList(object_getClass([p1 class]), &count);
    for (unsigned int i = 0; i < count; i++) {
        Method method = classMethodList[i];
        NSLog(@"class method---->%@", NSStringFromSelector(method_getName(method)));
    }

    // get all the protocol of a class
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([p1 class], &count);
    for (unsigned int i = 0; i < count; i++) {
        Protocol *myProtocal = protocolList[i];
        const char *protocolName = protocol_getName(myProtocal);
        NSLog(@"protocol---->%@", [NSString stringWithUTF8String:protocolName]);
    }
    
    // Update the ivar directly, even if the property is readonly / "private" (in .m file)
    NSLog(@"Before update, p1's name is: %@", p1.name);
    Ivar *ivar = class_copyIvarList([p1 class], &count);
    for (int i = 0; i < count; i++) {
        Ivar var = ivar[i];
        const char *varName = ivar_getName(var);
        NSString *name = [NSString stringWithUTF8String:varName];
        if ([name isEqualToString:@"_name"]) {
            object_setIvar(p1, var, @"Yayuan Shi");
            break;
        }
    }
    NSLog(@"After update, p1's name is: %@", p1.name);
    
    // Add a method to the class, and execute it
    class_addMethod([p1 class], @selector(laugh), (IMP)laugh, "v@:@");
    [p1 performSelector:@selector(laugh) withObject:@"himself"];
    
    // swap two instance method
    Method m1 = class_getInstanceMethod([p1 class], @selector(eat));
    Method m2 = class_getInstanceMethod([p1 class], @selector(drink));
    // Be aware that this, will swap the method implementation for all the instance of this class
    method_exchangeImplementations(m1, m2);
    [p1 eat];
    [p1 drink];
    // Don't forget to swap it back
    method_exchangeImplementations(m1, m2);
    
    
    
    ////源方法的SEL和Method
    SEL oriSEL = @selector(pee);
    Method oriMethod = class_getInstanceMethod([p1 class], oriSEL);
    ////交换方法的SEL和Method
    SEL cusSEL = @selector(newPee);
    Method cusMethod = class_getInstanceMethod([self class], cusSEL);
    // Test origin method
    [p1 performSelector:@selector(pee)];
    
    ////先尝试給源方法添加实现，这里是为了避免源方法没有实现的情况
    BOOL addSucc = class_addMethod([p1 class], oriSEL, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
    if (addSucc) {
        // 添加成功：将源方法的实现替换到交换方法的实现
        class_replaceMethod([self class], cusSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
        
    }else {
        //添加失败：说明源方法已经有实现，直接将两个方法的实现交换即可
        method_exchangeImplementations(oriMethod, cusMethod);
    }
    // test again to see if we exchanged the implementation
    [p1 performSelector:@selector(pee)];
}

void laugh(id self,SEL _cmd) {
    NSLog(@"%@ laughed", [self valueForKey:@"name"]);
}


@end
