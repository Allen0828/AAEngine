//
//  AARenderer.h
//  AAEngine-Demo
//
//  Created by allen on 2024/4/22.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

@class AAPanoramaScene;
@class MTKView;

@interface AARenderer : NSObject

+ (id<MTLDevice>)device;
+ (id<MTLCommandQueue>)commandQueue;
+ (id<MTLLibrary>)library;

- (instancetype)initWith:(MTKView*)mtkView;
- (void)loadPanoramaScene:(AAPanoramaScene*)scene;
- (void)render;


@end



