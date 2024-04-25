//
//  AACamera.m
//  AAEngine-Demo
//
//  Created by allen on 2024/4/23.
//

#import "AACamera.h"
#import "AAMath.h"

@interface AACamera ()

@end

@implementation AACamera

- (simd_float4x4)projectionMatrix {
    return projectionMatrix(self.fov, self.near, self.far, self.aspect);
}
- (simd_float4x4)viewMatrix {
    return leftHandedLook(self.position, simd_make_float3(0, 0, 0), simd_make_float3(0, 1, 0));
}

- (instancetype)init {
    if (self=[super init]) {
        self.aspect = 1;
        self.fov = degreesToRadians(70);
        self.near = 0.1;
        self.far = 500;
        self.distance = 1.5;
        self.maxRotX = M_PI_2;
    }
    return self;
}




@end
