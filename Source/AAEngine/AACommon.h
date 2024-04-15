//
//  AACommon.h
//  AAEngine-Demo
//
//  Created by allen on 2024/4/15.
//

#ifndef AACommon_h
#define AACommon_h
#import <simd/simd.h>

typedef struct {
  matrix_float4x4 modelMatrix;
  matrix_float4x4 viewMatrix;
  matrix_float4x4 projectionMatrix;
  matrix_float3x3 normalMatrix;
  matrix_float4x4 shadowProjectionMatrix;
  matrix_float4x4 shadowViewMatrix;
  vector_float4 clipPlane;
} Uniforms;

typedef struct {
  uint width;
  uint height;
  uint tiling;
  uint lightCount;
  vector_float3 cameraPosition;
  bool alphaTesting;
  bool alphaBlending;
  bool transparency;
} Params;

typedef struct {
    simd_float3 position;
    simd_float3 rotation;
    simd_float3 scale;
} Transform;

typedef enum {
  Position = 0,
  Normal = 1,
  UV = 2,
  Color = 3,
  Tangent = 4,
  Bitangent = 5,
  Joints = 6,
  Weights = 7
} Attributes;

typedef enum {
  VertexBuffer = 0,
  UVBuffer = 1,
  ColorBuffer = 2,
  TangentBuffer = 3,
  BitangentBuffer = 4,
  UniformsBuffer = 11,
  ParamsBuffer = 12,
  LightBuffer = 13,
  MaterialBuffer = 14,
  JointBuffer = 15,
  InstancesBuffer = 16
} BufferIndices;

typedef enum {
  BaseColor = 0,
  NormalTexture = 1,
  RoughnessTexture = 2,
  MetallicTexture = 3,
  AOTexture = 4,
  OpacityTexture = 5,
  ShadowTexture = 10,
  SkyboxTexture = 11,
  SkyboxDiffuseTexture = 12,
  BRDFLutTexture = 13,
  MiscTexture = 31
} TextureIndices;

typedef enum {
  unused = 0,
  Sun = 1,
  Spot = 2,
  Point_t = 3,
  Ambient = 4
} LightType;

typedef struct {
  vector_float3 position;
  vector_float3 color;
  vector_float3 specularColor;
  vector_float3 attenuation;
  LightType type;
  float coneAngle;
  vector_float3 coneDirection;
  float coneAttenuation;
} Light;

typedef struct {
  vector_float3 baseColor;
  vector_float3 specularColor;
  float roughness;
  float metallic;
  float ambientOcclusion;
  float shininess;
  float opacity;
} Material;

typedef enum {
  RenderTargetAlbedo = 1,
  RenderTargetNormal = 2,
  RenderTargetPosition = 3
} RenderTarget;

struct NatureInstance {
  uint textureID;
  uint morphTargetID;
  matrix_float4x4 modelMatrix;
  matrix_float3x3 normalMatrix;
};


#endif
