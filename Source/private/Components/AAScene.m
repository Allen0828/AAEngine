//
//  AAScene.m
//  
//
//  Created by Allen on 2024/5/12.
//

#import "AAScene.h"
#import <MetalKit/MetalKit.h>
#import "AAMath.h"
#import "AACamera.h"

typedef struct
{
    vector_float4 pos;
    vector_float4 color;
    vector_float2 coord;
} VertexData;

@interface AAScene ()
{
    Uniforms uniform;
}

@end

@implementation AAScene

- (instancetype)init {
    if (self=[super init]) {
        
        _camera = [[AACamera alloc] init];
        _camera.position = simd_make_float3(0.0, 0.0, -1.0);
        _camera.rotation = simd_make_float3(0, 0.0, 0.0);
        
        self.cameraControl = true;
        
        uniform.modelMatrix = matrix_identity_float4x4;
        uniform.projectionMatrix = matrix_identity_float4x4;
        uniform.viewMatrix = matrix_identity_float4x4;
    }
    return self;
}

- (void)render:(id<MTLRenderCommandEncoder>)encoder {
    NSLog(@"super render");
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

@end
