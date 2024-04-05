//
//  AACamera.h
//  AAEngine-Demo
//
//  Created by allen on 2024/3/28.
//

#import <Foundation/Foundation.h>
#import "AAMath.h"



@interface AACamera : NSObject

/// 显示宽高比    
@property (nonatomic,assign) CGFloat aspect;
/// degreesToRadians(70)
@property (nonatomic,assign) CGFloat fov;
// 500
@property (nonatomic,assign) CGFloat far;
// 0.1
@property (nonatomic,assign) CGFloat near;

@property (nonatomic,assign) simd_float3 pos;
@property (nonatomic,assign) simd_float3 rot;
@property (nonatomic,assign, readonly) simd_float4x4 viewMatrix;
@property (nonatomic,assign, readonly) simd_float4x4 projectionMatrix;



@end
