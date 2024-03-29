//
//  shader.metal
//  metal
//
//  Created by allen0828 on 2022/10/1.
//

#include <metal_stdlib>
#include <simd/simd.h>
using namespace metal;

typedef enum {
  VertexBuffer = 0,
  UVBuffer = 1,
  UniformsBuffer = 11,
  ParamsBuffer = 12
} BufferIdx;

typedef enum {
  Position = 0,
  Normal = 1,
  UV = 2
} Attributes;

typedef enum {
  BaseColor = 0
} TextureIndices;

typedef struct {
    simd_float3 position;
    simd_float3 rotation;
    float scale;
} Transform;

typedef struct {
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float4x4 projectionMatrix;
} Uniforms;

typedef struct {
    uint width;
    uint height;
    uint tiling;
} Params;

struct VertexIn {
    float4 position [[attribute(Position)]];
    float3 normal [[attribute(Normal)]];
    float2 uv [[attribute(UV)]];
};

struct VertexOut {
    float4 position [[position]];
    float3 normal;
    float2 uv;
};


vertex VertexOut test_vertex(const VertexIn in [[stage_in]], constant Uniforms &uniforms [[buffer(UniformsBuffer)]]) {
    float4 position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * in.position;
    float3 normal = in.normal;
    
    VertexOut out {
      .position = position,
      .normal = normal,
      .uv = in.uv
    };
    return out;
}

fragment float4 test_fragment(VertexOut in [[stage_in]], constant Params &params [[buffer(ParamsBuffer)]], texture2d<float> baseColorTexture [[texture(BaseColor)]]) {
    constexpr sampler textureSampler(filter::linear, mip_filter::linear, max_anisotropy(8), address::repeat);
    float3 baseColor = baseColorTexture.sample(textureSampler, in.uv * params.tiling).rgb;
    return float4(baseColor, 1);
}

