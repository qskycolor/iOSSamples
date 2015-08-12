//
//  main.m
//  OCTest
//
//  Created by zyx on 15/6/26.
//  Copyright (c) 2015年 singingcicada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "GYCustom.h"
#import "GYConsumer.h"
#import "GYCustom+BirthInfo.h"

@interface Person : NSObject

@property (nonatomic, copy)NSString* name;
@property (nonatomic, assign)NSInteger number;

-(void)displayInfo;
-(void)unregisterObersver:(id)observer;
-(instancetype)initWith:(NSString*)name number:(NSInteger)number;
+(instancetype)initWith:(NSString*)name number:(NSInteger)number;

@end

typedef void(*Callback)(dispatch_semaphore_t);


@implementation Person

-(instancetype)initWith:(NSString *)name number:(NSInteger)number{
    
    if (self = [super init]) {
        self.name = name;
        self.number = number;
        return self;
    }
    return nil;
}

+(instancetype)initWith:(NSString *)name number:(NSInteger)number{
    
//    return [[Person alloc]initWith:name number:number];
    return [[self alloc]initWith:name number:number];
}

-(void)displayInfo{
    NSLog(@"Person: name=%@, number=%ld, cmd=%@", self.name, self.number, NSStringFromSelector(_cmd));
}

-(void)dispatchAfter:(dispatch_semaphore_t)time block:(Callback) cb{
    
    sleep(3);
    cb(time);
    
}

-(void)unregisterObersver:(id)observer{
    [self removeObserver:observer forKeyPath:@"name"];
}

@end

