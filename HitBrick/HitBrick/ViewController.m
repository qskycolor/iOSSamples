//
//  ViewController.m
//  HitBrick
//
//  Created by zyx on 15/7/8.
//  Copyright (c) 2015年 singingCicada. All rights reserved.
//

#import "ViewController.h"
#import "GYBrick.h"
#import "GYBall.h"
#import "GYSlide.h"
#import "GYDefines.h"

@interface ViewController () <GYBallDelegate>

@property (nonatomic, strong)NSMutableArray* bricks;
@property (nonatomic, strong)GYBall* ball;
@property (nonatomic, assign)CGPoint startPoint;
@property (nonatomic, strong)GYSlide* slide;
@property (nonatomic, strong)NSTimer* detectTimer;

@property (weak, nonatomic) IBOutlet UIButton *startButton;

-(void)detectCollide;
-(void)initBricksWith:(NSInteger)amount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bricks = [NSMutableArray array];
    self.slide  = [[GYSlide alloc] init];
    [self.view addSubview:self.slide];
    self.ball = [[GYBall alloc] init];
    self.ball.delegate = self;
    [self.view addSubview:self.ball];
}

-(void)initPosition{
    self.slide.center = CGPointMake(ScreenWidth * .5, ScreenHeight * .95);
    CGFloat delta = (kBallDiameter + kSlideHeight) * .5;
    self.ball.center  = CGPointMake(self.slide.center.x, self.slide.center.y - delta);
}

-(void)initGame{
    [self initPosition];
    self.detectTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(detectCollide) userInfo:nil repeats:YES];
    [self initBricksWith:14];
}

- (void)ballDidStop:(GYBall *)ball{
    NSLog(@" detectTimer invalidate");
    [self.detectTimer invalidate];
    self.startButton.alpha = 1;
    for (GYBrick* brick in self.bricks) {
        [brick removeFromSuperview];
    }
    [self.bricks removeAllObjects];
    [self initGame];
}

-(void)detectCollide{
    NSMutableArray* tmp = [self.bricks mutableCopy];
    for (GYBrick* brick in tmp) {
        if ([self.ball collideWithRect:brick.frame]) {
            [self.bricks removeObject:brick];
            [brick removeFromSuperview];
        }
    }
    if ([self.ball collideWithRect:self.slide.frame]) {
        self.ball.direction = UP;
    }
}

- (void)initBricksWith:(NSInteger)amount{
    for (int i=0; i<amount; i++) {
        GYBrick* brick = [[GYBrick alloc] initWithFrame:CGRectMake(10 + i % 7 * 51, 100+ 45* floor(i/7), 50, 40)];
        [brick setBackgroundColor:[UIColor redColor]];
        [self.bricks addObject:brick];
        [self.view addSubview:brick];
    }
}

- (IBAction)startGame:(UIButton *)sender {
    [self.ball start];
    sender.alpha = 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    self.startPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self.view];
    CGFloat delta = pt.x - self.startPoint.x;
    self.slide.center = CGPointMake(self.slide.center.x + delta, self.slide.center.y);
    if (self.slide.center.x + kSlideWidth * .5 >= ScreenWidth) {
        self.slide.center = CGPointMake(ScreenWidth - kSlideWidth * .5, self.slide.center.y);
    }
    
    if (self.slide.center.x - kSlideWidth * .5 <= 0) {
        self.slide.center = CGPointMake(kSlideWidth * .5, self.slide.center.y);
    }
    self.startPoint = pt;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
