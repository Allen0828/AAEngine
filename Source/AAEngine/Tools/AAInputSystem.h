//
//  AAInputSystem.h
//  AAEngine-Demo
//
//  Created by allen on 2024/4/23.
//

#import <UIKit/UIKit.h>

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

- (void)setCursor:(CGFloat)x Y:(CGFloat)y;
- (void)setScroll:(CGFloat)scroll;


@end


