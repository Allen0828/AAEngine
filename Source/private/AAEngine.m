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



@interface AAEngine ()
{
    MTLClearColor _color;
}

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
    if (file) {
        NSBundle *bundle = [NSBundle bundleWithPath:file];
        library = [engine.device newDefaultLibraryWithBundle:bundle error:&error];
    } else {
        NSBundle *bundle = [NSBundle bundleForClass:[AAEngine class]];
        library = [engine.device newDefaultLibraryWithBundle:bundle error:&error];
    }
#else
    library = [engine.device newDefaultLibrary];
#endif
    if (error) {
        NSLog(@"Failed to created library, error %@", error);
        return nil;
    }
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

- (instancetype)init {
    if (self=[super init]) {
        _color = MTLClearColorMake(135/255.0, 206/255.0, 250/255.0, 1);
    }
    return self;
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
    renderPassDescriptor.colorAttachments[0].clearColor = _color;
    
    
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

- (void)setClearColorWithRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha {
    _color = MTLClearColorMake(red/255.0, green/255.0, blue/255.0, alpha);
}


@end

