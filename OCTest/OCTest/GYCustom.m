//
//  GYCustom.m
//  OCTest
//
//  Created by zyx on 15/6/26.
//  Copyright (c) 2015年 singingcicada. All rights reserved.
//

#import "GYCustom.h"

@implementation GYCustom

+ (instancetype)defaultCustom{
//    return [self init];
    return [[self alloc] init];
}

-(instancetype)init{
    if (self = [super init]) {
//        return self;
    }
    return self;
}

+ (void)addDefaultCustom:(NSString *)name title:(NSString *)t{
    GYCustom *cc = [self init];
    [cc setName:name];
    [cc setTitle:t];
}

-(NSMutableArray*)consumers{
    if (!_consumers) {
        _consumers = [NSMutableArray array];
    }
    return _consumers;
}

-(NSString*)name{
    if (!_name) {
        _name = @"No name!";
    }
    return _name;
}

-(NSString*)title{
    if (!_title) {
        _title = @"No title!";
    }
    return _title;
}

-(void)displayName{
    NSLog(@"Custom name = %@", self.name);
}

-(void)displayTitle{
    NSLog(@"custom title = %@", self.title);
}

-(void)addConsumerWith:(GYConsumer *)consumer{
    [self.consumers addObject:consumer];
}

//-(void)setValue:(id)value forKey:(NSString *)key{
//    
//}

-(id)valueForKey:(NSString *)key{
    NSLog(@"valueforKey key: %@", key);
    if ([key isEqualToString:@"name"]) {
        return self.name;
    }else if ([key isEqualToString:@"title"]){
        return self.title;
    }
    return NULL;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@"observed person: change=%@", change);
    /*
        NSKeyValueChangeKindKey --> kind
            [to-one: NSKeyValueChangeSetting = 1, to-many: NSKeyValueChangeInsertion = 2,NSKeyValueChangeRemoval = 3,NSKeyValueChangeReplacement = 4]
        NSKeyValueChangeNewKey  --> new
        NSKeyValueChangeOldKey  --> old
        NSKeyValueChangeIndexesKey --> indexes
        NSKeyValueChangeNotificationIsPriorKey --> notificationIsPrior
     */
    if ([keyPath isEqualToString:@"name"]) {
//        NSLog(@"change=%@", change);
//        self.name = [change objectForKey:@"new"];
        self.name = [change objectForKey:NSKeyValueChangeNewKey];
    }
//    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

-(id)valueForUndefinedKey:(NSString *)key{
    return [NSString stringWithFormat:@"Undefined Key: %@", key];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    //子类重写此方法，可以修改设置一个不存在的 key 时的行为，默认会引发一个 NSUndefinedKeyException
    NSLog(@"undefined key:%@, value:%@", key, value);
}

-(void)setNilValueForKey:(NSString *)key{
    //默认行为是引发一个 NSInvalidArgumentException 的异常
    [super setNilValueForKey:key];
}

-(BOOL)validateValue:(inout __autoreleasing id *)ioValue forKey:(NSString *)inKey error:(out NSError *__autoreleasing *)outError{
    
    return YES;
}

-(void)unregisterObersver:(id)observer{
    [self removeObserver:observer forKeyPath:@"name"];
}

@end


