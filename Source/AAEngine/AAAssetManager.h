//
//  AAAssetManager.h
//  AAEngine
//
//  Created by allen on 2024/3/27.
//

#import <Foundation/Foundation.h>
@class AAModel;
@class MDLVertexDescriptor;

MDLVertexDescriptor* defaultLayout(void);


@interface AAAssetManager : NSObject

+ (AAModel*)loadAsset:(NSString*)path;

@end




