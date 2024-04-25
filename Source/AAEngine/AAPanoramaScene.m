//
//  AAPanoramaScene.m
//  AAEngine-Demo
//
//  Created by allen on 2024/4/22.
//

#import "AAPanoramaScene.h"
#import <MetalKit/MetalKit.h>
#import "AAMath.h"
#import "AARenderer.h"
#import "AACamera.h"
#import "AASphere.h"
#import "AAInputSystem.h"


@interface AAPanoramaScene ()
{
    Uniforms uniform;
}

@end

@implementation AAPanoramaScene



- (instancetype)init {
    if (self=[super init]) {
        
        _camera = [[AACamera alloc] init];
        _camera.position = simd_make_float3(0.0, 5.0, -1);
        _camera.rotation = simd_make_float3(0, 0.0, 0.0);
        
        self.cameraControl = true;
        
        _sphere = [[AASphere alloc] initWithStacks:48 slices:48 radius:2.0];
        _sphere.rotation = simd_make_float3(degreesToRadians(180), 0, 0);
    }
    return self;
}

- (void)render:(id<MTLRenderCommandEncoder>)encoder {
    [self updateUniform];
    uniform.viewMatrix = self.camera.viewMatrix;
    uniform.projectionMatrix = self.camera.projectionMatrix;
    
    [self.sphere render:encoder Uniforms:uniform];
    
}


- (void)setImageWithPath:(NSString*)filePath {
    [self.sphere loadTextureWithPath:filePath];
}


- (void)updateUniform {
    if (!self.cameraControl)
        return;
    
    AAInputSystem *input = [AAInputSystem shared];
    
    if (!CGPointEqualToPoint(input.scrollMove, CGPointZero)) {
        self.camera.distance -= (input.scrollMove.x + input.scrollMove.y);
        
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
