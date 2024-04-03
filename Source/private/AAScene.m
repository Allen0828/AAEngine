//
//  AAScene.m
//  AAEngine-Demo
//
//  Created by allen on 2024/3/28.
//

#import "AAScene.h"
#import <MetalKit/MetalKit.h>
#import "AAModel.h"
#import "AACamera.h"






@interface AAScene ()
{
    Uniforms uniforms;
    Params params;
}
@property (nonatomic,strong) NSMutableArray <AAModel*>*m_models;

@end

@implementation AAScene

- (AACamera *)camera {
    if (_camera == nil)
        return _defaultCamera;
    return _camera;
}

- (instancetype)init {
    if (self=[super init]) {
        self.m_models = [NSMutableArray array];
        
        // create default camera
        _defaultCamera = [AACamera new];
        _defaultCamera.pos = simd_make_float3(-1.0, 1.5, -1);
        _defaultCamera.rot = simd_make_float3(-0.5, 13.0, 0.0);
    }
    return self;
}


- (void)addChild:(AAModel*)child {
    if (child)
        [self.m_models addObject:child];
}
- (void)removeChild:(AAModel*)child {
    [self.m_models removeObject:child];
}

- (AAModel*)findChildByName:(NSString*)name {
    __block AAModel *model;
    [self.m_models enumerateObjectsUsingBlock:^(AAModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:name]) {
            model = obj;
            *stop = true;
        }
    }];
    return model;
}

- (void)update:(id<MTLRenderCommandEncoder>)encoder {
    
    // camera
    uniforms.viewMatrix = self.camera.viewMatrix;
    uniforms.projectionMatrix = self.camera.projectionMatrix;
    
    for (AAModel *model in self.m_models) {
        if (model.isHidden) {
            continue;
        }
        [model renderWithEncoder:encoder vertexUniforms:uniforms andFragmentParams:params];
    }
}

- (void)renderWithEncoder:(id<MTLRenderCommandEncoder>)encoder vertexUniforms:(Uniforms)vertex andFragmentParams:(Params)fragment {

    
}

@end
