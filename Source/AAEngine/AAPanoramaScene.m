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

@property (assign) float fovDegrees;
@property (assign) float viewMatrixPointX;
@property (assign) float viewMatrixPointY;

@property (strong) id<MTLBuffer> transformBuffer;


@property (nonatomic,strong) AASphere *sphere;

@end

@implementation AAPanoramaScene



- (instancetype)initWithImageName:(NSString*)fileName {
    if (self=[super init]) {
        
        _camera = [[AACamera alloc] init];
        _camera.position = simd_make_float3(0.0, 5.0, -1);
        _camera.rotation = simd_make_float3(0, 0.0, 0.0);
        
        self.cameraControl = true;
        
        
        self.sphere = [[AASphere alloc] initWithStacks:100 slices:100 radius:2.0];
        [self.sphere loadTextureWithPath:fileName];
        self.sphere.rotation = simd_make_float3(degreesToRadians(180), 0, 0);
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
    AAInputSystem *input = [AAInputSystem shared];
    
//    if (!CGPointEqualToPoint(input.mouseScroll, CGPointZero)) {
//        self.camera.distance -= (input.mouseScroll.x + input.mouseScroll.y) * 0.1;
//        input.mouseScroll = CGPointZero;
//        
//        simd_float4x4 rotateMatrix = rotationYXZ(-self.camera.rotation.x, self.camera.rotation.y, 0);
//        
//        simd_float4 distanceVector = simd_make_float4(0, 0, -self.camera.distance, 0);
//        simd_float4 rotatedVector = matrix_multiply(rotateMatrix, distanceVector);
//        
//        self.camera.position = rotatedVector.xyz;
//        
//    }
    if (!CGPointEqualToPoint(input.mouseDelta, CGPointZero)) {
        simd_float3 rot = self.camera.rotation;
        rot.x += input.mouseDelta.y * 0.01;
        rot.y += input.mouseDelta.x * 0.01;
//        NSLog(@"---%@", NSStringFromCGPoint(input.mouseDelta));
        rot.x = MAX(-1.57, MIN(rot.x, 1.57));
        input.mouseDelta = CGPointZero;
        
        NSLog(@"pi = %.6f", M_PI/2.0);
        NSLog(@"%.6f", rot.x);
        
        simd_float4x4 rotateMatrix = rotationYXZ(-rot.x, rot.y, 0);
        simd_float4 distanceVector = simd_make_float4(0, 0, 1.0, 0);
        simd_float4 rotatedVector = matrix_multiply(rotateMatrix, distanceVector);
        
        self.camera.position = rotatedVector.xyz;
        self.camera.rotation = rot;
    }
    
//    float degrees = 45.0 + timer;
//    float radians = degrees * (M_PI / 180.0);
//
//    matrix_float4x4 trans = translation(0, 0, 1.5);
//    matrix_float4x4 rot = rotation(0, radians, 0);
//    matrix_float4x4 modelMatrix = matrix_multiply(trans, rot);
//    uniform.modelMatrix = modelMatrix;
    
    
//    InputController *input = [InputController shareInstance];
//    CGFloat zoom = (input->mouseScroll.x + input->mouseScroll.y) * 0.6;
//    // 方法1
////    uniform.modelMatrix.columns[3][2] += zoom;
//    // 方法2
//    self.fovDegrees += zoom;
//    input->mouseScroll = CGPointZero;
//
//    if (!NSEqualPoints(input->mouseDelta, CGPointZero)) {
//        self.viewMatrixPointX += input->mouseDelta.x * 0.1;
//        self.viewMatrixPointY += input->mouseDelta.y * 0.1;
//
//        uniform.viewMatrix = rotation_matrix(self.viewMatrixPointY, self.viewMatrixPointX, 0);
//        input->mouseDelta = CGPointZero;
//    }
    
//    float fovRadians = self.fovDegrees * (M_PI / 180.0);
//    matrix_float4x4 projection = projectionMatrix(fovRadians, self.near, self.far, self.aspect);
//    uniform.projectionMatrix = projection;

}



@end
