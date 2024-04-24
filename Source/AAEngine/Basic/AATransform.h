//
//  AATransform.h
//  AAEngine-Demo
//
//  Created by allen on 2024/4/23.
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>

@interface AATransform : NSObject

@property (nonatomic,assign) vector_float3 position;
@property (nonatomic,assign) vector_float3 rotation;
@property (nonatomic,assign) vector_float3 scale;

@property (nonatomic,readonly) matrix_float4x4 modelMatrix;

@end

