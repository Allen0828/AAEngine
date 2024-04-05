//
//  ViewController.m
//  AAEngine-iOS-Demo
//
//  Created by allen on 2024/4/3.
//

#import "ViewController.h"
#import "AAEngine.h"
#import "AAAssetManager.h"
#import "AAScene.h"
#import "AACamera.h"

@interface ViewController ()
{
    float minDistance;
    float maxDistance;
    float distance;
    CADisplayLink* displayLink;
    CGPoint lastLocation;
}
@property (strong) AAEngine *engine;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    minDistance = 0.0;
    maxDistance = 20;
    distance = 2.5;
    
    CAMetalLayer *layer = [CAMetalLayer layer];
    layer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view.layer addSublayer:layer];
    self.engine = [AAEngine createWith:layer];
    
    AAModel *model = [AAAssetManager loadAsset:[[NSBundle mainBundle] pathForResource:@"plane" ofType:@"obj"]];
    AAModel *house_model = [AAAssetManager loadAsset:[[NSBundle mainBundle] pathForResource:@"house" ofType:@"obj"]];
    house_model.scale = simd_make_float3(0.1);
    AAScene *scene = [[AAScene alloc] init];
    scene.camera.aspect = self.view.frame.size.width /  self.view.frame.size.height;
    [scene addChild:model];
    [scene addChild:house_model];
    [self.engine loadScene:scene];
    
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render)];
    displayLink.preferredFramesPerSecond = 30;
    [displayLink addToRunLoop:NSRunLoop.currentRunLoop forMode:NSDefaultRunLoopMode];

}

- (void)render {
    [self.engine renderer];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self.view];
    lastLocation = location;
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self.view];
    [self sceneMove:location.x - lastLocation.x deltaY:location.y - lastLocation.y];
    lastLocation = location;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
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
    rot.x += y * 0.008;
    rot.y += x * 0.008;
    rot.x = MAX(-M_PI/2.0, MIN(rot.x, M_PI/2.0));
    [self.engine getCurrentScene].camera.rot = rot;
    
    
    simd_float4x4 rotateMatrix = rotationYXZ(-rot.x, rot.y, 0);
    simd_float4 distanceVector = simd_make_float4(0, 0, -distance, 0);
    simd_float4 rotatedVector = matrix_multiply(rotateMatrix, distanceVector);
    
    [self.engine getCurrentScene].camera.pos = rotatedVector.xyz;
}

@end
