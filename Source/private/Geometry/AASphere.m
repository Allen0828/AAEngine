//
//  AASphere.m
//  AAEngine-Demo
//
//  Created by allen on 2024/4/22.
//

#import "AASphere.h"
#import <MetalKit/MetalKit.h>
#import "AAMath.h"
#import "AARenderer.h"

@interface AASphere ()

@property (nonatomic,strong) MTKMesh *mesh;
@property (nonatomic,strong) id<MTLTexture> texture;

@end

@implementation AASphere

- (instancetype)initWithStacks:(int)stacks slices:(int)slices radius:(float)radius {
    if (self = [super init]) {
        
        [self create:stacks slices:slices radius:radius];
    }
    return self;
}

- (void)create:(int)stacks slices:(int)slices radius:(float)radius {
    NSError *error;
    MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:MTLCreateSystemDefaultDevice()];
    MDLMesh *mdlMesh = [[MDLMesh alloc] initSphereWithExtent:simd_make_float3(radius, radius, radius) segments:simd_make_uint2(stacks, slices) inwardNormals:false geometryType:MDLGeometryTypeTriangles allocator:allocator];
    
//        MDLMesh *mdlMesh = [[MDLMesh alloc] initBoxWithExtent:simd_make_float3(1.75, 1.75, 1.75) segments:simd_make_uint3(1, 1, 1) inwardNormals:false geometryType:MDLGeometryTypeTriangles allocator:allocator];
    
    self.mesh = [[MTKMesh alloc] initWithMesh:mdlMesh device:AARenderer.device error:&error];
    if (error != nil) {
        NSLog(@"model error");
    }
}

- (void)render:(id<MTLRenderCommandEncoder>)encoder  Uniforms:(Uniforms)uniform {
    uniform.modelMatrix = self.modelMatrix;
    [encoder setVertexBytes:&uniform length:sizeof(uniform) atIndex:1];
    [encoder setFragmentTexture:self.texture atIndex:1];
    
    for (int i = 0; i < self.mesh.vertexBuffers.count; i++) {
        id<MTLBuffer> buffer = self.mesh.vertexBuffers[i].buffer;
        [encoder setVertexBuffer:buffer offset:0 atIndex:i];
    }
    
    for (MTKSubmesh *submesh in self.mesh.submeshes) {
        [encoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle indexCount:submesh.indexCount indexType:submesh.indexType indexBuffer:submesh.indexBuffer.buffer indexBufferOffset:submesh.indexBuffer.offset];
    }
    
}

- (void)loadTextureWithPath:(NSString*)filePath {
    NSError *error;
    MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:AARenderer.device];
    NSURL *URL = [NSURL fileURLWithPath:filePath];
    
    NSDictionary *options = @{
        MTKTextureLoaderOptionTextureUsage : @(MTLTextureUsageShaderRead),
        MTKTextureLoaderOptionTextureStorageMode : @(MTLStorageModePrivate),
        MTKTextureLoaderOptionSRGB : @(NO),
        MTKTextureLoaderOptionGenerateMipmaps: @(NO)
    };
    id<MTLTexture> uv = [textureLoader newTextureWithContentsOfURL:URL options:options error:&error];
    if(error || uv == nil) {
        NSLog(@"Error creating texture %@", error);
        return;
    }
    self.texture = uv;
}

- (void)resize:(int)stacks slices:(int)slices radius:(float)radius {
    [self create:stacks slices:slices radius:radius];
}



@end
