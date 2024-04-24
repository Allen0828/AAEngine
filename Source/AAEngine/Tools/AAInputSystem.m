//
//  AAInputSystem.m
//  AAEngine-Demo
//
//  Created by allen on 2024/4/23.
//

#import "AAInputSystem.h"


static id _instance = nil;

@implementation AAInputSystem

+ (id)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self=[super init]) {
        
//        _mouseDelta = CGPointZero;
//        _mouseScroll = CGPointZero;
    }
    return self;
}


@end


