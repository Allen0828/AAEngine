//
//  AAInputSystem.m
//  AAEngine-Demo
//
//  Created by allen on 2024/4/23.
//

#import "AAInputSystem.h"

@interface AAInputSystem ()

@property (nonatomic,assign) CGFloat cursor_x;
@property (nonatomic,assign) CGFloat cursor_y;
@property (nonatomic,assign) CGPoint previousTranslation;
@property (nonatomic,assign) CGFloat previousScroll;
@property (nonatomic,assign) CGFloat scroll_x;


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
        self.previousScroll = 1.0;
    }
    return self;
}

- (CGPoint)touchMove {
    CGPoint move = CGPointMake(self.cursor_x, self.cursor_y);
    return move;
}
- (CGPoint)scrollMove {
    return CGPointMake(self.scroll_x, 0.0);;
}

- (void)setCursor:(CGFloat)x Y:(CGFloat)y {
    self.cursor_x = x - self.previousTranslation.x;
    self.cursor_y = y - self.previousTranslation.y;
    self.previousTranslation = CGPointMake(x, y);
}

- (void)setScroll:(CGFloat)scroll {
    CGFloat change = scroll - self.previousScroll;
    self.scroll_x = change * 0.1;
    self.previousScroll = scroll;
}

- (void)setType:(MoveType)type {
    _type = type;
    if (type == End) {
        self.previousTranslation = CGPointZero;
        self.cursor_x = 0;
        self.cursor_y = 0;
        self.previousScroll = 1.0;
    }
}

@end


