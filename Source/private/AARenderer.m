//
//  AARenderer.m
//  AAEngine-Demo
//
//  Created by allen on 2024/4/22.
//

#import "AARenderer.h"
#import "AAPanoramaScene.h"
#import <MetalKit/MetalKit.h>

NSString *shader = @"\
#include <metal_stdlib>\
\n\
using namespace metal;\
struct VertexIn {\
  float4 position [[attribute(0)]];\
  float3 normal [[attribute(1)]];\
  float2 uv [[attribute(2)]];\
};\
struct VertexOut {\
    float4 position [[position]];\
    float2 uv;\
    float3 color;\
};\
struct Uniforms {\
    float4x4 modelMatrix;\
    float4x4 viewMatrix;\
    float4x4 projectionMatrix;\
};\
vertex VertexOut vertex_main(const VertexIn in [[stage_in]], constant Uniforms &uniforms [[buffer(1)]]) {\
    float4 pos = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * in.position;\
    VertexOut out;\
    out.position = pos;\
    out.uv = in.uv;\
    return out;\
}\
fragment float4 fragment_main(VertexOut in [[stage_in]],texture2d<float> baseColorTexture [[texture(1)]]) {\
    constexpr sampler textureSampler(filter::linear, mip_filter::linear, max_anisotropy(8), address::repeat);\
    float3 baseColor = baseColorTexture.sample(textureSampler, in.uv*1).rgb;\
    return float4(baseColor, 1);\
}\
";

static id<MTLDevice> m_device;
static id<MTLCommandQueue> m_commandQueue;
static id<MTLLibrary> m_library;
static MTLPixelFormat m_pixelFormat;

@interface AARenderer ()

@property (nonatomic,weak) MTKView *mtkView;
@property (nonatomic,weak) CAMetalLayer *m_layer;
@property (nonatomic,strong) id <MTLRenderPipelineState> pipelineState;

@property (nonatomic,strong) AAPanoramaScene *scene;
@property (nonatomic,assign) MTLClearColor color;

@end

@implementation AARenderer

