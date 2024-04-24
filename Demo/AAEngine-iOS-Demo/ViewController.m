//
//  ViewController.m
//  AAEngine-iOS-Demo
//
//  Created by allen on 2024/4/3.
//

#import "ViewController.h"
//#import "AAEngine.h"
//#import "AAAssetManager.h"
//#import "AAScene.h"
//#import "AACamera.h"

#import "AARenderer.h"
#import "AAPanoramaScene.h"
#import <MetalKit/MetalKit.h>
#import "AAInputSystem.h"


@interface ViewController () <MTKViewDelegate>
{
    CGPoint lastLocation;
}

@property (strong) MTKView *mtkView;
@property (strong) AARenderer *renderer;

@end

@implementation ViewController

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    
}

- (void)drawInMTKView:(MTKView *)view {
    [self.renderer render];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mtkView = [[MTKView alloc] initWithFrame:self.view.frame];
    self.mtkView.device = MTLCreateSystemDefaultDevice();
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 1);
    [self.view addSubview:self.mtkView];
    
    
    
    self.renderer = [[AARenderer alloc] initWith:self.mtkView]; //dalihua2 plane
    NSString *path = [[NSBundle mainBundle] pathForResource:@"panorama_3" ofType:@"jpg"];
    AAPanoramaScene *scene = [[AAPanoramaScene alloc]initWithImageName:path];
    scene.camera.aspect = self.view.frame.size.width / self.view.frame.size.height;
    [self.renderer loadPanoramaScene:scene];

//    minDistance = 0.0;
//    maxDistance = 20;
//    distance = 2.5;
//    
//    CAMetalLayer *layer = [CAMetalLayer layer];
//    layer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    [self.view.layer addSublayer:layer];
//    self.engine = [AAEngine createWith:layer];
//    
//    AAModel *model = [AAAssetManager loadAsset:[[NSBundle mainBundle] pathForResource:@"plane" ofType:@"obj"]];
//    AAModel *house_model = [AAAssetManager loadAsset:[[NSBundle mainBundle] pathForResource:@"house" ofType:@"obj"]];
//    house_model.scale = simd_make_float3(0.1);
//    AAScene *scene = [[AAScene alloc] init];
//    scene.camera.aspect = self.view.frame.size.width /  self.view.frame.size.height;
//    [scene addChild:model];
//    [scene addChild:house_model];
//    [self.engine loadScene:scene];
//    
//    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render)];
//    displayLink.preferredFramesPerSecond = 30;
//    [displayLink addToRunLoop:NSRunLoop.currentRunLoop forMode:NSDefaultRunLoopMode];

}

//- (void)render {
//    [self.engine renderer];
//}
//
//
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self.view];
    lastLocation = location;
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self.view];
    AAInputSystem *input = [AAInputSystem shared];
//    input.mouseScroll = CGPointMake(location.x - lastLocation.x, location.y - lastLocation.y);
    input.mouseDelta = CGPointMake(location.x - lastLocation.x, location.y - lastLocation.y);
//    [self sceneMove:location.x - lastLocation.x deltaY:location.y - lastLocation.y];
    lastLocation = location;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}
//
//
//- (void)sceneScroll:(CGFloat)x deltaY:(CGFloat)y {
//    distance -= (x + y) * 0.1;
//    distance = MIN(maxDistance, distance);
//    distance = MAX(minDistance, distance);
//    
//    simd_float3 rot = [self.engine getCurrentScene].camera.rot;
//    simd_float4x4 rotateMatrix = rotationYXZ(-rot.x, rot.y, 0);
//    simd_float4 distanceVector = simd_make_float4(0, 0, -distance, 0);
//    simd_float4 rotatedVector = matrix_multiply(rotateMatrix, distanceVector);
//
//    [self.engine getCurrentScene].camera.pos = rotatedVector.xyz;
//}
//
//- (void)sceneMove:(CGFloat)x deltaY:(CGFloat)y {
//    simd_float3 rot = [self.engine getCurrentScene].camera.rot;
//    rot.x += y * 0.008;
//    rot.y += x * 0.008;
//    rot.x = MAX(-M_PI/2.0, MIN(rot.x, M_PI/2.0));
//    [self.engine getCurrentScene].camera.rot = rot;
//    
//    
//    simd_float4x4 rotateMatrix = rotationYXZ(-rot.x, rot.y, 0);
//    simd_float4 distanceVector = simd_make_float4(0, 0, -distance, 0);
//    simd_float4 rotatedVector = matrix_multiply(rotateMatrix, distanceVector);
//    
//    [self.engine getCurrentScene].camera.pos = rotatedVector.xyz;
//}

@end
