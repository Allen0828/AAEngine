//
//  AAEngine.h
//  AAEngine
//
//  Created by allen on 2024/3/26.
//

#import <Foundation/Foundation.h>

@class CAMetalLayer;
@class AAScene;
struct MTLClearColor;

@interface AAEngine : NSObject

+ (instancetype)createWith:(CAMetalLayer*)layer;

- (void)loadScene:(AAScene*)scene;
- (AAScene*)getCurrentScene;

// rgb[0-255] alpha [0-1]   default 135 206 250 1
- (void)setClearColorWithRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha;

//- (void)setClearColor:(MTLClearColor)color;

- (void)renderer;


@end


