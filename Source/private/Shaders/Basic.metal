

#include <metal_stdlib>
#include <simd/simd.h>
using namespace metal;


struct VertexIn {
  float4 position [[attribute(0)]];
  float3 normal [[attribute(1)]];
  float2 uv [[attribute(2)]];
};
struct VertexOut {
    float4 position [[position]];
    float2 uv;
    float3 color;
};
struct Uniforms {
    float4x4 modelMatrix;
    float4x4 viewMatrix;
    float4x4 projectionMatrix;
};

vertex VertexOut vertex_main(const VertexIn in [[stage_in]], constant Uniforms &uniforms [[buffer(1)]]) {
    float4 pos = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * in.position;
    VertexOut out;
    out.position = pos;
    out.uv = in.uv;
    return out;
}

fragment float4 fragment_main(VertexOut in [[stage_in]],texture2d<float> baseColorTexture [[texture(1)]]) {
    if (!is_null_texture(baseColorTexture)) {
        constexpr sampler textureSampler(filter::linear, mip_filter::linear, max_anisotropy(8), address::repeat);
        float3 baseColor = baseColorTexture.sample(textureSampler, in.uv*1).rgb;
        return float4(baseColor, 1);
    }
    return float4(1, 1, 1, 1);
}
