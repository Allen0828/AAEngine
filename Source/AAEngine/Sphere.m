//
//  Sphere.m
//  AAEngine-Demo
//
//  Created by allen on 2024/4/22.
//

#import "Sphere.h"
#import <MetalKit/MetalKit.h>

@implementation Sphere {
    id<MTLBuffer> _vertexBuffer;
    id<MTLBuffer> _indexBuffer;
    id<MTLTexture> _texture;
    NSInteger _numVertices;
    NSInteger _numIndices;
    NSInteger _stacks;
    NSInteger _slices;
    float _radius;
}

- (instancetype)initWithStacks:(NSInteger)stacks slices:(NSInteger)slices radius:(float)radius textureFile:(NSString *)textureFile {
    if (self = [super init]) {
        _stacks = stacks;
        _slices = slices;
        _radius = radius;
        [self createMesh];
        [self loadTexture:textureFile];
    }
    return self;
}

- (void)createMesh {
    unsigned int x = _slices;
    unsigned int y = _stacks;
    
    NSError *error = nil;
    MTLVertexDescriptor *vertexDescriptor = [[MTLVertexDescriptor alloc] init];
    vertexDescriptor.attributes[0].format = MTLVertexFormatFloat3;
    vertexDescriptor.attributes[0].bufferIndex = 0;
    vertexDescriptor.attributes[0].offset = 0;
    vertexDescriptor.attributes[1].format = MTLVertexFormatFloat2;
    vertexDescriptor.attributes[1].bufferIndex = 0;
    vertexDescriptor.attributes[1].offset = 12;
    vertexDescriptor.layouts[0].stride = 20;
    
    MTKMeshBufferAllocator *bufferAllocator = [[MTKMeshBufferAllocator alloc] initWithDevice:MTLCreateSystemDefaultDevice()];
    
    
    
    MDLMesh *mdlMesh = [[MDLMesh alloc] initSphereWithExtent:simd_make_float3(0.75, 0.75, 0.75) segments:simd_make_uint2(x, y) inwardNormals:false geometryType:MDLGeometryTypeTriangles allocator:bufferAllocator];
    
    
    MTKMesh *mesh = [[MTKMesh alloc] initWithMesh:mdlMesh device:MTLCreateSystemDefaultDevice() error:&error];
    
    if (!error) {
        _vertexBuffer = mesh.vertexBuffers[0].buffer;
        _indexBuffer = mesh.submeshes[0].indexBuffer.buffer;
        _numVertices = mesh.vertexCount;
        _numIndices = mesh.submeshes[0].indexCount;
    } else {
        NSLog(@"Error creating mesh %@", error);
    }
}

- (void)loadTexture:(NSString *)textureFile {
//    [[MTLTextureLoader alloc] initWithDevice:MTLCreateSystemDefaultDevice()]
    MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:MTLCreateSystemDefaultDevice()];
    NSError *error = nil;
    NSDictionary *options = @{MTKTextureLoaderOptionSRGB: @(NO)};
    _texture = [textureLoader newTextureWithName:textureFile
                                      scaleFactor:1.0
                                           bundle:nil
                                          options:options
                                            error:&error];
    if (error) {
        NSLog(@"Error loading texture %@", error);
    }
}

- (BOOL)execute:(id<MTLRenderCommandEncoder>)renderEncoder {
    if (!_vertexBuffer || !_indexBuffer) {
        return NO;
    }
    
    [renderEncoder setVertexBuffer:_vertexBuffer offset:0 atIndex:0];
    [renderEncoder setFragmentTexture:_texture atIndex:0];
    [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                              indexCount:_numIndices
                               indexType:MTLIndexTypeUInt16
                             indexBuffer:_indexBuffer
                       indexBufferOffset:0];
    return YES;
}

- (void)resize:(NSInteger)stacks slices:(NSInteger)slices radius:(float)radius {
    _stacks = stacks;
    _slices = slices;
    _radius = radius;
    [self createMesh];
}

@end
