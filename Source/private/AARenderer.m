//
//  AARenderer.m
//  AAEngine-Demo
//
//  Created by allen on 2024/4/22.
//

#import "AARenderer.h"
//#import "AAPanoramaScene.h"
#import <MetalKit/MetalKit.h>
#import "AAScene.h"

static id<MTLDevice> m_device;
static id<MTLCommandQueue> m_commandQueue;
static id<MTLLibrary> m_library;
static MTLPixelFormat m_pixelFormat;

@interface AARenderer ()

@property (nonatomic,weak) MTKView *mtkView;
@property (nonatomic,weak) CAMetalLayer *m_layer;
@property (nonatomic,strong) id <MTLRenderPipelineState> pipelineState;

@property (nonatomic,strong) AAScene *scene;
@property (nonatomic,assign) MTLClearColor color;

@property (nonatomic,strong) AAScene *game;

@end

@implementation AARenderer

- (instancetype)initWith:(CAMetalLayer*)layer {
    if (self=[super init]) {
        [self initMetalDevice];
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
        
        NSError *error;
        self.pipelineState = [m_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
        if (error) {
            NSLog(@"pipelineState error %@", error);
        }
    }
    return self;
}

- (instancetype)initWithMTKView:(MTKView*)mtkView {
    if (self=[super init]) {
        [self initMetalDevice];
        self.mtkView = mtkView;
        id <MTLFunction> vertexFunction = [m_library newFunctionWithName:@"vertex_main"];
        id <MTLFunction> fragmentFunction = [m_library newFunctionWithName:@"fragment_main"];

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
        
        NSError *error;
        self.pipelineState = [self.mtkView.device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
        if (error) {
            NSLog(@"pipelineState error %@", error);
        }
    }
    return self;
}

- (void)initMetalDevice {
    m_device = MTLCreateSystemDefaultDevice();
    m_commandQueue = [m_device newCommandQueue];
    NSError *error;
#if TARGET_OS_IPHONE
    NSString *file = [[NSBundle mainBundle] pathForResource:@"AAEngine_AAEngine" ofType:@"bundle"];
    if (file) {
        NSBundle *bundle = [NSBundle bundleWithPath:file];
        m_library = [m_device newDefaultLibraryWithBundle:bundle error:&error];
    }
    if (error) {
        NSBundle *bundle = [NSBundle bundleForClass:[AARenderer class]];
        m_library = [m_device newDefaultLibraryWithBundle:bundle error:&error];
    }
    if (error) {
        NSLog(@"metal library load error ⚠️%@", error);
    }
#else
    m_library = [m_device newDefaultLibrary];
#endif
}

- (void)loadScene:(AAScene*)scene {
    self.scene = scene;
}
- (AAScene*)getCurrentScene {
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
        [renderEncoder endEncoding];
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
