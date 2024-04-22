//
//  AAPanoramaScene.h
//  AAEngine-Demo
//
//  Created by allen on 2024/4/22.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>


@interface AAPanoramaScene : NSObject


/// 近平面距离
@property (nonatomic,assign) float near;
/// 远平面距离
@property (nonatomic,assign) float far;
/// 宽高比
@property (nonatomic,assign) float aspect;

/// 全景图片路径
- (instancetype)initWithImageName:(NSString*)fileName;
- (void)render:(id<MTLRenderCommandEncoder>)encoder;




@end


