//
//  AAInputSystem.m
//  AAEngine-Demo
//
//  Created by allen on 2024/4/23.
//

#import "AAInputSystem.h"
#import <CoreGraphics/CoreGraphics.h>

@interface AAInputSystem ()

@property (nonatomic,assign) CGFloat cursor_x;
@property (nonatomic,assign) CGFloat cursor_y;
@property (nonatomic,assign) CGPoint previousTranslation;


@property (nonatomic,assign) CGFloat scroll_x;
@property (nonatomic,assign) CGFloat scroll_y;
@property (nonatomic,assign) CGPoint previousScroll;

@end

static id _instance = nil;

@implementation AAInputSystem

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self=[super init]) {
        self.previousScroll = CGPointMake(1.0, 1.0);
    }
    return self;
}

- (CGPoint)touchMove {
    CGPoint move = CGPointMake(self.cursor_x, self.cursor_y);
    return move;
}
- (CGPoint)scrollMove {
    CGPoint scroll = CGPointMake(self.scroll_x, self.scroll_y);
    
    return scroll;
}

- (void)setCursorX:(CGFloat)x Y:(CGFloat)y {
#if TARGET_OS_IPHONE
    self.cursor_x = x - self.previousTranslation.x;
    self.cursor_y = y - self.previousTranslation.y;
#else
    self.cursor_x = x;
    self.cursor_y = y;
#endif
    self.previousTranslation = CGPointMake(x, y);
}

- (void)setScrollX:(CGFloat)x Y:(CGFloat)y {
#if TARGET_OS_IPHONE
    self.scroll_x = x - self.previousScroll.x;
    self.scroll_y = y - self.previousScroll.y;
#else
    self.scroll_x = x;
    self.scroll_y = y;
#endif
    self.previousScroll = CGPointMake(x, y);
}

- (void)setType:(MoveType)type {
    _type = type;
    if (type == End) {
        self.previousTranslation = CGPointZero;
        self.previousScroll = CGPointMake(1.0, 1.0);
        self.cursor_x = 0;
        self.cursor_y = 0;
    }
}

@end


