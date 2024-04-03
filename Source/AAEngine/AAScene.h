//
//  AAScene.h
//  AAEngine-Demo
//
//  Created by allen on 2024/3/28.
//


#import <Foundation/Foundation.h>

@class AAModel;
@class AACamera;
@protocol MTLRenderCommandEncoder;

@interface AAScene : NSObject

/// 如果当前scene 没有设置摄像机 则会使用默认摄像机
@property (nonatomic,strong,readonly) AACamera *defaultCamera;
@property (nonatomic,strong) AACamera *camera;


- (void)addChild:(AAModel*)child;
- (void)removeChild:(AAModel*)child;

- (AAModel*)findChildByName:(NSString*)name;

- (void)update:(id<MTLRenderCommandEncoder>)encoder;

@end



