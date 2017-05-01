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
@property (strong, nonatomic) NSArray *images;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [[CMMotionManager alloc] init];
    
    [self chooseImage:0.0];
    
    self.images = @[[UIImage imageNamed:@"cat.png"],[UIImage imageNamed:@"dog.png"],[UIImage imageNamed:@"panda.png"],[UIImage imageNamed:@"elephant.png"]];
    
    [self.manager startDeviceMotionUpdates];
    
    self.manager.accelerometerUpdateInterval = 0.01;
    
    ViewController __weak *weakSelf = self;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    CMAttitudeReferenceFrame frame = CMAttitudeReferenceFrameXArbitraryZVertical;
   // CMAttitudeReferenceFrame frame = CMAttitudeReferenceFrameXArbitraryCorrectedZVertical;
    //CMAttitudeReferenceFrame frame = CMAttitudeReferenceFrameXMagneticNorthZVertical;
    //CMAttitudeReferenceFrame frame = CMAttitudeReferenceFrameXTrueNorthZVertical;
    
    [self.manager startDeviceMotionUpdatesUsingReferenceFrame:frame toQueue:queue withHandler:^(CMDeviceMotion *data, NSError *error){
        
        double yaw = data.attitude.yaw;
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                [self chooseImage:yaw];
        }];
    }];
}

-(void) chooseImage: (double) yaw{
    if(yaw <= M_PI_4){
        if(yaw >= -M_PI_4){
            self.imageView.image = self.images[0];
        }
        else if(yaw>= -3.0*M_PI_4){
            self.imageView.image = self.images[1];
        }
        else self.imageView.image = self.images[2];
    }
    else{
        if(yaw <= 3.0*M_PI_4){
            self.imageView.image = self.images[3];
        }
        else {
            self.imageView.image = self.images[2];
        }
    }
}

@end
