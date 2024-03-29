//
//  AAEngine.h
//  AAEngine
//
//  Created by allen on 2024/3/26.
//

#import <Foundation/Foundation.h>

@class CAMetalLayer;
@class AAScene;

@interface AAEngine : NSObject

+ (instancetype)createWith:(CAMetalLayer*)layer;

- (void)loadScene:(AAScene*)scene;
- (AAScene*)getCurrentScene;

- (void)renderer;


@end


