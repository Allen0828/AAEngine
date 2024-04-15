//
//  AAAssetManager.m
//  AAEngine-Demo
//
//  Created by allen on 2024/3/29.
//

#import "AAAssetManager.h"
#import <MetalKit/MetalKit.h>
#import <ModelIO/ModelIO.h>


MDLVertexDescriptor* defaultLayout(void) {
    MTLVertexDescriptor *vertexDescriptor = [[MTLVertexDescriptor alloc] init];
    
    vertexDescriptor.attributes[Position].format = MTLVertexFormatFloat3;
    vertexDescriptor.attributes[Position].offset = 0;
    vertexDescriptor.attributes[Position].bufferIndex = VertexBuffer;
    vertexDescriptor.attributes[Normal].format = MTLVertexFormatFloat3;
    vertexDescriptor.attributes[Normal].offset = 12;
    vertexDescriptor.attributes[Normal].bufferIndex = VertexBuffer;
    vertexDescriptor.layouts[VertexBuffer].stride = 32; //sizeof(float) * 8;
    
    
    vertexDescriptor.attributes[UV].format = MTLVertexFormatFloat2;
    vertexDescriptor.attributes[UV].offset = 0;
    vertexDescriptor.attributes[UV].bufferIndex = UVBuffer;
    vertexDescriptor.layouts[UVBuffer].stride = 8;
    
    vertexDescriptor.attributes[Color].format = MTLVertexFormatFloat2;
    vertexDescriptor.attributes[Color].offset = 0;
    vertexDescriptor.attributes[Color].bufferIndex = ColorBuffer;
    vertexDescriptor.layouts[ColorBuffer].stride = 16;
    
    vertexDescriptor.attributes[Tangent].format = MTLVertexFormatFloat2;
    vertexDescriptor.attributes[Tangent].offset = 0;
    vertexDescriptor.attributes[Tangent].bufferIndex = TangentBuffer;
    vertexDescriptor.layouts[TangentBuffer].stride = 16;
    
    vertexDescriptor.attributes[Bitangent].format = MTLVertexFormatFloat2;
    vertexDescriptor.attributes[Bitangent].offset = 0;
    vertexDescriptor.attributes[Bitangent].bufferIndex = BitangentBuffer;
    vertexDescriptor.layouts[BitangentBuffer].stride = 16;
    

    MDLVertexDescriptor *layout = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor);
    layout.attributes[0].name = MDLVertexAttributePosition;
    layout.attributes[1].name = MDLVertexAttributeNormal;
    layout.attributes[2].name = MDLVertexAttributeTextureCoordinate;
    layout.attributes[3].name = MDLVertexAttributeColor;
    layout.attributes[4].name = MDLVertexAttributeTangent;
    layout.attributes[Bitangent].name = MDLVertexAttributeBitangent;
    return layout;
}

@interface AAAssetManager ()


@end

@implementation AAAssetManager

+ (AAModel*)loadAsset:(NSString*)path {
    if (path==nil) {
        NSLog(@"path is not found %@", path);
        return nil;
    }
    MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:MTLCreateSystemDefaultDevice()];
    NSURL *url = [NSURL fileURLWithPath:path];
    MDLAsset *asset = [[MDLAsset alloc] initWithURL:url vertexDescriptor:defaultLayout() bufferAllocator:allocator];
    MDLMesh *mMesh = (MDLMesh*)[asset objectAtIndex:0];
    
    return [[AAModel alloc] initWithMDLMesh:mMesh];
}

@end
