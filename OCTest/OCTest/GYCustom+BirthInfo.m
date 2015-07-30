//
//  GYCustom+BirthInfo.m
//  OCTest
//
//  Created by zyx on 15/7/14.
//  Copyright (c) 2015年 singingcicada. All rights reserved.
//

#import "GYCustom+BirthInfo.h"
#import <objc/runtime.h>

const char* placeObjectKey;
const char* dateObjectKey;

@implementation GYCustom (BirthInfo)

- (void)showPlaceWithDate{
    NSLog(@"custom date: %ld, place: %@", self.date, self.place);
}

// If no accessor, the compiler will complain:
// Property 'place' requires method 'setDate:' to be defined
// -use @dynamic or provide a method implementation in this category

- (void)setPlace:(NSString *)place{
    objc_setAssociatedObject(self, &placeObjectKey, place, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setDate:(NSInteger)date{
    return objc_setAssociatedObject(self, &dateObjectKey,[NSNumber numberWithLong:date], OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)date{
    return [objc_getAssociatedObject(self, &dateObjectKey) longValue];
}

- (NSString *)place{
    return objc_getAssociatedObject(self, &placeObjectKey);
}

- (void)dealloc{
    NSLog(@"dealloc=====birthinfo:%ld,%@", self.date, self.place);
    objc_setAssociatedObject(self, &dateObjectKey, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, &placeObjectKey, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    NSLog(@"dealloc=====birthinfo:%ld,%@", self.date, self.place);
}


@end
