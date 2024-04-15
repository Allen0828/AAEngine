//
//  shader.metal
//  metal
//
//  Created by allen0828 on 2022/10/1.
//

#include <metal_stdlib>
#import "../../AAEngine/AACommon.h"
#import "../../AAEngine/AAVertex.h"
//#include "AAVertex.h"
//#include "AACommon.h"
//#import <simd/simd.h>
using namespace metal;




vertex VertexOut test_vertex(const VertexIn in [[stage_in]],
                             constant Uniforms &uniforms [[buffer(UniformsBuffer)]]) 
{
    float4 pos = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * in.position;
    float3 normal = uniforms.normalMatrix * in.normal;
    
    VertexOut out {
        .position = pos,
        .uv = in.uv,
        .color = in.color,
        .worldNormal = normal
    };
    return out;
}

fragment float4 test_fragment(VertexIn in [[stage_in]], constant Params &params [[buffer(ParamsBuffer)]], texture2d<float> baseColorTexture [[texture(BaseColor)]], constant Material &_material [[buffer(13)]]) {
    if (!is_null_texture(baseColorTexture)) {
        constexpr sampler textureSampler(filter::linear, mip_filter::linear, max_anisotropy(8), address::repeat);
        float3 baseColor = baseColorTexture.sample(textureSampler, in.uv * params.tiling).rgb;
        return float4(baseColor, 1);
    }
    
    return float4(1, 1, 1, 1);
//    float3 ambientColor = 0;
//    float3 accumulatedLighting = 0;
//    
//    // 定义平行光属性
//    float3 lightDirection = normalize(float3(0.0, 0.0, -1.0)); // 平行光方向
//    float3 lightColor = float3(1.0, 1.0, 1.0);                  // 平行光颜色
//    // 计算法向量
//    float3 normal = normalize(in.normal);
//    // 计算漫反射光照分量
//    float diffuseStrength = max(dot(normal, lightDirection), 0.0);
//    float3 diffuse = lightColor * diffuseStrength;
//    // 最终颜色
//    float4 finalColor = float4(diffuse, 1.0);
    
//    ambientColor += _material.baseColor * lightColor;
    
    
    
//    float3 color = accumulatedLighting + ambientColor;

    

//    return finalColor; //float4(_material.baseColor, 1);
//    return float4(color, 1);
}

