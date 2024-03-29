//
//  AACamera.h
//  AAEngine-Demo
//
//  Created by allen on 2024/3/28.
//

#import <Foundation/Foundation.h>
#import "AAMath.h"



@interface AACamera : NSObject
{
    @public
    Transform transform;
    CGFloat aspect;
    CGFloat fov;
    float far;
    float near;
}
@property (nonatomic,assign) simd_float3 pos;
@property (nonatomic,assign) simd_float3 rot;
@property (nonatomic,assign, readonly) simd_float4x4 viewMatrix;
@property (nonatomic,assign, readonly) simd_float4x4 projectionMatrix;

- (void)update;

@end
