//
//  AAPScene.m
//  
//
//  Created by Allen on 2024/5/12.
//

#import "AAPanoramaScene.h"
#import <CoreGraphics/CoreGraphics.h>
#import "AASphere.h"
#import "AAInputSystem.h"

typedef struct
{
    vector_float4 pos;
    vector_float4 color;
    vector_float2 coord;
} VertexData;

@interface AAPanoramaScene ()
{
    Uniforms uniform;
}

@end

@implementation AAPanoramaScene

- (instancetype)init {
    if (self=[super init]) {
        self.cameraControl = true;
        
        _sphere = [[AASphere alloc] initWithStacks:80 slices:80 radius:2.0];
    }
    return self;
}

- (void)render:(id<MTLRenderCommandEncoder>)encoder {
    [self updateUniform];
    uniform.viewMatrix = self.camera.viewMatrix;
    uniform.projectionMatrix = self.camera.projectionMatrix;
    [self.sphere render:encoder Uniforms:uniform];
    
    const VertexData vert[] =
    {
        { { 0.0, 0.3, 0.0, 1.0 }, {1, 1, 1, 1 }, { 0, 0 } },
        { {-0.3, 0.0, 0.0, 1.0 }, {1, 0, 1, 1 }, { 0, 0 } },
        { { 0.3, 0.0, 0.0, 1.0 }, {1, 1, 0, 1 }, { 0, 0 } },
    };
    [encoder setVertexBytes:&uniform length:sizeof(uniform) atIndex:1];
    [encoder setVertexBytes:vert length:sizeof(vert) atIndex:0];
    [encoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3];
}


- (void)setImageWithPath:(NSString*)filePath {
    [self.sphere loadTextureWithPath:filePath];
}

- (void)updateUniform {
    if (!self.cameraControl)
        return;
    
    AAInputSystem *input = [AAInputSystem shared];
    
    if (!CGPointEqualToPoint(input.scrollMove, CGPointZero)) {
        self.camera.distance -= (input.scrollMove.x + input.scrollMove.y) * 0.1;
        
        simd_float4x4 rotateMatrix = rotationYXZ(-self.camera.rotation.x, self.camera.rotation.y, 0);
        
        simd_float4 distanceVector = simd_make_float4(0, 0, -self.camera.distance, 0);
        simd_float4 rotatedVector = matrix_multiply(rotateMatrix, distanceVector);
        
        self.camera.position = rotatedVector.xyz;
        
    }
    if (!CGPointEqualToPoint(input.touchMove, CGPointZero)) {
        simd_float3 rot = self.camera.rotation;
        rot.x += input.touchMove.y * 0.01;
        rot.y += input.touchMove.x * 0.01;
//        NSLog(@"---%@", NSStringFromCGPoint(input.mouseDelta));
        
        float truncated = (int)(self.camera.maxRotX * 100) / 100.0f;
        
        rot.x = MAX(-truncated, MIN(rot.x, truncated));
        
        simd_float4x4 rotateMatrix = rotationYXZ(-rot.x, rot.y, 0);
        simd_float4 distanceVector = simd_make_float4(0, 0, -self.camera.distance, 0);
        simd_float4 rotatedVector = matrix_multiply(rotateMatrix, distanceVector);
        
        self.camera.position = rotatedVector.xyz;
        self.camera.rotation = rot;
    }
}


@end
