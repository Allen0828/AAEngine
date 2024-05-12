//
//  AAPanoramaScene.h
//
//
//  Created by Allen on 2024/5/12.
//

#import "AAScene.h"


@class AASphere;

@interface AAPanoramaScene : AAScene

/// 请参考 AASphere.h 对其进行设置
@property (nonatomic,strong,readonly) AASphere *sphere;

/// 全景图片路径  [[NSBundle mainBundle] pathForResource:@"panorama_3" ofType:@"jpg"]
- (void)setImageWithPath:(NSString*)filePath;
// super method
- (void)render:(id<MTLRenderCommandEncoder>)encoder;

@end


