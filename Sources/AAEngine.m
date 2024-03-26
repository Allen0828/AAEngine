//
//  AAEngine.m
//  AAEngine-Demo
//
//  Created by allen on 2024/3/26.
//

#import "AAEngine.h"
#import <Metal/Metal.h>
#import <QuartzCore/QuartzCore.h>
#include <simd/simd.h>

NSString *shader = @"\
#include <metal_stdlib> \
\n\
using namespace metal;\
vertex float4 triangleVertex(constant float4* vertices [[buffer(0)]], uint vid [[vertex_id]]) {\
    return vertices[vid];\
}\
fragment float4 triangleFragment() {\
    return float4(0,0,0,1);\
}";

typedef struct
{
    vector_float4 pos;   // X Y Z W
} TriangleVertex;

@interface AAEngine ()

@property (nonatomic,strong) CAMetalLayer *mLayer;

@property (strong) id<MTLDevice> device;
@property (strong) id<MTLCommandQueue> commandQueue;
@property (strong) id <MTLRenderPipelineState> pipelineState;

@end

@implementation AAEngine


- (instancetype)createWith:(CAMetalLayer*)layer {
    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];
    _mLayer = layer;
    self.mLayer.device = _device;
    if (layer.pixelFormat) {
        // MTLPixelFormatBGRA8Unorm_sRGB
    }
    
    NSError *error = NULL;
    id<MTLLibrary> defaultLibrary = [_device newLibraryWithSource:shader options:nil error:&error];
    id <MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"triangleVertex"];
    id <MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"triangleFragment"];
    MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineStateDescriptor.vertexFunction = vertexFunction;
    pipelineStateDescriptor.fragmentFunction = fragmentFunction;
    
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = layer.pixelFormat;
    
    _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
    if (error) {
        NSLog(@"Failed to created pipeline state, error %@", error);
    }
    
   
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    
    id<CAMetalDrawable> drawable = [self.mLayer nextDrawable];
    MTLRenderPassDescriptor *renderPassDescriptor = [MTLRenderPassDescriptor new];
    renderPassDescriptor.colorAttachments[0].texture = drawable.texture;
    renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 0, 0, 1);
    
    
    if (renderPassDescriptor != nil) {
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        [renderEncoder setRenderPipelineState:_pipelineState];
        TriangleVertex vert[] = {
            { .pos = {0, 1.0, 0, 1}},
            { .pos = {-1.0, -1.0, 0, 1}},
            { .pos = {1.0, -1.0, 0, 1}},
        };
        [renderEncoder setVertexBytes:vert length:sizeof(vert) atIndex:0];
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3 instanceCount: 1];
        [renderEncoder endEncoding];
        [commandBuffer presentDrawable:drawable];
    }
    [commandBuffer commit];
    
    
    return self;
}




@end
