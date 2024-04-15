//
//  AAModel.h
//  AAEngine
//
//  Created by allen on 2024/3/27.
//


#import <Foundation/Foundation.h>
#import "AACommon.h"


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

- (void)renderWithEncoder:(id<MTLRenderCommandEncoder>)encoder vertexUniforms:(Uniforms)vertex andFragmentParams:(Params)fragment;


@end

