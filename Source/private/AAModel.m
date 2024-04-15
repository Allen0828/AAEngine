//
//  AAModel.m
//  AAEngine
//
//  Created by allen on 2024/3/27.
//

#import "AAModel.h"
#import <MetalKit/MetalKit.h>
#import "AAMath.h"


typedef struct {
    int baseColor;
    int normal;
    int roughness;
    int metallic;
    int ambientOcclusion;
    int opacity;
} Textures;


@interface AASubmesh : NSObject


@property (nonatomic,assign) NSInteger indexCount;
@property (nonatomic,assign) MTLIndexType indexType;
@property (nonatomic,strong) id <MTLBuffer> indexBuffer;
@property (nonatomic,assign) NSInteger indexBufferOffset;

@property (nonatomic,assign) Textures textures;
@property (nonatomic,assign) Material material;

@property (nonatomic,copy) id<MTLBuffer> materialsBuffer;



@end

// 复用
static NSMutableDictionary <NSString *, NSNumber *>*TexIndex;
static NSMutableArray *Texs;

@implementation AASubmesh

- (instancetype)initWith:(MDLSubmesh*)mdlSubmesh mtk:(MTKSubmesh*)mtkSubmesh {
    if (self=[super init]) {
        if (TexIndex == nil) {
            TexIndex = [NSMutableDictionary dictionary];
            Texs = [NSMutableArray array];
        }
        self.indexCount = mtkSubmesh.indexCount;
        self.indexType = mtkSubmesh.indexType;
        self.indexBuffer = mtkSubmesh.indexBuffer.buffer;
        self.indexBufferOffset = mtkSubmesh.indexBuffer.offset;
        
        self.textures = [self texturesWith:mdlSubmesh.material];
        self.material = [self materialWith:mdlSubmesh.material];
    }
    return self;
}

- (Material)materialWith:(MDLMaterial*)material {
    Material mat;
    if ([material propertyWithSemantic:MDLMaterialSemanticBaseColor]) {
        MDLMaterialProperty *property = [material propertyWithSemantic:MDLMaterialSemanticBaseColor];
        if (property.type == MDLMaterialPropertyTypeFloat3) {
            mat.baseColor = property.float3Value;
        } else if (property.type == MDLMaterialPropertyTypeColor) {
            CGColorSpaceRef colorSpace = CGColorGetColorSpace(property.color);
            size_t numComponents = CGColorSpaceGetNumberOfComponents(colorSpace);
            const CGFloat *components = CGColorGetComponents(property.color);
            if (numComponents == 3) { // RGB
                CGFloat r = components[0];
                CGFloat g = components[1];
                CGFloat b = components[2];
                mat.baseColor = simd_make_float3(r, g, b);
            }
        }
    }
    if ([material propertyWithSemantic:MDLMaterialSemanticSpecular]) {
        MDLMaterialProperty *property = [material propertyWithSemantic:MDLMaterialSemanticSpecular];
        if (property.type == MDLMaterialPropertyTypeFloat3) {
            mat.specularColor = property.float3Value;
        }
    }
    if ([material propertyWithSemantic:MDLMaterialSemanticSpecularExponent]) {
        MDLMaterialProperty *property = [material propertyWithSemantic:MDLMaterialSemanticSpecularExponent];
        if (property.type == MDLMaterialPropertyTypeFloat) {
            mat.shininess = property.floatValue;
        }
    }
    mat.roughness = 1;
    if ([material propertyWithSemantic:MDLMaterialSemanticRoughness]) {
        MDLMaterialProperty *property = [material propertyWithSemantic:MDLMaterialSemanticRoughness];
        if (property.type == MDLMaterialPropertyTypeFloat3) {
            mat.roughness = property.floatValue;
        }
    }
    mat.metallic = 0;
    if ([material propertyWithSemantic:MDLMaterialSemanticMetallic]) {
        MDLMaterialProperty *property = [material propertyWithSemantic:MDLMaterialSemanticMetallic];
        if (property.type == MDLMaterialPropertyTypeFloat3) {
            mat.metallic = property.floatValue;
        }
    }
    mat.ambientOcclusion = 1.0;
    if ([material propertyWithSemantic:MDLMaterialSemanticAmbientOcclusion]) {
        MDLMaterialProperty *property = [material propertyWithSemantic:MDLMaterialSemanticAmbientOcclusion];
        if (property.type == MDLMaterialPropertyTypeFloat3) {
            mat.ambientOcclusion = property.floatValue;
        }
    }
    mat.opacity = 1.0;
    if ([material propertyWithSemantic:MDLMaterialSemanticOpacity]) {
        MDLMaterialProperty *property = [material propertyWithSemantic:MDLMaterialSemanticOpacity];
        if (property.type == MDLMaterialPropertyTypeFloat) {
            mat.opacity = property.floatValue;
        }
    }
    return mat;
}