- (instancetype)initWith:(CAMetalLayer*)layer {
    m_device = MTLCreateSystemDefaultDevice();
    m_commandQueue = [m_device newCommandQueue];
    NSError *error;
    m_library = [m_device newLibraryWithSource:shader options:nil error:&error];
    if (error) {
        NSLog(@"初始化 metal library 失败-%@", error);
    }
    if (self=[super init]) {
        self.m_layer = layer;
        if (!self.m_layer.device) {
            self.m_layer.device = m_device;
        }
        if (self.m_layer.pixelFormat) {
            m_pixelFormat = self.m_layer.pixelFormat;
        } else {
            m_pixelFormat = MTLPixelFormatBGRA8Unorm;
            self.m_layer.pixelFormat = MTLPixelFormatBGRA8Unorm;
        }
        self.color = MTLClearColorMake(0, 0, 0, 1);
        
        id <MTLFunction> vertexFunction = [m_library newFunctionWithName:@"vertex_main"];
        id <MTLFunction> fragmentFunction = [m_library newFunctionWithName:@"fragment_main"];

        MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineStateDescriptor.vertexFunction = vertexFunction;
        pipelineStateDescriptor.fragmentFunction = fragmentFunction;
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = m_pixelFormat;
        
        MTLVertexDescriptor *vertexDescriptor = [[MTLVertexDescriptor alloc] init];
        vertexDescriptor.attributes[0].format = MTLVertexFormatFloat3;
        vertexDescriptor.attributes[0].offset = 0;
        vertexDescriptor.attributes[0].bufferIndex = 0;
        vertexDescriptor.attributes[1].format = MTLVertexFormatFloat3;
        vertexDescriptor.attributes[1].offset = 12;
        vertexDescriptor.attributes[1].bufferIndex = 0;
        vertexDescriptor.attributes[2].format = MTLVertexFormatFloat2;
        vertexDescriptor.attributes[2].offset = 24;
        vertexDescriptor.attributes[2].bufferIndex = 0;
        
        vertexDescriptor.layouts[0].stride = sizeof(float) * 8;  // pos nor uv
        pipelineStateDescriptor.vertexDescriptor = vertexDescriptor;
        self.pipelineState = [m_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
        if (error) {
            NSLog(@"pipelineState error %@", error);
        }
    }
    return self;
}

- (instancetype)initWithMTKView:(MTKView*)mtkView {
    m_device = MTLCreateSystemDefaultDevice();
    m_commandQueue = [m_device newCommandQueue];
    if (self=[super init]) {
        self.mtkView = mtkView;
        NSError *error;
        
        id<MTLLibrary> defaultLibrary = [m_device newLibraryWithSource:shader options:nil error:&error];
        id <MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertex_main"];
        id <MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"fragment_main"];

        MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineStateDescriptor.vertexFunction = vertexFunction;
        pipelineStateDescriptor.fragmentFunction = fragmentFunction;
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = self.mtkView.colorPixelFormat;
        
        MTLVertexDescriptor *vertexDescriptor = [[MTLVertexDescriptor alloc] init];
        vertexDescriptor.attributes[0].format = MTLVertexFormatFloat3;
        vertexDescriptor.attributes[0].offset = 0;
        vertexDescriptor.attributes[0].bufferIndex = 0;
        vertexDescriptor.attributes[1].format = MTLVertexFormatFloat3;
        vertexDescriptor.attributes[1].offset = 12;
        vertexDescriptor.attributes[1].bufferIndex = 0;
        vertexDescriptor.attributes[2].format = MTLVertexFormatFloat2;
        vertexDescriptor.attributes[2].offset = 24;
        vertexDescriptor.attributes[2].bufferIndex = 0;
        
        vertexDescriptor.layouts[0].stride = sizeof(float) * 8;  // pos nor uv
        pipelineStateDescriptor.vertexDescriptor = vertexDescriptor;
        self.pipelineState = [self.mtkView.device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
        if (error) {
            NSLog(@"pipelineState error %@", error);
        }
    }
    return self;
}

- (void)loadPanoramaScene:(AAPanoramaScene *)scene {
    self.scene = scene;
}
- (AAPanoramaScene*)getCurrentPanoramaScene {
    return self.scene;
}

- (void)render {
    id<MTLCommandBuffer> commandBuffer = [m_commandQueue commandBuffer];
    MTLRenderPassDescriptor *renderPassDescriptor;
    if (self.m_layer) {
        id<CAMetalDrawable> drawable = [self.m_layer nextDrawable];
        renderPassDescriptor = [[MTLRenderPassDescriptor alloc] init];
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture;
        renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
        renderPassDescriptor.colorAttachments[0].clearColor = self.color;
    } else {
        renderPassDescriptor = self.mtkView.currentRenderPassDescriptor;
    }
    if (renderPassDescriptor != nil) {
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        
        [renderEncoder setRenderPipelineState:self.pipelineState];
        
        [self.scene render:renderEncoder];
        if (self.m_layer) {
            [commandBuffer presentDrawable:[self.m_layer nextDrawable]];
        } else {
            [commandBuffer presentDrawable:self.mtkView.currentDrawable];
        }
    }
    [commandBuffer commit];
}

- (void)setClearColorWithR:(double)red G:(double)green B:(double)blue A:(double)alpha {
    self.color = MTLClearColorMake(red, green, blue, alpha);
}


+ (id<MTLDevice>)device {
    return m_device;
}
+ (id<MTLCommandQueue>)commandQueue {
    return m_commandQueue;
}
+ (id<MTLLibrary>)library {
    return m_library;
}
+ (MTLPixelFormat)pixelFormat {
    return m_pixelFormat;
}

@end
