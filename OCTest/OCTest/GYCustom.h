//
//  GYCustom.h
//  OCTest
//
//  Created by zyx on 15/6/26.
//  Copyright (c) 2015年 singingcicada. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GYConsumer;

@interface GYCustom : NSObject

@property (nonatomic, copy)NSString* name;
@property (nonatomic, copy)NSString* title;

@property (nonatomic, strong)NSMutableArray* consumers;

-(void)displayName;
-(void)displayTitle;
-(void)addConsumerWith:(GYConsumer*)consumer;
-(void)unregisterObersver:(id)observer;

+(instancetype)defaultCustom;
+(void)addDefaultCustom:(NSString*)name title:(NSString*)t;

@end