- (Textures)texturesWith:(MDLMaterial*)material {
    Textures tex;
    tex.baseColor = [self loadProperty:material semantic:MDLMaterialSemanticBaseColor];
    tex.normal = [self loadProperty:material semantic:MDLMaterialSemanticTangentSpaceNormal];
    tex.roughness = [self loadProperty:material semantic:MDLMaterialSemanticRoughness];
    tex.metallic = [self loadProperty:material semantic:MDLMaterialSemanticMetallic];
    tex.ambientOcclusion = [self loadProperty:material semantic:MDLMaterialSemanticAmbientOcclusion];
    tex.opacity = [self loadProperty:material semantic:MDLMaterialSemanticOpacity];
    return tex;
}

- (int)loadProperty:(MDLMaterial*)material semantic:(MDLMaterialSemantic)semantic {
    MDLMaterialProperty *property = [material propertyWithSemantic:semantic];
    if (property == nil) {
        return -1;
    }
    if (property.type == MDLMaterialPropertyTypeString) {
        NSString *filename = property.stringValue;
        return [self loadTexture:filename].intValue;
        
    } else if (property.type == MDLMaterialPropertyTypeTexture) {
        return [self loadTex:property.textureSamplerValue.texture].intValue;
    }
    return -1;
}


//init(material: MDLMaterial?) {
//    func property(with semantic: MDLMaterialSemantic) -> Int? {
//        guard let property = material?.property(with: semantic),
//              property.type == .string,
//              let filename = property.stringValue,
//              let texture =
//                TextureController.texture(filename: filename)
//        else {
//            if let property = material?.property(with: semantic),
//               property.type == .texture,
//               let mdlTexture = property.textureSamplerValue?.texture {
//                return try? TextureController.loadTexture(texture: mdlTexture)
//            }
//            return nil
//        }
//        return texture
//    }
//    baseColor = property(with: MDLMaterialSemantic.baseColor)
//    normal = property(with: .tangentSpaceNormal)
//    roughness = property(with: .roughness)
//    metallic = property(with: .metallic)
//    ambientOcclusion = property(with: .ambientOcclusion)
//    opacity = property(with: .opacity)
//}

- (NSNumber*)loadTexture:(NSString*)imgName {
    if ([TexIndex.allKeys containsObject:imgName]) {
        return [TexIndex objectForKey:imgName];
    }
    id<MTLTexture> uv;
    MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:MTLCreateSystemDefaultDevice()];
    NSString *suffix = [NSURL fileURLWithPath:imgName].pathExtension.length > 0 ? nil : @"png";
    
    NSError *error;
    if ([[NSBundle mainBundle] pathForResource:imgName ofType:suffix] == nil) {
        NSLog(@"error: %@ is not found, Please check if there are any files in the project. If so, please check if the format is supported", imgName);
        // Assets.xcassets
        CGImageRef cg_img;
#if TARGET_OS_IPHONE
        cg_img = [UIImage imageNamed:imgName].CGImage;
#else
        NSImage *img = [NSImage imageNamed:@""];
        CGImageSourceRef ref = CGImageSourceCreateWithData((CFDataRef)img.TIFFRepresentation, nil);
        cg_img = CGImageSourceCreateImageAtIndex(ref, 0, nil);
#endif
        if (cg_img == nil) {
            NSLog(@"error: %@ is not found with Assets.xcassets", imgName);
            return @-1;
        }
        uv = [textureLoader newTextureWithCGImage:cg_img options:@{MTKTextureLoaderOptionOrigin: MTKTextureLoaderOriginBottomLeft, MTKTextureLoaderOptionSRGB: @false, MTKTextureLoaderOptionGenerateMipmaps: @true} error:&error];
    } else {
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:imgName ofType:suffix]];
        uv = [textureLoader newTextureWithContentsOfURL:url options:@{MTKTextureLoaderOptionOrigin: MTKTextureLoaderOriginBottomLeft, MTKTextureLoaderOptionSRGB: @false, MTKTextureLoaderOptionGenerateMipmaps: @true} error:&error];
    }
    if(error || uv == nil) {
        NSLog(@"Error creating texture %@", error.localizedDescription);
        return @-1;
    }
    [Texs addObject:uv];
    [TexIndex setValue:@(Texs.count-1) forKey:imgName];
    return [NSNumber numberWithLongLong:Texs.count - 1];
}

