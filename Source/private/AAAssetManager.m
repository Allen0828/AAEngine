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
    
    vertexDescriptor.attributes[0].format = MTLVertexFormatFloat3;
    vertexDescriptor.attributes[0].offset = 0;
    vertexDescriptor.attributes[0].bufferIndex = 0;
    
    vertexDescriptor.attributes[1].format = MTLVertexFormatFloat3;
    vertexDescriptor.attributes[1].offset = 12;
    vertexDescriptor.attributes[1].bufferIndex = 0;
    
    vertexDescriptor.attributes[2].format = MTLVertexFormatFloat2;
    vertexDescriptor.attributes[2].offset = 24;
    vertexDescriptor.attributes[2].bufferIndex = 0;
    
    vertexDescriptor.layouts[0].stride = sizeof(float) * 8;

    MDLVertexDescriptor *layout = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor);
    layout.attributes[0].name = MDLVertexAttributePosition;
    layout.attributes[1].name = MDLVertexAttributeNormal;
    layout.attributes[2].name = MDLVertexAttributeTextureCoordinate;
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
