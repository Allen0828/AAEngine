//
//  AACamera.m
//  AAEngine-Demo
//
//  Created by allen on 2024/3/28.
//

#import <Foundation/Foundation.h>
#import "AACamera.h"
#import "AAMath.h"

@interface AACamera ()
{
    float minDistance;
    float maxDistance;
    float distance;
    
    simd_float3 target;
}


@end

@implementation AACamera

- (simd_float4x4)projectionMatrix {
    return projectionMatrix(fov, near, far, aspect);
}
- (simd_float4x4)viewMatrix {
    return leftHandedLook(transform.position, target, simd_make_float3(0, 1, 0));
}

- (instancetype)init {
    if (self=[super init]) {
        transform.position = simd_make_float3(0, 0, 0);
        transform.rotation = simd_make_float3(0, 0, 0);
        transform.scale = 1;
        
        aspect = 1;
        fov = degreesToRadians(70);
        near = 0.1;
        far = 100;
        
        minDistance = 0.0;
        maxDistance = 20;
        distance = 2.5;
        target = simd_make_float3(0, 0, 0);
    }
    return self;
}

- (void)setPos:(simd_float3)pos {
    _pos = pos;
    transform.position = pos;
}
- (void)setRot:(simd_float3)rot {
    _rot = rot;
    transform.rotation = rot;
}


- (void)update {
//    InputController *vc = [InputController shareInstance];
//    if (!CGPointEqualToPoint(vc->mouseScroll, CGPointZero)) {
//        NSLog(@"111 %@", NSStringFromPoint(vc->mouseScroll));
//    }
//    distance -= (vc->mouseScroll.x + vc->mouseScroll.y) * 0.1;
//    distance = MIN(maxDistance, distance);
//    distance = MAX(minDistance, distance);
//    vc->mouseScroll = CGPointZero;
//    
//    if (vc->leftMouseDown && !CGPointEqualToPoint(vc->mouseDelta, CGPointZero)) {
//        NSLog(@"---%@", NSStringFromPoint(vc->mouseDelta));
//        transform.rotation.x += vc->mouseDelta.y * 0.01;
//        transform.rotation.y += vc->mouseDelta.x * 0.01;
//        
//        transform.rotation.x = MAX(-M_PI/2.0, MIN(transform.rotation.x, M_PI/2.0));
//        vc->mouseDelta = CGPointZero;
//    }
//    simd_float4x4 rotateMatrix = rotationYXZ(-transform.rotation.x, transform.rotation.y, 0);
//    simd_float4 distanceVector = simd_make_float4(0, 0, -distance, 0);
//    simd_float4 rotatedVector = matrix_multiply(rotateMatrix, distanceVector);
//    
//    transform.position = target + rotatedVector.xyz;
}

@end
