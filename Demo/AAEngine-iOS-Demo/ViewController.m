//
//  ViewController.m
//  AAEngine-iOS-Demo
//
//  Created by allen on 2024/4/3.
//

#import "ViewController.h"
#import <MetalKit/MetalKit.h>

#import <AARenderer.h>
#import <AAPanoramaScene.h>
#import <Tools/AAInputSystem.h>



@interface ViewController () <MTKViewDelegate>


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
    
    
    
    self.renderer = [[AARenderer alloc] initWithMTKView:self.mtkView]; //dalihua2 plane
    NSString *path = [[NSBundle mainBundle] pathForResource:@"panorama_1" ofType:@"jpg"];
    AAPanoramaScene *scene = [[AAPanoramaScene alloc] init];
    [scene setImageWithPath:path];
    scene.camera.aspect = self.view.frame.size.width / self.view.frame.size.height;
    [self.renderer loadPanoramaScene:scene];
    
    
    UIPanGestureRecognizer *dragGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDragGesture:)];
    [self.mtkView addGestureRecognizer:dragGesture];

    // Magnification Gesture
    UIPinchGestureRecognizer *magnificationGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleMagnificationGesture:)];
    [self.mtkView addGestureRecognizer:magnificationGesture];

}




- (void)handleDragGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            AAInputSystem.shared.type = Begin;
            break;
            
        case UIGestureRecognizerStateChanged:
            AAInputSystem.shared.type = Move;
            [AAInputSystem.shared setCursorX:translation.x Y:translation.y];
            break;
            
        case UIGestureRecognizerStateEnded: {
            AAInputSystem.shared.type = End;
            NSString *path = [[NSBundle mainBundle] pathForResource:@"panorama_2" ofType:@"jpg"];
//            AAPanoramaScene *scene = [self.renderer getCurrentPanoramaScene];
//            [scene setImageWithPath:path];
            
//            AAPanoramaScene *scene = [[AAPanoramaScene alloc] init];
//            [scene setImageWithPath:path];
//            [self.renderer loadPanoramaScene:scene];
            
            break;
        }
            
            
        default:
            break;
    }
}

- (void)handleMagnificationGesture:(UIPinchGestureRecognizer *)gestureRecognizer {
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            AAInputSystem.shared.type = Begin;
            break;
            
        case UIGestureRecognizerStateChanged: {
            [AAInputSystem.shared setScrollX:gestureRecognizer.scale Y:gestureRecognizer.scale];
            break;
        }
        case UIGestureRecognizerStateEnded:
            AAInputSystem.shared.type = End;
            break;
        case UIGestureRecognizerStateCancelled:
            AAInputSystem.shared.type = End;
            break;
            
        default:
            break;
    }
}



@end
