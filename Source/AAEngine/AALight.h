//
//  AALight.h
//  AAEngine-Demo
//
//  Created by allen on 2024/4/12.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    AALightTypeDirectional,
    AALightTypePoint,
    AALightTypeSpot,
    AALightTypeArea,
    AALightTypeCount,
} AALightType;


@interface AALight : NSObject

@property (nonatomic,assign) BOOL enable;
@property (nonatomic,assign) AALightType type;




@end
