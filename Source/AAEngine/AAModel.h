//
//  AAModel.h
//  AAEngine
//
//  Created by allen on 2024/3/27.
//


#import <Foundation/Foundation.h>
#import "AAMath.h"

typedef enum {
  VertexBuffer = 0,
  UVBuffer = 1,
  UniformsBuffer = 11,
  ParamsBuffer = 12
} BufferIdx;

typedef enum {
  BaseColor = 0
} TextureIndices;

@class MDLMesh;
@protocol MTLRenderCommandEncoder;


@interface AAModel : NSObject

@property (nonatomic,assign) simd_float3 pos;
@property (nonatomic,assign) simd_float3 rot;
@property (nonatomic,assign) simd_float3 scale;
@property (nonatomic,assign) UInt32 tiling;

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) BOOL isHidden;





- (instancetype)initWithMDLMesh:(MDLMesh*)mdl_mesh;
- (Transform)getTransform;
- (void)renderWithEncoder:(id<MTLRenderCommandEncoder>)encoder vertexUniforms:(Uniforms)vertex andFragmentParams:(Params)fragment;


@end