- (NSNumber*)loadTex:(MDLTexture*)tex {
    NSError *error;
    MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:MTLCreateSystemDefaultDevice()];
    id<MTLTexture> texture = [textureLoader newTextureWithMDLTexture:tex options:@{MTKTextureLoaderOptionOrigin: MTKTextureLoaderOriginBottomLeft, MTKTextureLoaderOptionSRGB: @false, MTKTextureLoaderOptionGenerateMipmaps: @true} error:&error];
    if (error) {
        NSLog(@"Error MDLTexture %@", error.localizedDescription);
    }
    NSString *name = [self UUID];
    [Texs addObject:texture];
    [TexIndex setValue:@(Texs.count-1) forKey:name];
    return [NSNumber numberWithLongLong:Texs.count - 1];
}

- (NSString*)UUID {
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    return uuidString;
}

@end


@interface AAModel ()
{
    id<MTLTexture> baseColor;
//    Transform transform;
    Material _material;
}

//@property (nonatomic,assign) Transform transform;


@property (strong) MTKMesh *mesh;
@property (nonatomic,strong) NSMutableArray <AASubmesh*>*meshArray;


@end

@implementation AAModel

- (instancetype)initWithMDLMesh:(MDLMesh*)mdl_mesh {
    NSError *error;
    NSAssert(mdl_mesh != nil, @"MDLMesh load error");
    
 
    
    
    self.mesh = [[MTKMesh alloc] initWithMesh:mdl_mesh device:MTLCreateSystemDefaultDevice() error:&error];
    if (error != nil) {
        NSLog(@"url is not found model");
    }
    self.meshArray = [NSMutableArray array];
    // 解析 Material
    for (int i = 0; i < self.mesh.submeshes.count; i++) {
        AASubmesh *submesh = [[AASubmesh alloc] initWith:mdl_mesh.submeshes[i] mtk:self.mesh.submeshes[i]];
//        submesh.submesh = self.mesh.submeshes[i];
//
//        [self loadProperty:mdl_mesh.submeshes[i].material Semantic:MDLMaterialSemanticBaseColor Submesh:submesh];
        [self.meshArray addObject:submesh];
    }
//    for (MDLSubmesh *mdl_submesh in mdl_mesh.submeshes) {
//        AASubmesh *submesh = [AASubmesh new];
////        submesh.submesh = mdl_submesh;
//        [self loadProperty:mdl_submesh.material Semantic:MDLMaterialSemanticBaseColor Submesh:submesh];
//        [self.meshArray addObject:submesh];
//    }
//    MDLMaterial *m = mdl_mesh.submeshes.firstObject.material;
//    baseColor = [self loadProperty:m Semantic:MDLMaterialSemanticBaseColor];
    
    self.pos = simd_make_float3(0, 0, 0);
    self.rot = simd_make_float3(0, 0, 0);
    self.scale = simd_make_float3(1, 1, 1);

    self.tiling = 1;
    
    return self;
}

//- (Transform)getTransform {
//    return self.transform;
//}

