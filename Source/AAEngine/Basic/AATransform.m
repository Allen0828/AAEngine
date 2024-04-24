//
//  AATransform.m
//  AAEngine-Demo
//
//  Created by allen on 2024/4/23.
//

#import "AATransform.h"
#import "AAMath.h"

@implementation AATransform

- (instancetype)init {
    if (self=[super init]) {
        _position = simd_make_float3(0, 0, 0);
        _rotation = simd_make_float3(0, 0, 0);
        _scale = simd_make_float3(1, 1, 1);
    }
    return self;
}

- (matrix_float4x4)modelMatrix {
    matrix_float4x4 trans = Translation_float4x4(_position);
    matrix_float4x4 rotation = Rotation_float4x4(_rotation);
    matrix_float4x4 scale = Scale_float4x4(_scale);
    matrix_float4x4 modelMatrix = matrix_multiply(trans, matrix_multiply(rotation, scale));
    return modelMatrix;
}



@end
