//
//  GYBall.m
//  HitBrick
//
//  Created by zyx on 15/7/8.
//  Copyright (c) 2015年 singingCicada. All rights reserved.
//

#import "GYBall.h"

const static CGFloat kBallNormalSpeedX = 0.0;
const static CGFloat kBallNormalSpeedY = 1.0;

@interface GYBall()

@property(nonatomic, readwrite)CGFloat speedX;
@property(nonatomic, readwrite)CGFloat speedY;

-(void)move;
-(void)reverseVertical;
-(void)reverseHorizental;

@end

@implementation GYBall


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
    // Drawing code
//    CGContextRef cgref = UIGraphicsGetCurrentContext();
    
//}

- (instancetype)init{
    if (self= [super init]) {
        self.bounds = CGRectMake(0, 0, kBallDiameter, kBallDiameter);
        [self setClipsToBounds:YES];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:kBallDiameter * 0.5];
        [self setBackgroundColor:[UIColor colorWithRed:0.43 green:0.33 blue:0.37 alpha:0.89]];
    }
    return self;
}

- (void)setDirection:(BallDirection)direction{
    if (_direction != direction) {
        _direction = direction;
        switch (direction) {
            case UP:
                self.speedY = kBallNormalSpeedY;
                break;
                
            case Left:
                
                break;
                
            case Down:
                self.speedY = -kBallNormalSpeedY;
                break;
                
            case Right:
                
                break;
                
            default:
                break;
        }
    }
}

-(void)initSpeed{
    self.speedX = kBallNormalSpeedX;
    self.speedY = kBallNormalSpeedY;
}

- (void)reverseHorizental{
    self.speedX *= -1;
}

- (void)reverseVertical{
    self.speedY *= -1;
}

- (void)changeDirection{
    CGFloat radius = self.frame.size.width * 0.5;
    if (self.center.y - radius <= 0 ){
        self.direction = Down;
    }
    if (self.center.x - radius <= 0) {
        self.direction = Right;
    }
    if (self.center.x + radius >= ScreenWidth) {
        self.direction = Left;
    }
    if (self.center.y + radius >= ScreenHeight) {
        [self stop];
    }
}

- (BOOL)collideWithRect:(CGRect)rect{
    if (CGRectIntersectsRect(self.frame, rect)) {
        [self reverseVertical];
        return YES;
    }
    return NO;
}

-(void)stop{
    [self.ballTimer invalidate];
    [self.delegate ballDidStop:self];
}

-(void)move{
//    第一版本：reverse speed
//    CGFloat radius = self.frame.size.width * 0.5;
    
//    if (self.center.x - radius <= 0 || self.center.x + radius >= ScreenWidth) {
//        [self reverseHorizental];
//    }
//    
//    if (self.center.y - radius <= 0) {
//        [self reverseVertical];
//    }
    
//    if (self.center.y + radius >= ScreenHeight) {
//        [self stop];
//    }
//    第二版本：使用状态
    [self changeDirection];
    self.center = CGPointMake(self.center.x + self.speedX, self.center.y - self.speedY);
}

- (void)start{
    [self initSpeed];
    self.ballTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(move) userInfo:nil repeats:YES];
}


@end
