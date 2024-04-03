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
    CADisplayLink* displayLink;
}
@property (strong) AAEngine *engine;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAMetalLayer *layer = [CAMetalLayer layer];
    layer.frame = CGRectMake(0, 0, 300, 300);
    [self.view.layer addSublayer:layer];
    self.engine = [AAEngine createWith:layer];
    
    AAModel *model = [AAAssetManager loadAsset:[[NSBundle mainBundle] pathForResource:@"plane" ofType:@"obj"]];
    AACamera *camera = [AACamera new];
    camera.pos = simd_make_float3(-1.0, 1.5, -1);
    camera.rot = simd_make_float3(-0.5, 13.0, 0.0);
    AAScene *scene = [[AAScene alloc] init];
    scene.camera = camera;
    [scene addChild:model];
    [self.engine loadScene:scene];
    
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render)];
    displayLink.preferredFramesPerSecond = 30;
    [displayLink addToRunLoop:NSRunLoop.currentRunLoop forMode:NSDefaultRunLoopMode];

}

- (void)render {
    [self.engine renderer];
}


@end
