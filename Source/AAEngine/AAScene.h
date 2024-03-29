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

@property (nonatomic,strong) AACamera *camera;

//- (void)setCamera:(AACamera*)camera;
//- (AACamera*)getCamera;

- (void)addChild:(AAModel*)child;
- (void)removeChild:(AAModel*)child;

- (AAModel*)findChildByName:(NSString*)name;

- (void)update:(id<MTLRenderCommandEncoder>)encoder;

@end



