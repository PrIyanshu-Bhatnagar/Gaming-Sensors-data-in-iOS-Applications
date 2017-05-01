//
//  ViewController.m
//  deviceMotion
//
//  Created by Priyanshu Bhatnagar on 02/08/16.
//  Copyright © 2016 Priyanshu Bhatnagar. All rights reserved.
//

#import "ViewController.h"
@import CoreMotion;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) CMMotionManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [[CMMotionManager alloc] init];
    self.imageView.image = [UIImage imageNamed:@"Pic.png"];
    
    [self.manager startAccelerometerUpdates];
    
    self.manager.accelerometerUpdateInterval = 0.01;
    ViewController __weak weakSelf = self;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [self.manager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *data, NSError *error){
        double x = data.acceleration.x;
        double y = data.acceleration.y;
        double z = data.acceleration.z;
        
        self.x = .9 * self.x + .1
    }];
}



@end
