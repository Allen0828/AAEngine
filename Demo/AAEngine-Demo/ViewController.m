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
    NSTimer* mainLoopTimer;
}
@property (nonatomic,strong) AAEngine *engine;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CAMetalLayer *layer = [CAMetalLayer layer];
    layer.frame = CGRectMake(0, 0, 300, 300);
    layer.backgroundColor = CGColorCreateGenericRGB(0, 0, 0, 1.0);
    layer.pixelFormat = MTLPixelFormatBGRA8Unorm_sRGB;
//    [self.view.layer addSublayer:layer];
    self.view.layer = layer;
    self.engine = [AAEngine createWith:layer];
    
    AAModel *model = [AAAssetManager loadAsset:[[NSBundle mainBundle] pathForResource:@"plane" ofType:@"obj"]];
    AACamera *camera = [AACamera new];
    camera.pos = simd_make_float3(-1.0, 1.5, -1);
    camera.rot = simd_make_float3(-0.5, 13.0, 0.0);
    AAScene *scene = [[AAScene alloc] init];
    scene.camera = camera;
    [scene addChild:model];
    
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

- (void)keyDown:(NSEvent*)event {
    NSLog(@"%d", event.keyCode);
    simd_float3 pos = [self.engine getCurrentScene].camera.pos;
    unsigned short code = event.keyCode;
    switch (code) {
        case 13:
            [self.engine getCurrentScene].camera.pos = simd_make_float3(pos.x, pos.y, pos.z + 0.002);
            break;
        case 0:
            [self.engine getCurrentScene].camera.pos = simd_make_float3(pos.x+0.02, pos.yz);
            break;
        case 1:
            [self.engine getCurrentScene].camera.pos = simd_make_float3(pos.x-0.02, pos.yz);
            break;
        case 2:
            [self.engine getCurrentScene].camera.pos = simd_make_float3(pos.x, pos.y, pos.z - 0.002);
            break;
            
        default:
            break;
    }
}


@end
