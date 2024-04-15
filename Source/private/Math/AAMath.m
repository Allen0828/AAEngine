//
//  AAMath.m
//  AAEngine-Demo
//
//  Created by allen on 2024/3/29.
//

#import "AAMath.h"



simd_float4x4 translation(float x, float y, float z) {
    return (simd_float4x4){
        .columns[0] = {1, 0, 0, 0},
        .columns[1] = {0, 1, 0, 0},
        .columns[2] = {0, 0, 1, 0},
        .columns[3] = {x, y, z, 1}
    };
}
simd_float4x4 scaling(float x, float y, float z) {
    return (simd_float4x4){
        .columns[0] = {x, 0, 0, 0},
        .columns[1] = {0, y, 0, 0},
        .columns[2] = {0, 0, z, 0},
        .columns[3] = {0, 0, 0, 1}
    };
}
simd_float4x4 rotationMatrix_x(float angle) {
    float cosTheta = cos(angle);
    float sinTheta = sin(angle);
    return (simd_float4x4){
        .columns[0] = {1, 0, 0, 0},
        .columns[1] = {0, cosTheta, sinTheta, 0},
        .columns[2] = {0, -sinTheta, cosTheta, 0},
        .columns[3] = {0, 0, 0, 1}
    };
}
simd_float4x4 rotationMatrix_y(float angle) {
    float cosTheta = cos(angle);
    float sinTheta = sin(angle);
    simd_float4x4 rotationMatrix = {
        .columns[0] = {cosTheta, 0, -sinTheta, 0},
        .columns[1] = {0, 1, 0, 0},
        .columns[2] = {sinTheta, 0, cosTheta, 0},
        .columns[3] = {0, 0, 0, 1}
    };
    return rotationMatrix;
}
simd_float4x4 rotationMatrix_z(float angle) {
    float cosTheta = cos(angle);
    float sinTheta = sin(angle);
    
    return (simd_float4x4){
        .columns[0] = {cosTheta, sinTheta, 0, 0},
        .columns[1] = {-sinTheta, cosTheta, 0, 0},
        .columns[2] = {0, 0, 1, 0},
        .columns[3] = {0, 0, 0, 1}
    };
}
simd_float4x4 rotation(float angle_x, float angle_y, float angle_z) {
    simd_float4x4 rotationX = rotationMatrix_x(angle_x);
    simd_float4x4 rotationY = rotationMatrix_y(angle_y);
    simd_float4x4 rotationZ = rotationMatrix_z(angle_z);
   
    return matrix_multiply(matrix_multiply(rotationX, rotationY), rotationZ);
}
simd_float4x4 rotationYXZ(float angle_x, float angle_y, float angle_z) {
    simd_float4x4 rotationX = rotationMatrix_x(angle_x);
    simd_float4x4 rotationY = rotationMatrix_y(angle_y);
    simd_float4x4 rotationZ = rotationMatrix_z(angle_z);
   
    return matrix_multiply(matrix_multiply(rotationY, rotationX), rotationZ);
}

simd_float4x4 identity(void) {
    return matrix_identity_float4x4;
}
simd_float3x3 getUpperLeft(simd_float4x4 matrix) {
    return (simd_float3x3){
        .columns[0] = {matrix.columns[0].x, matrix.columns[0].y, matrix.columns[0].z},
        .columns[1] = {matrix.columns[1].x, matrix.columns[1].y, matrix.columns[1].z},
        .columns[2] = {matrix.columns[2].x, matrix.columns[2].y, matrix.columns[2].z},
    };
}

simd_float4x4 projectionMatrix(float fov, float near, float far, float aspect) {
    float y = 1 / tan(fov * 0.5);
    float x = y / aspect;
    float z = far / (far - near);
    simd_float4x4 projectionMatrix = {
        .columns[0] = {x, 0, 0, 0},
        .columns[1] = {0, y, 0, 0},
        .columns[2] = {0, 0, z, 1},
        .columns[3] = {0, 0, z * -near, 0}
    };
    return projectionMatrix;
}



simd_float4x4 translationMatrix(float x, float y, float z) {
    return (simd_float4x4){
        .columns[0] = {1, 0, 0, 0},
        .columns[1] = {0, 1, 0, 0},
        .columns[2] = {0, 0, 1, 0},
        .columns[3] = {x, y, z, 1}
    };
}
simd_float4x4 inverseTranslationMatrix(float x, float y, float z) {
    simd_float4x4 translationMatrix = (simd_float4x4){
        .columns[0] = {1.0, 0.0, 0.0, 0.0},
        .columns[1] = {0.0, 1.0, 0.0, 0.0},
        .columns[2] = {0.0, 0.0, 1.0, 0.0},
        .columns[3] = {x, y, z, 1.0}
    };
    simd_float4x4 inverseMatrix = simd_inverse(translationMatrix);
    return inverseMatrix;
}





simd_float4x4 rotationMatrix(float x, float y, float z) {
    simd_float4x4 rotationX = rotationMatrix_x(x);
    simd_float4x4 rotationY = rotationMatrix_y(y);
    simd_float4x4 rotationZ = rotationMatrix_z(z);
    
    return simd_mul(simd_mul(rotationX, rotationY), rotationZ);
    
}




simd_float3x3 upperLeft(simd_float4x4 matrix) {
    simd_float3x3 left;
    left.columns[0] = matrix.columns[0].xyz;
    left.columns[1] = matrix.columns[1].xyz;
    left.columns[2] = matrix.columns[2].xyz;
    return left;
}

simd_float3x3 normalFrom4x4(simd_float4x4 matrix) {
    simd_float3x3 inverseMatrix = simd_inverse(upperLeft(matrix));
    return simd_transpose(inverseMatrix);
}


simd_float4x4 leftHandedLook(simd_float3 eye, simd_float3 center, simd_float3 up) {
    simd_float3 z = simd_normalize(center-eye);
    simd_float3 x = simd_normalize(simd_cross(up, z));
    simd_float3 y = simd_cross(z, x);
    
    return (simd_float4x4){
        .columns[0] = {x.x, y.x, z.x, 0},
        .columns[1] = {x.y, y.y, z.y, 0},
        .columns[2] = {x.z, y.z, z.z, 0},
        .columns[3] = {-simd_dot(x, eye), -simd_dot(y, eye), -simd_dot(z, eye), 1}
    };
}


simd_float4x4 orthographic(CGRect rect, float near, float far) {
    CGFloat left = rect.origin.x;
    CGFloat right = rect.origin.x + rect.size.width;
    CGFloat top = rect.origin.y;
    CGFloat bottom = rect.origin.y - rect.size.height;
    
    return (simd_float4x4){
        .columns[0] = {2/(right - left), 0, 0, 0},
        .columns[1] = {0, 2 / (top - bottom), 0, 0},
        .columns[2] = {0, 0, 1 / (far - near), 0},
        .columns[3] = {(left + right) / (left - right), (top + bottom) / (bottom - top), near / (near - far), 1}
    };
}




simd_float4x4 modelMatrix(Transform transform) {
    simd_float4x4 pos = translation(transform.position.x, transform.position.y, transform.position.z);
    simd_float4x4 rot = rotation(transform.rotation.x, transform.rotation.y, transform.rotation.z);
    simd_float4x4 scale = scaling(transform.scale.x, transform.scale.y, transform.scale.z);
    return matrix_multiply(matrix_multiply(pos, rot), scale);
}


