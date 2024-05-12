//
//  AAScene.h
//
//
//  Created by Allen on 2024/5/12.
//

/*
 可通过继承此类 来完成你想要的任何场景
 */


#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import "Camera/AACamera.h"


@interface AAScene : NSObject

/// 请参考 AACamera.h 对其进行设置
@property (nonatomic,strong,readonly) AACamera *camera;

/// 读取inputSystem控制相机位移旋转 默认true;  设置为false 则需要上层手动修改camera pos rot
@property (nonatomic,assign) BOOL cameraControl;


- (void)render:(id<MTLRenderCommandEncoder>)encoder;


@end
