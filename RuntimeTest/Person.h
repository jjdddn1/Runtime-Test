//
//  Person.h
//  RuntimeTest
//
//  Created by Huiyuan Ren on 6/20/17.
//  Copyright © 2017 Huiyuan Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Creature <NSObject>
@optional
- (void)die;
@end


//  Person.h
@interface Person : NSObject <Creature> {
    int _age;
    int _num;
    char _test;
}
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy, readonly) NSString *gender;
@property (nonatomic, copy, readonly) NSString *hobby;

+ (instancetype)personWithName:(NSString *)name;

- (void)eat;
- (void)drink;

@end
