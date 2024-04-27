//
//  AAInputSystem.h
//  AAEngine-Demo
//
//  Created by allen on 2024/4/23.
//

#import <Foundation/Foundation.h>

typedef enum {
    Begin,
    Move,
    End
} MoveType;

@interface AAInputSystem : NSObject

@property (nonatomic,assign,readonly) CGPoint touchMove;
@property (nonatomic,assign,readonly) CGPoint scrollMove;

@property (nonatomic,assign) MoveType type;


+ (instancetype)shared;

- (void)setCursorX:(CGFloat)x Y:(CGFloat)y;
- (void)setScrollX:(CGFloat)x Y:(CGFloat)y;


@end


