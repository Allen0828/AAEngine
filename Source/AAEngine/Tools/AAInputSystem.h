//
//  AAInputSystem.h
//  AAEngine-Demo
//
//  Created by allen on 2024/4/23.
//

#import <Foundation/Foundation.h>

@interface AAInputSystem : NSObject

@property (nonatomic,assign) CGPoint mouseDelta;
@property (nonatomic,assign) CGPoint mouseScroll;

+ (id)shared;

@end


