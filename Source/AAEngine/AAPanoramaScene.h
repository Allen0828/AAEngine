//
//  AAPanoramaScene.h
//  AAEngine-Demo
//
//  Created by allen on 2024/4/22.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import "AACamera.h"
#import "AASphere.h"

@interface AAPanoramaScene : NSObject

/// 请参考 AACamera.h 对其进行设置
@property (nonatomic,strong,readonly) AACamera *camera;
/// 请参考 AASphere.h 对其进行设置
@property (nonatomic,strong,readonly) AASphere *sphere;

/// 读取inputSystem控制相机位移旋转 默认true;  设置为false 则需要上层手动修改camera pos rot
@property (nonatomic,assign) BOOL cameraControl;


/// 全景图片路径  [[NSBundle mainBundle] pathForResource:@"panorama_3" ofType:@"jpg"]
- (void)setImageWithPath:(NSString*)filePath;

- (void)render:(id<MTLRenderCommandEncoder>)encoder;




@end


