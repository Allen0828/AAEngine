//
//  Sphere.h
//  AAEngine-Demo
//
//  Created by allen on 2024/4/22.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <simd/simd.h>

@interface Sphere : NSObject

- (instancetype)initWithStacks:(NSInteger)stacks slices:(NSInteger)slices radius:(float)radius textureFile:(NSString *)textureFile;

- (BOOL)execute:(id<MTLRenderCommandEncoder>)renderEncoder;

- (void)resize:(NSInteger)stacks slices:(NSInteger)slices radius:(float)radius;

@end
