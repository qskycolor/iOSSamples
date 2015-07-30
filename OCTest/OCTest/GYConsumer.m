//
//  GYConsumer.m
//  OCTest
//
//  Created by zyx on 15/7/7.
//  Copyright (c) 2015年 singingcicada. All rights reserved.
//

#import "GYConsumer.h"

@implementation GYConsumer

-(instancetype)initWithName:(NSString*)name wealth:(NSInteger)wealth{
    if (self = [super init]) {
        self.name = name;
        self.wealth = wealth;
        return self;
    }
    return nil;
}

-(void)displayInfo{
    NSLog(@"consumer: name = %@, wealth = %ld", self.name, self.wealth);
}

@end
