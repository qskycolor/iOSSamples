//
//  GYConsumer.h
//  OCTest
//
//  Created by zyx on 15/7/7.
//  Copyright (c) 2015年 singingcicada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYConsumer : NSObject

@property (nonatomic, copy)NSString* name;
@property (nonatomic, assign)NSInteger wealth;

-(void)displayInfo;
-(instancetype)initWithName:(NSString*)name wealth:(NSInteger)wealth;

@end
