//
//  AAModel.m
//  AAEngine
//
//  Created by allen on 2024/3/27.
//

#import "AAModel.h"
#import <MetalKit/MetalKit.h>

@interface AAModel ()
{
    id<MTLTexture> baseColor;
    Transform transform;
}

@property (strong) MTKMesh *mesh;

@end

@implementation AAModel

- (instancetype)initWithMDLMesh:(MDLMesh*)mdl_mesh {
    NSError *error;
    NSAssert(mdl_mesh != nil, @"MDLMesh load error");
    self.mesh = [[MTKMesh alloc] initWithMesh:mdl_mesh device:MTLCreateSystemDefaultDevice() error:&error];
    if (error != nil) {
        NSLog(@"url is not found model");
    }
    
    // 解析 Material
    MDLMaterial *m = mdl_mesh.submeshes.firstObject.material;
    baseColor = [self loadProperty:m Semantic:MDLMaterialSemanticBaseColor];
    
    transform.position = simd_make_float3(0, 0, 0);
    transform.rotation = simd_make_float3(0, 0, 0);
    transform.scale = 1; //simd_make_float3(1, 1, 1);
    self.tiling = 1;
    
    return self;
}

- (Transform)getTransform {
    return transform;
}

- (void)setPos:(simd_float3)pos {
    _pos = pos;
    transform.position = pos;
}
- (void)setRot:(simd_float3)rot {
    _rot = rot;
    transform.rotation = rot;
}
- (void)setScale:(simd_float3)scale {
    _scale = scale;
    transform.scale = scale.x;
}


- (id<MTLTexture>)loadTexture:(NSString*)imgName {
    id<MTLTexture> uv;
    MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:MTLCreateSystemDefaultDevice()];
#if TARGET_OS_IPHONE
    UIImage *img = [UIImage imageNamed:imgName];
    uv = [textureLoader newTextureWithCGImage:img.CGImage options:@{MTKTextureLoaderOptionOrigin: MTKTextureLoaderOriginBottomLeft, MTKTextureLoaderOptionSRGB: @false, MTKTextureLoaderOptionGenerateMipmaps: @true} error:&error];
#else
    NSString *suffix = [NSURL fileURLWithPath:imgName].pathExtension.length > 0 ? nil : @"png";
    if ([[NSBundle mainBundle] pathForResource:imgName ofType:suffix] == nil) {
        NSLog(@"error: %@ is not found", imgName);
        return nil;
    }
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:imgName ofType:suffix]];
    NSError *error;
    uv = [textureLoader newTextureWithContentsOfURL:url options:@{MTKTextureLoaderOptionOrigin: MTKTextureLoaderOriginBottomLeft, MTKTextureLoaderOptionSRGB: @false, MTKTextureLoaderOptionGenerateMipmaps: @true} error:&error];
    
#endif
    if(error || uv == nil) {
        NSLog(@"Error creating texture %@", error.localizedDescription);
        return nil;
    }
    return uv;
}

- (id<MTLTexture>)loadProperty:(MDLMaterial*)material Semantic:(MDLMaterialSemantic)semantic {
    MDLMaterialProperty *mp = [material propertyWithSemantic:semantic];
    if (mp == nil) {
        return nil;
    }
    if (mp.type == MDLMaterialPropertyTypeString) {
        return [self loadTexture:mp.stringValue];
    }
    if (mp.type == MDLMaterialPropertyTypeTexture) {
        NSError *error;
        MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:MTLCreateSystemDefaultDevice()];
        id<MTLTexture> texture = [textureLoader newTextureWithMDLTexture:mp.textureSamplerValue.texture options:@{MTKTextureLoaderOptionOrigin: MTKTextureLoaderOriginBottomLeft, MTKTextureLoaderOptionSRGB: @false, MTKTextureLoaderOptionGenerateMipmaps: @true} error:&error];
        return texture;
    }
    return nil;
}

- (void)renderWithEncoder:(id<MTLRenderCommandEncoder>)encoder vertexUniforms:(Uniforms)vertex andFragmentParams:(Params)fragment {
    Uniforms uniform = vertex;
    uniform.modelMatrix = modelMatrix(transform);

    Params params = fragment;
    params.tiling = self.tiling;
    [encoder setVertexBytes:&uniform length:sizeof(uniform) atIndex:UniformsBuffer];
    [encoder setFragmentBytes:&params length:sizeof(params) atIndex:ParamsBuffer];
    
    [encoder setVertexBuffer:self.mesh.vertexBuffers[0].buffer offset:0 atIndex:VertexBuffer];
    [encoder setFragmentTexture:baseColor atIndex:BaseColor];
    for (int i=0; i<self.mesh.submeshes.count; i++) {
        MTKSubmesh *submesh = self.mesh.submeshes[i];
        [encoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle indexCount:submesh.indexCount indexType:submesh.indexType indexBuffer:submesh.indexBuffer.buffer indexBufferOffset:submesh.indexBuffer.offset];
    }
}

@end
