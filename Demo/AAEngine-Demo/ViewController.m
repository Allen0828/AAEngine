//
//  ViewController.m
//  AAEngine-Demo
//
//  Created by allen on 2024/3/26.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

#import <AARenderer.h>
#import <AAPanoramaScene.h>
#import <Tools/AAInputSystem.h>
#import <Camera/AACamera.h>


@interface ViewController ()
{
    NSTimer *mainLoop;
}

@property (strong) AARenderer *renderer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CAMetalLayer *layer = [CAMetalLayer layer];
    layer.frame = CGRectMake(0, 0, 600, 600);
    self.view.layer = layer;
    

    self.renderer = [[AARenderer alloc] initWith:layer];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"panorama_1" ofType:@"jpg"];
    AAPanoramaScene *scene = [[AAPanoramaScene alloc] init];
    scene.cameraControl = true;
    [scene setImageWithPath:path];
    [self.renderer loadPanoramaScene:scene];
    
    
    // ios use CADisplayLink
    mainLoop = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 30) target:self selector:@selector(render) userInfo:nil repeats:YES];
}

- (void)render {
    [self.renderer render];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(void)awakeFromNib {
    [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyDown handler:^NSEvent * _Nullable(NSEvent * _Nonnull aEvent) {
        [self keyDown:aEvent];
        return aEvent;
    }];
    [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskFlagsChanged handler:^NSEvent * _Nullable(NSEvent * _Nonnull aEvent) {
        [self flagsChanged:aEvent];
        return aEvent;
    }];
}

- (void)scrollWheel:(NSEvent *)event {
    // 缩放 方式1
//    [self sceneScroll:event.deltaX deltaY:event.deltaY];
    // 方式2
    [AAInputSystem.shared setScrollX:event.deltaX Y:event.deltaY];
}
- (void)mouseDragged:(NSEvent *)event {
    // 点击 方式1
//    [self sceneMove:event.deltaX deltaY:event.deltaY];
    // 方式2
    [AAInputSystem.shared setCursorX:event.deltaX Y:event.deltaY];
}

- (void)mouseUp:(NSEvent *)event {
    AAInputSystem.shared.type = End;
}

- (void)keyDown:(NSEvent*)event {
    unsigned short code = event.keyCode;
    switch (code) {
        case 13: //w
            [self sceneScroll:0.0 deltaY:1.0];
            break;
        case 0: //a
            [self sceneMove:0.0 deltaY:-1.0];
            break;
        case 1: //s
            [self sceneScroll:0.0 deltaY:-1.0];
            break;
        case 2://d
            [self sceneMove:0.0 deltaY:1.0];
            break;
            
        default:
            break;
    }
}

- (void)sceneScroll:(CGFloat)x deltaY:(CGFloat)y {
    AACamera *c = [self.renderer getCurrentPanoramaScene].camera;
    float distance = c.distance;
    distance -= (x + y) * 0.1;
//    distance = MIN(maxDistance, distance);
//    distance = MAX(minDistance, distance);
    
    simd_float3 rot = c.rotation;
    simd_float4x4 rotateMatrix = rotationYXZ(-rot.x, rot.y, 0);
    simd_float4 distanceVector = simd_make_float4(0, 0, -distance, 0);
    simd_float4 rotatedVector = matrix_multiply(rotateMatrix, distanceVector);

    c.position = rotatedVector.xyz;
    c.distance = distance;
//    [self.engine getCurrentScene].camera.pos = rotatedVector.xyz;
}

- (void)sceneMove:(CGFloat)x deltaY:(CGFloat)y {
    AACamera *c = [self.renderer getCurrentPanoramaScene].camera;
    simd_float3 rot = c.rotation;
    rot.x += y * 0.01;
    rot.y += x * 0.01;
    rot.x = MAX(-M_PI/2.0, MIN(rot.x, M_PI/2.0));
    c.rotation = rot;
//    [self.engine getCurrentScene].camera.rot = rot;
//    
    simd_float4x4 rotateMatrix = rotationYXZ(-rot.x, rot.y, 0);
    simd_float4 distanceVector = simd_make_float4(0, 0, -c.distance, 0);
    simd_float4 rotatedVector = matrix_multiply(rotateMatrix, distanceVector);
    c.position = rotatedVector.xyz;
//    [self.engine getCurrentScene].camera.pos = rotatedVector.xyz;
}

- (float)getVertexX:(float)x {
    float ratioX = 1.0 / self.view.frame.size.width;
    return (2.0 *  x * ratioX) - 1.0;
}
- (float)getVertexY:(float)y {
    float ratioY = 1.0 / self.view.frame.size.height;
    return (2.0 * -y * ratioY) + 1.0;
}

@end
