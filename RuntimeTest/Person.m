//
//  Person.m
//  RuntimeTest
//
//  Created by Huiyuan Ren on 6/20/17.
//  Copyright © 2017 Huiyuan Ren. All rights reserved.
//

//  Person.m
#import "Person.h"
@interface Person()
@property (nonatomic, copy, readwrite) NSString *gender;
@end

@implementation Person
+ (instancetype)personWithName:(NSString *)name
{
    Person *p = [Person new];
    p.name = name;
    return p;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _name = @"Anonymous";
    }
    return self;
}

- (void)eat
{
    NSLog(@"%@", [NSString stringWithFormat:@"%@ eat", _name]);
}

- (void)drink
{
    NSLog(@"%@", [NSString stringWithFormat:@"%@ drink", _name]);
}

// "private" method
- (void)pee
{
    NSLog(@"%@", [NSString stringWithFormat:@"%@ pee", _name]);
}

@end
