//
//  GYCustom+BirthInfo.h
//  OCTest
//
//  Created by zyx on 15/7/14.
//  Copyright (c) 2015年 singingcicada. All rights reserved.
//

#import "GYCustom.h"

@interface GYCustom (BirthInfo)

@property (nonatomic, assign)NSInteger date;
@property (nonatomic, copy)NSString* place;

-(void)showPlaceWithDate;

@end
