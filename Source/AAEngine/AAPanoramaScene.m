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
#import "AASphere.h"




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
        
        self.sphere = [[AASphere alloc] initWithStacks:100 slices:100 radius:2.0];
        
        simd_float4x4 pos = translation(0, 0, 0);
        simd_float4x4 rot = rotation(0, 0, 0);
        simd_float4x4 scale = scaling(1.0, 1.0, 1.0);
        uniform.modelMatrix = matrix_multiply(matrix_multiply(pos, rot), scale);
                
       
        uniform.viewMatrix = leftHandedLook(simd_make_float3(-5.0, 2.1, -1.9), simd_make_float3(0, 0, 0), simd_make_float3(0, 1, 0));
        uniform.projectionMatrix = projectionMatrix(degreesToRadians(70), 0.1, 100, 1);
        
        
//        uniform.viewMatrix = matrix_identity_float4x4;
        
//        // 视场角度（这里是45度，可以根据需要修改）
//        self.fovDegrees = 45.0;
//        float fovRadians = self.fovDegrees * (M_PI / 180.0);
//
//        self.near = 0.1;
//        self.far = 800;
//        self.aspect = 375.0/667.0;
//
//        // 创建透视投影矩阵
//        matrix_float4x4 projection = projectionMatrix(fovRadians, self.near, self.far, self.aspect);
//        uniform.projectionMatrix = projection;
    
        self.transformBuffer = [AARenderer.device newBufferWithBytes:(void*)&uniform length:sizeof(uniform) options:MTLResourceCPUCacheModeDefaultCache];
        
        
        
        [self.sphere loadTextureWithPath:fileName];
    }
    return self;
}

- (instancetype)init {
    if (self=[super init]) {
        // 创建一个球体
        
        
        
    }
    return self;
}

float timer = 0;
- (void)updateUniform {
    timer += 0.5;
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
    
    self.transformBuffer = [AARenderer.device newBufferWithBytes:(void*)&uniform length:sizeof(uniform) options:MTLResourceCPUCacheModeDefaultCache];
}

- (void)render:(id<MTLRenderCommandEncoder>)encoder {
//    [self updateUniform];
//    [encoder setVertexBuffer:self.transformBuffer offset:0 atIndex:1];
//    [encoder setVertexBytes:&uniform length:sizeof(uniform) atIndex:1];
    [self.sphere render:encoder Uniforms:uniform];
}


- (void)setImageWithName:(NSString*)fileName {
    
}


@end