void test(dispatch_semaphore_t a){
    printf("printf test\n");
    dispatch_semaphore_signal(a);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // associated object
        static char overviewKey;
        NSArray *array = [[NSArray alloc]
            initWithObjects:@"one", @"two", @"three", nil];
        NSString *overview = [[NSString alloc]
                              initWithFormat:@"%@", @"First three numbers"];
        
        objc_setAssociatedObject(array, &overviewKey, overview, OBJC_ASSOCIATION_RETAIN);
        
        [overview release];
//        NSLog(@"overviewKey = %c, array = %@, overview = %@", overviewKey, array, overview);
        
//        sleep(2);
        
        NSLog(@"overviewKey = %c, array = %@, overview = %@", overviewKey, array, overview);
//        [array release];
        NSString *asscociateObject = objc_getAssociatedObject(array, &overviewKey);
        NSLog(@"overviewKey = %c, array = %@, asscociateObject = %@", overviewKey, array, asscociateObject);
        if (__has_feature(OBJC_ARC_UNAVAILABLE)) {
            NSLog(@"this is mrc project");
        }else{
            NSLog(@"this is arc project");
        }
        
        GYCustom* custom = [[GYCustom alloc]init];
        [custom displayName];
        NSString* title = [custom valueForKey:@"title"];
        NSString* user  = [custom valueForKey:@"user"];
        NSLog(@"custom title = %@, undefined = %@", title, user);
        
        Method d_method = class_getInstanceMethod([GYCustom class], @selector(displayName));
        Method t_method = class_getInstanceMethod([GYCustom class], @selector(displayTitle));
        IMP    e_imp    = nil;
        IMP nimp = class_getMethodImplementation([GYCustom class], @selector(displayName));
        IMP timp = class_getMethodImplementation([GYCustom class], @selector(displayTitle));
        if (d_method && t_method) {
            e_imp = nimp;
            nimp = timp;
            timp = e_imp;
        }
//        class_addMethod(<#Class cls#>, <#SEL name#>, <#IMP imp#>, <#const char *types#>)
        method_exchangeImplementations(d_method, t_method);
        NSLog(@"swizzling method displayname:");
        [custom displayName];
        
        /**************************************KVC&KVO**************************************/
        
        Person* person = [Person initWith:@"Lucy" number:123];
        [person addObserver:custom forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        person.name = @"Lily";
        [person setName:@"John"];
        [person displayInfo];
        NSLog(@"custom name = %@", custom.name);
        
        [person unregisterObersver:custom]; // 对象销毁之前要把 observer 移除
        
//        typedef struct ClassDefs{
//            @defs(GYCustom);// this platform does not support the directive
//        }* Custtom;
//        Custtom cs;
//        cs = (Custtom)custom;
//        NSLog(@"%@", cs);
        
        for (int i=0; i<10; i++) {
            GYConsumer *consumer = [[GYConsumer alloc] initWithName:[NSString stringWithFormat:@"consumer#%d", arc4random() % 5] wealth:i * 50];
            [[custom consumers] addObject:consumer];
        }
        /*******************collection operators*******************/
        NSNumber* average = [custom.consumers valueForKeyPath:@"@avg.wealth"];
        NSNumber* amount  = [custom.consumers valueForKeyPath:@"@count"];
        NSNumber* maximum = [custom.consumers valueForKeyPath:@"@max.wealth"]; // same as min
        NSNumber* sum     = [custom.consumers valueForKeyPath:@"@sum.wealth"];
        NSLog(@"average = %@, amount = %@, maximum = %@, sum = %@", average, amount, maximum, sum); // average = 225, amount = 10
        NSNumber* distincts = [custom.consumers valueForKeyPath:@"@distinctUnionOfObjects.name"]; //removed duplicated objects
        NSNumber* unions    = [custom.consumers valueForKeyPath:@"@unionOfObjects.name"];// duplicated objects are not removed
        NSLog(@"distincts = %@, unions = %@, maximum = %@, sum = %@", distincts, unions, maximum, sum);
        
        //******* GCD: semaphore ***********
        // 如果信号量是0，那么线程会一直阻塞，直到信号量增加
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        NSLog(@"dispatch_wait before sema=%@", sema);
        // test中会调用 dispatch_semaphore_signal(sema)来增加信号量
        [person dispatchAfter:sema block:test];
        NSLog(@"dispatch_wait call test sema=%@", sema);
        // 这里会把线程阻塞，直到sema的信号量大于0
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        NSLog(@"dispatch_wait after sema=%@", sema);
        
        //使用类别添加了属性，此时用关联对象来实现存取器
        [custom setDate:123];
        [custom setPlace:@"beijing"];
        [custom showPlaceWithDate];
        
        [custom release];
        
        // class Factory method
        GYCustom* cc = [GYCustom defaultCustom];
        [cc showPlaceWithDate];
        
        //*************NSCalender**NSDate******************//
        NSCalendar* calender = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        int unitflags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | kCFCalendarUnitHour;
        
        NSDateComponents* components = [calender components:unitflags fromDate:[NSDate date]];
        
        NSLog(@"calendar=%@,components=%@", calender, components);
        /* components:
             Calendar Year: 2015
             Month: 7
             Leap month: no
             Day: 16
             Hour: 18
         */
        
        //********************NSString**************************//
        NSString* lstr = @"literal string";
        NSString* fstr = [NSString stringWithFormat:@"format string %@", lstr];
        NSString* cstr = [NSString stringWithCString:"helloworld" encoding: NSUTF8StringEncoding];
        NSString* sstr = [NSString stringWithString:cstr];
        NSString* istr = [[NSString alloc] initWithFormat:@"%@,%@", sstr, fstr];
        NSArray*  arrs = [NSArray arrayWithObjects:@"helloworld", @"kitkit", istr, nil];
        NSString* astr = [arrs componentsJoinedByString:@","];
        NSLog(@"========componets==%@", astr);
        NSArray*  sepa = [title componentsSeparatedByString:@"t"];
        NSLog(@"========separate array==%@", sepa);
        
        NSString* caseStr = @"Hello222WorlD";
        NSString* incaseStr = @"hello222world";
        //caseInsensitiveCompare返回NSComparisonResult: NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
        //不区分大小写的比较
        NSLog(@"compare result = %ld", [caseStr caseInsensitiveCompare:incaseStr]);
        
    }
    return 0;
}
