//
//  AAEngine.m
//  AAEngine
//
//  Created by allen on 2024/3/26.
//

#import "AAEngine.h"
#import <MetalKit/MetalKit.h>
#import <QuartzCore/QuartzCore.h>
#import <simd/simd.h>

#import "AAScene.h"
#import "AAAssetManager.h"

//NSString *shader = @"\
//#include <metal_stdlib> \
//\n\
//using namespace metal;\
//vertex float4 triangleVertex(constant float4* vertices [[buffer(0)]], uint vid [[vertex_id]]) {\
//    return vertices[vid];\
//}\
//fragment float4 triangleFragment() {\
//    return float4(0,0,0,1);\
//}";




typedef struct
{
    vector_float4 pos;   // X Y Z W
} TriangleVertex;

@interface AAEngine ()

@property (nonatomic,strong) CAMetalLayer *mLayer;

@property (strong) id<MTLDevice> device;
@property (strong) id<MTLCommandQueue> commandQueue;
@property (strong) id <MTLRenderPipelineState> pipelineState;

@property (nonatomic,strong) AAScene *scene;

@end

@implementation AAEngine


+ (instancetype)createWith:(CAMetalLayer*)layer {
    AAEngine *engine = [AAEngine new];
    engine.device = MTLCreateSystemDefaultDevice();
    engine.commandQueue = [engine.device newCommandQueue];
    engine.mLayer = layer;
    engine.mLayer.device = engine.device;
    if (layer.pixelFormat) {
        // MTLPixelFormatBGRA8Unorm_sRGB
    }
    
    NSError *error = NULL;
    id<MTLLibrary> library;
#if TARGET_OS_IPHONE
    NSString *file = [[NSBundle mainBundle] pathForResource:@"AAEngine_AAEngine" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:file];
    library = [engine.device newDefaultLibraryWithBundle:bundle error:&error];
#else
    library = [engine.device newDefaultLibrary];
#endif
    id <MTLFunction> vertexFunction = [library newFunctionWithName:@"test_vertex"];
    id <MTLFunction> fragmentFunction = [library newFunctionWithName:@"test_fragment"];
    MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineStateDescriptor.vertexFunction = vertexFunction;
    pipelineStateDescriptor.fragmentFunction = fragmentFunction;
    
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = layer.pixelFormat;
    pipelineStateDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(defaultLayout());
    
    engine.pipelineState = [engine.device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
    if (error) {
        NSLog(@"Failed to created pipeline state, error %@", error);
    }
    
    return engine;
}

- (void)loadScene:(AAScene*)scene {
    self.scene = scene;
}
- (AAScene*)getCurrentScene {
    return self.scene;
}

- (void)renderer {
    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    
    id<CAMetalDrawable> drawable = [self.mLayer nextDrawable];
    MTLRenderPassDescriptor *renderPassDescriptor = [MTLRenderPassDescriptor new];
    renderPassDescriptor.colorAttachments[0].texture = drawable.texture;
    renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 0, 0, 1);
    
    
    if (renderPassDescriptor != nil) {
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        [renderEncoder setRenderPipelineState:self.pipelineState];
        if (self.scene) {
            [self.scene update: renderEncoder];
        }
        [renderEncoder endEncoding];
        [commandBuffer presentDrawable:drawable];
    }
    [commandBuffer commit];
}


@end
