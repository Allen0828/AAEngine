//
//  ViewController.m
//  AAEngine-Demo
//
//  Created by allen on 2024/3/26.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AAEngine.h"

@interface ViewController ()

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
    self.engine = [[AAEngine alloc] createWith:layer];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