- (void)setPos:(simd_float3)pos {
    _pos = pos;
}
- (void)setRot:(simd_float3)rot {
    _rot = rot;
}
- (void)setScale:(simd_float3)scale {
    _scale = scale;
}


- (id<MTLTexture>)loadTexture:(NSString*)imgName {
    id<MTLTexture> uv;
    MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:MTLCreateSystemDefaultDevice()];
    NSString *suffix = [NSURL fileURLWithPath:imgName].pathExtension.length > 0 ? nil : @"png";
    
    NSError *error;
    if ([[NSBundle mainBundle] pathForResource:imgName ofType:suffix] == nil) {
        NSLog(@"error: %@ is not found, Please check if there are any files in the project. If so, please check if the format is supported", imgName);
        // Assets.xcassets
        CGImageRef cg_img;
#if TARGET_OS_IPHONE
        cg_img = [UIImage imageNamed:imgName].CGImage;
#else
        NSImage *img = [NSImage imageNamed:@""];
        CGImageSourceRef ref = CGImageSourceCreateWithData((CFDataRef)img.TIFFRepresentation, nil);
        cg_img = CGImageSourceCreateImageAtIndex(ref, 0, nil);
#endif
        if (cg_img == nil) {
            NSLog(@"error: %@ is not found with Assets.xcassets", imgName);
            return nil;
        }
        uv = [textureLoader newTextureWithCGImage:cg_img options:@{MTKTextureLoaderOptionOrigin: MTKTextureLoaderOriginBottomLeft, MTKTextureLoaderOptionSRGB: @false, MTKTextureLoaderOptionGenerateMipmaps: @true} error:&error];
    } else {
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:imgName ofType:suffix]];
        uv = [textureLoader newTextureWithContentsOfURL:url options:@{MTKTextureLoaderOptionOrigin: MTKTextureLoaderOriginBottomLeft, MTKTextureLoaderOptionSRGB: @false, MTKTextureLoaderOptionGenerateMipmaps: @true} error:&error];
    }
    if(error || uv == nil) {
        NSLog(@"Error creating texture %@", error.localizedDescription);
        return nil;
    }
    return uv;
}

- (void)loadProperty:(MDLMaterial*)material Semantic:(MDLMaterialSemantic)semantic Submesh:(AASubmesh*)submesh {
//    MDLMaterialProperty *mp = [material propertyWithSemantic:semantic];
//    if (mp == nil) {
//        return;
//    }
//    if (mp.type == MDLMaterialPropertyTypeNone) {
//        NSLog(@"mp type MDLMaterialPropertyTypeNone");
//    } else if (mp.type == MDLMaterialPropertyTypeString) {
//        NSLog(@"mp type MDLMaterialPropertyTypeNone");
//        submesh.baseColor = [self loadTexture:mp.stringValue];
//    } else if (mp.type == MDLMaterialPropertyTypeURL) {
//        NSLog(@"mp type MDLMaterialPropertyTypeURL");
//    } else if (mp.type == MDLMaterialPropertyTypeTexture) {
//        NSLog(@"mp type MDLMaterialPropertyTypeTexture");
//        NSError *error;
//        MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:MTLCreateSystemDefaultDevice()];
//        id<MTLTexture> texture = [textureLoader newTextureWithMDLTexture:mp.textureSamplerValue.texture options:@{MTKTextureLoaderOptionOrigin: MTKTextureLoaderOriginBottomLeft, MTKTextureLoaderOptionSRGB: @false, MTKTextureLoaderOptionGenerateMipmaps: @true} error:&error];
//        submesh.baseColor = texture;
//    } else if (mp.type == MDLMaterialPropertyTypeColor) {
//        NSLog(@"mp type MDLMaterialPropertyTypeColor");
//        CGColorSpaceRef colorSpace = CGColorGetColorSpace(mp.color);
//        size_t numComponents = CGColorSpaceGetNumberOfComponents(colorSpace);
//        const CGFloat *components = CGColorGetComponents(mp.color);
//        if (numComponents == 3) { // RGB
//            CGFloat r = components[0];
//            CGFloat g = components[1];
//            CGFloat b = components[2];
//            Material temp = submesh._material;
//            temp.baseColor = simd_make_float3(r, g, b);
//            submesh._material = temp;
//        }
//    } else if (mp.type == MDLMaterialPropertyTypeFloat) {
//        NSLog(@"mp type MDLMaterialPropertyTypeFloat");
//    } else if (mp.type == MDLMaterialPropertyTypeFloat2) {
//        NSLog(@"mp type MDLMaterialPropertyTypeFloat2");
//    } else if (mp.type == MDLMaterialPropertyTypeFloat3) {
//        NSLog(@"mp type MDLMaterialPropertyTypeFloat3");
//        Material temp = submesh._material;
//        temp.baseColor = mp.float3Value;
//        submesh._material = temp;
//    } else if (mp.type == MDLMaterialPropertyTypeFloat4) {
//        NSLog(@"mp type MDLMaterialPropertyTypeFloat4");
//    } else if (mp.type == MDLMaterialPropertyTypeMatrix44) {
//        NSLog(@"mp type MDLMaterialPropertyTypeMatrix44");
//    } else if (mp.type == MDLMaterialPropertyTypeBuffer) {
//        NSLog(@"mp type MDLMaterialPropertyTypeBuffer");
//    }
}

