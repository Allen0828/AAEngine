//
//  AARenderer.h
//  AAEngine-Demo
//
//  Created by allen on 2024/4/22.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

@class MTKView;
@class CAMetalLayer;
@class AAPanoramaScene;
@class AAScene;

@interface AARenderer : NSObject

+ (id<MTLDevice>)device;
+ (id<MTLCommandQueue>)commandQueue;
+ (id<MTLLibrary>)library;
+ (MTLPixelFormat)pixelFormat;


- (instancetype)initWith:(CAMetalLayer*)layer;
- (instancetype)initWithMTKView:(MTKView*)mtkView;
- (void)setClearColorWithR:(double)red G:(double)green B:(double)blue A:(double)alpha;
- (void)render;

/// 加载场景
- (void)loadScene:(AAScene*)scene;
- (AAScene*)getCurrentScene;


@end



