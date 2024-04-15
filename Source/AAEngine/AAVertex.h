//
//  AAVertex.h
//  AAEngine-Demo
//
//  Created by allen on 2024/4/15.
//

#ifndef AAVertex_h
#define AAVertex_h
#import "AACommon.h"

struct VertexIn {
  float4 position [[attribute(Position)]];
  float3 normal [[attribute(Normal)]];
  float2 uv [[attribute(UV)]];
  float3 color [[attribute(Color)]];
  float3 tangent [[attribute(Tangent)]];
  float3 bitangent [[attribute(Bitangent)]];
  ushort4 joints [[attribute(Joints)]];
  float4 weights [[attribute(Weights)]];
};

struct VertexOut {
  float4 position [[position]];
  float2 uv;
  float3 color;
  float3 worldPosition;
  float3 worldNormal;
  float3 worldTangent;
  float3 worldBitangent;
  float4 shadowPosition;
  float clip_distance [[clip_distance]] [1];
};

struct FragmentIn {
  float4 position;
  float2 uv;
  float3 color;
  float3 worldPosition;
  float3 worldNormal;
  float3 worldTangent;
  float3 worldBitangent;
  float4 shadowPosition;
};

#endif /* AAVertex_h */
