//
//  GYBall.h
//  HitBrick
//
//  Created by zyx on 15/7/8.
//  Copyright (c) 2015年 singingCicada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYDefines.h"

#define kBallDiameter 30

typedef enum Direction{
    UP, Down, Left, Right
} BallDirection;

@class GYBall;

@protocol GYBallDelegate <NSObject>

-(void)ballDidStop:(GYBall*)ball;

@end

@interface GYBall : UIView

@property (nonatomic, readonly)CGFloat speedX;
@property (nonatomic, readonly)CGFloat speedY;

@property (nonatomic, assign)BallDirection direction;

@property (nonatomic, strong)NSTimer* ballTimer;

@property (nonatomic, weak)id<GYBallDelegate> delegate;

-(void)start;
-(void)changeDirection;
-(BOOL)collideWithRect:(CGRect)rect;

@end
