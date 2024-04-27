//
//  AACamera.h
//  AAEngine-Demo
//
//  Created by allen on 2024/4/23.
//

#import <Foundation/Foundation.h>
#import "Basic/AATransform.h"


@interface AACamera : AATransform


/// 宽高比 默认1
@property (nonatomic,assign) float aspect;
@property (nonatomic,assign) float fov;
@property (nonatomic,assign) float far;
@property (nonatomic,assign) float near;
/// 相机距离
@property (nonatomic,assign) float distance;
/// 相机上下翻转的最大值  默认 正负 (M_PI_2)
@property (nonatomic,assign) float maxRotX;

@property (nonatomic,assign,readonly) simd_float4x4 viewMatrix;
@property (nonatomic,assign,readonly) simd_float4x4 projectionMatrix;

@end


