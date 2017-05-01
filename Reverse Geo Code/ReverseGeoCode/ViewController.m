//
//  ViewController.m
//  ReverseGeoCode
//
//  Created by Priyanshu Bhatnagar on 23/07/16.
//  Copyright © 2016 Priyanshu Bhatnagar. All rights reserved.
//

#import "ViewController.h"
#import "MapKit/MapKit.h"
@import CoreLocation;

@interface ViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *pinIcon;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *geoCodeLabel;
@property (strong,nonatomic) CLGeocoder *geoCoder;
@property (assign,nonatomic) BOOL lookinUp;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.geoCoder = [[CLGeocoder alloc]init];
    self.geoCodeLabel.text  = nil;
    self.geoCodeLabel.alpha = 0.5;
    self.lookinUp = NO;
    
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{

    [self executeTheLookup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CLLocationCoordinate2D)locationAtCenterOfMapview{
    CGPoint centerOfPin = CGPointMake(CGRectGetMidX(self.pinIcon.bounds),CGRectGetMaxY(self.pinIcon.bounds));


return [self.mapView convertPoint:centerOfPin toCoordinateFromView:self.pinIcon];
}

-(void)executeTheLookup{
    if(self.lookinUp == NO){
        self.lookinUp =YES;
        
    CLLocationCoordinate2D coord = [self locationAtCenterOfMapview];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:coord.latitude longitude:coord.longitude];
    
    [self startReverseGeoCodeLocation:loc];
    
    }
}


-(void) startReverseGeoCodeLocation:(CLLocation *) location{
    
    [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error ){
        
        if(error){
            
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"There was a problem in geoCoding." message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:ac animated:YES completion:nil];
            return;
        }
        
        NSMutableSet *mappedPLaceDescs = [NSMutableSet new];
        for(CLPlacemark *p in placemarks){
            if(p.name != nil){
                [mappedPLaceDescs addObject:p.name];
                
            }
            if(p.administrativeArea != nil){
                [mappedPLaceDescs addObject:p.administrativeArea];
            }
            if(p.country != nil){
                [mappedPLaceDescs addObject:p.country];
                [mappedPLaceDescs addObjectsFromArray:p.areasOfInterest];
            }
            
        }
        self.geoCodeLabel.text = [[mappedPLaceDescs allObjects]componentsJoinedByString:@"\n"];
        self.geoCodeLabel.alpha = 1.0;
        self.lookinUp = NO;
        }];
        
    
}
@end
