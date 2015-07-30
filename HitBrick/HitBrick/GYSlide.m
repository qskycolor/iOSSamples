//
//  GYSlide.m
//  HitBrick
//
//  Created by zyx on 15/7/8.
//  Copyright (c) 2015年 singingCicada. All rights reserved.
//

#import "GYSlide.h"
#import "GYBall.h"


@interface GYSlide()

@end

@implementation GYSlide

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init{
    if (self = [super init]) {
        [self.layer setMasksToBounds:YES];
        self.bounds = CGRectMake(0, 0, kSlideWidth, kSlideHeight);
        [self.layer setCornerRadius:kSlideHeight * 0.55];
        [self.layer setBackgroundColor:[UIColor purpleColor].CGColor];
        [self setBackgroundColor:[UIColor colorWithRed:0.23 green:0.33 blue:0.33 alpha:0.89]];        
    }
    return self;
}

@end
