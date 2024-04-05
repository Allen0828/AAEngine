//
//  ViewController.m
//  AAEngine-Demo
//
//  Created by allen on 2024/3/26.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AAEngine.h"
#import "AAAssetManager.h"
#import "AAScene.h"
#import "AACamera.h"

@interface ViewController ()
{
    float minDistance;
    float maxDistance;
    float distance;
    NSTimer* mainLoopTimer;
}
@property (nonatomic,strong) AAEngine *engine;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    minDistance = 0.0;
    maxDistance = 20;
    distance = 2.5;
    
    
    CAMetalLayer *layer = [CAMetalLayer layer];
    layer.frame = CGRectMake(0, 0, 300, 300);
    layer.pixelFormat = MTLPixelFormatBGRA8Unorm_sRGB;
    self.view.layer = layer;
    self.engine = [AAEngine createWith:layer];
    
    
    AAModel *model = [AAAssetManager loadAsset:[[NSBundle mainBundle] pathForResource:@"plane" ofType:@"obj"]];
    AAModel *house_model = [AAAssetManager loadAsset:[[NSBundle mainBundle] pathForResource:@"house" ofType:@"obj"]];
    house_model.scale = simd_make_float3(0.1);
    AAScene *scene = [[AAScene alloc] init];
    [scene addChild:model];
    [scene addChild:house_model];
    
    [self.engine loadScene:scene];
    // ios use CADisplayLink
    mainLoopTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 30) target:self selector:@selector(render) userInfo:nil repeats:YES];
}

- (void)render {
    [self.engine renderer];
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
    NSLog(@"%.2f -- %.2f", event.deltaX, event.deltaY);
    [self sceneScroll:event.deltaX deltaY:event.deltaY];
}
- (void)mouseDragged:(NSEvent *)event {
    NSLog(@"%.2f -- %.2f", event.deltaX, event.deltaY);
    [self sceneMove:event.deltaX deltaY:event.deltaY];
}
- (void)mouseDown:(NSEvent *)event {
//    InputController *input = [InputController shareInstance];
//    input->leftMouseDown = true;
}
- (void)mouseUp:(NSEvent *)event {
//    InputController *input = [InputController shareInstance];
//    input->leftMouseDown = false;
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
    distance -= (x + y) * 0.1;
    distance = MIN(maxDistance, distance);
    distance = MAX(minDistance, distance);
    
    simd_float3 rot = [self.engine getCurrentScene].camera.rot;
    simd_float4x4 rotateMatrix = rotationYXZ(-rot.x, rot.y, 0);
    simd_float4 distanceVector = simd_make_float4(0, 0, -distance, 0);
    simd_float4 rotatedVector = matrix_multiply(rotateMatrix, distanceVector);

    [self.engine getCurrentScene].camera.pos = rotatedVector.xyz;
}

- (void)sceneMove:(CGFloat)x deltaY:(CGFloat)y {
    simd_float3 rot = [self.engine getCurrentScene].camera.rot;
    rot.x += x * 0.01;
    rot.y += y * 0.01;
    rot.x = MAX(-M_PI/2.0, MIN(rot.x, M_PI/2.0));
    [self.engine getCurrentScene].camera.rot = rot;
    
    simd_float4x4 rotateMatrix = rotationYXZ(-rot.x, rot.y, 0);
    simd_float4 distanceVector = simd_make_float4(0, 0, -distance, 0);
    simd_float4 rotatedVector = matrix_multiply(rotateMatrix, distanceVector);
    
    [self.engine getCurrentScene].camera.pos = rotatedVector.xyz;
}

@end
