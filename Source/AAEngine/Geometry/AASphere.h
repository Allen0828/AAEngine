//
//  AASphere.h
//  AAEngine-Demo
//
//  Created by allen on 2024/4/22.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import "Basic/AATransform.h"
#import "Tools/AAMath.h"


@interface AASphere : AATransform

- (instancetype)initWithStacks:(int)stacks slices:(int)slices radius:(float)radius;
- (void)resize:(int)stacks slices:(int)slices radius:(float)radius;

- (void)loadTextureWithPath:(NSString*)filePath;
- (void)render:(id<MTLRenderCommandEncoder>)encoder Uniforms:(Uniforms)uniform;


@end


