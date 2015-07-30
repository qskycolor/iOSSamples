//
//  ViewController.m
//  DragView：实现支付宝主界面长按图标后拖动能够使图标自动排序
//
//  Created by zyx on 15/7/9.
//  Copyright (c) 2015年 singingCicada. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong)UIView* dragView;
@property (nonatomic, assign)CGPoint startPoint;
@property (nonatomic, strong)NSMutableArray* images;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.images = [@[] mutableCopy];//数组使用前一定要初始化
    [self initUI];
}

-(void)initUI{
    for (int i=0; i<16; i++) {;
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(12 + i%4 * 90, 80 + i/4 * 90, 80, 80)];
        iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_face%d.png", i]];
        [self.images addObject:iv];
        iv.userInteractionEnabled = YES; //ImageView 默认不开启触摸事件
        UIGestureRecognizer* gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [iv addGestureRecognizer:gesture];
        [self.view addSubview:iv];
    }
}

-(UIImageView *)pickPlaceView:(UIView *)dv pressView:(UIImageView *)pv{
    for (UIImageView* iv in self.images) {
        if (CGRectContainsPoint(iv.frame, dv.center) && iv != pv) {
            return iv;
        }
    }
    //可以用枚举器来遍历数组
    /*
    [self.images enumerateObjectsUsingBlock:^(UIImageView* iv, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(iv.frame, dv.center) && iv != pv) {
            [self.images removeObject:iv];
            [self.images insertObject:iv atIndex: idx];
            [self updateUI];
            *stop = YES;
        }
    }];
     */
    return nil;
}

-(void)updateUI{
    [UIView animateWithDuration:0.4 animations:^{
        for (int i=0;i < self.images.count;i++) {
            UIImageView* iv = [self.images objectAtIndex:i];
            iv.frame = CGRectMake(12 + i%4 * 90, 80 + i/4 * 90, 80, 80);
        }
    }];
}

-(void)longPressAction:(UILongPressGestureRecognizer *)sender{
    UIImageView* iv = (UIImageView *)sender.view;
    CGPoint pt = [sender locationInView:self.view];
    UIImageView* pickView = nil;
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            self.startPoint = iv.center;
            iv.alpha = 0;
            self.dragView = [[UIImageView alloc] initWithImage:iv.image];
            self.dragView.frame = iv.frame;
            self.dragView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            [self.view addSubview:self.dragView];
            break;
            
        case UIGestureRecognizerStateChanged:
            self.dragView.center = pt;
            pickView = [self pickPlaceView:self.dragView pressView:iv];
            if (pickView) {
                //删除images中的iv之前把index保存下来，否则插入相邻的位置后index不会增加
                NSInteger pickIndex = [self.images indexOfObject:pickView];
                [self.images removeObject:iv];
                [self.images insertObject:iv atIndex: pickIndex];
                [self updateUI];
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            //放在{}中，下面的代码才能调用，否则会报编译错误：Switch case is in protected scope
            {
                [UIView animateWithDuration:.2 animations:^{
                    self.dragView.center = iv.center;
                    self.dragView.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    iv.alpha = 1;
                    [self.dragView removeFromSuperview];
                }];
            }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