- (Transform)getModelTransform {
    Transform trans;
    trans.position = self.pos;
    trans.rotation = self.rot;
    trans.scale = self.scale.x;
    return trans;
}

- (void)renderWithEncoder:(id<MTLRenderCommandEncoder>)encoder vertexUniforms:(Uniforms)vertex andFragmentParams:(Params)fragment {
    Uniforms uniform = vertex;
    uniform.modelMatrix = modelMatrix([self getModelTransform]);

    Params params = fragment;
    params.tiling = self.tiling;
    [encoder setVertexBytes:&uniform length:sizeof(uniform) atIndex:UniformsBuffer];
    [encoder setFragmentBytes:&params length:sizeof(params) atIndex:ParamsBuffer];
    
    for (int i=0; i<self.mesh.vertexBuffers.count; i++) {
        [encoder setVertexBuffer:self.mesh.vertexBuffers[i].buffer offset:0 atIndex:i];
    }
    
    // 设置平行光方向
    vector_float3 lightDirection = {0.0, 0.0, -1.0};
    [encoder setVertexBytes:&lightDirection length:sizeof(lightDirection) atIndex:5];

    // 设置平行光颜色
    vector_float3 lightColor = {1.0, 1.0, 1.0};
    [encoder setFragmentBytes:&lightColor length:sizeof(lightColor) atIndex:5];
    
    
    for (AASubmesh *submesh in self.meshArray) {
        //encoder setFragmentBuffer:submesh offset:<#(NSUInteger)#> atIndex:<#(NSUInteger)#>
        if (submesh.textures.baseColor >= 0) {
            [encoder setFragmentTexture:Texs[submesh.textures.baseColor] atIndex:BaseColor];
        }
        
        [encoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle indexCount:submesh.indexCount indexType:submesh.indexType indexBuffer:submesh.indexBuffer indexBufferOffset:submesh.indexBufferOffset];
        
//        [encoder setFragmentTexture:submesh.baseColor atIndex:BaseColor];
//        Material mesh_mat = submesh._material;
//        [encoder setFragmentBytes:&mesh_mat length:sizeof(mesh_mat) atIndex:13];
//        MTKSubmesh *mtk_submesh = submesh.submesh;
//        [encoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle indexCount:mtk_submesh.indexCount indexType:mtk_submesh.indexType indexBuffer:mtk_submesh.indexBuffer.buffer indexBufferOffset:mtk_submesh.indexBuffer.offset];
    }
    
    
//    [encoder setFragmentBytes:&_material length:sizeof(_material) atIndex:13];
//    for (int i=0; i<self.mesh.submeshes.count; i++) {
//        MTKSubmesh *submesh = self.mesh.submeshes[i];
//        [encoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle indexCount:submesh.indexCount indexType:submesh.indexType indexBuffer:submesh.indexBuffer.buffer indexBufferOffset:submesh.indexBuffer.offset];
//    }
}

@end
