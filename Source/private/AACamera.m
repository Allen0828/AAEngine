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
    simd_float3 target;
    Transform transform;
}


@end

@implementation AACamera

- (simd_float4x4)projectionMatrix {
    return projectionMatrix(self.fov, self.near, self.far, self.aspect);
}
- (simd_float4x4)viewMatrix {
    return leftHandedLook(transform.position, target, simd_make_float3(0, 1, 0));
}

- (instancetype)init {
    if (self=[super init]) {
        transform.position = simd_make_float3(0, 0, 0);
        transform.rotation = simd_make_float3(0, 0, 0);
        transform.scale = 1;
        
        self.aspect = 1;
        self.fov = degreesToRadians(70);
        self.near = 0.1;
        self.far = 100;
        
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



@end
