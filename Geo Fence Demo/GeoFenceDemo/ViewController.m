//
//  ViewController.m
//  GeoFenceDemo
//
//  Created by Priyanshu Bhatnagar on 24/07/16.
//  Copyright © 2016 Priyanshu Bhatnagar. All rights reserved.
//

#import "ViewController.h"
#import "MapKit/MapKit.h"

@interface ViewController () <CLLocationManagerDelegate,MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *uiSwitch;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *statusCheck;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLable;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic)CLLocationManager *locationManager;
@property (strong,nonatomic) MKPointAnnotation *currentAnno;
@property (strong,nonatomic) MKPointAnnotation *storeAnno;
@property (strong,nonatomic) CLCircularRegion *geoRegion;
@property (nonatomic,assign) BOOL mapIsMoving;

@end

@implementation ViewController

//Intialize geo Region

-(void) setUpGeoRegion{
    self.geoRegion = [[CLCircularRegion alloc]initWithCenter:CLLocationCoordinate2DMake(21.198744,72.792601) radius:2 identifier:@"MyRegionIdentifier"];
}

- (IBAction)switchTapped:(id)sender {
    if(self.uiSwitch.isOn){
        self.mapView.showsUserLocation = YES;
        [self.locationManager startUpdatingLocation];
        [self.locationManager startMonitoringForRegion:self.geoRegion];
        
        self.statusCheck.enabled = YES;
    }
    else{
        self.statusCheck.enabled = NO;
        [self.locationManager stopMonitoringForRegion:self.geoRegion];
        [self.locationManager stopUpdatingLocation];
        self.mapView.showsUserLocation = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//Turn off the User Interface until permission is obtained
    self.uiSwitch.enabled = NO;
    self.statusCheck.enabled = NO;
    self.statusLabel.text = @"";
    self.eventLable.text = @"";
    self.mapIsMoving = NO;
    
    //set up location Manager
    self.locationManager = [[CLLocationManager alloc]  init];
    self.locationManager.delegate = self;
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    self.locationManager.pausesLocationUpdatesAutomatically =YES;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 3; //meters
    
    //Zoom the map very close
    
    CLLocationCoordinate2D noLocation;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500,500); //500 by 500
    MKCoordinateRegion adjustRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustRegion animated:YES];
    
    
    // check if the device can do geofence
    
    [self addCurrentAnnotation];
    
    //setup geo Region
    [self setUpGeoRegion];
    
    if([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]] == YES){
    
        
        if(([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)|| ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)){
  
            self.uiSwitch.enabled = YES;
    }
        else{
            
            // If not authorised then try get authorised
            
            [self.locationManager requestAlwaysAuthorization];
        }
        //Ask for notification permission if the app is in the background
        
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication]registerUserNotificationSettings:mySettings];
  }
    else{
    self.statusLabel.text = @"GeoRegions not supported";
    }

    //Store point
    
    self.storeAnno = [[MKPointAnnotation alloc]init];
    self.storeAnno.coordinate = CLLocationCoordinate2DMake(21.198744,72.792601);
    self.storeAnno.title = @"Grocery Store";
    [self.mapView addAnnotation:self.storeAnno];
    
}

-(void) locationManager:(CLLocationManager *) manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    CLAuthorizationStatus currentStatus = [CLLocationManager authorizationStatus];
    if((currentStatus == kCLAuthorizationStatusAuthorizedWhenInUse)|| (currentStatus == kCLAuthorizationStatusAuthorizedAlways)){
        self.uiSwitch.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)checkStatusTapped:(id)sender {
    [self.locationManager requestStateForRegion:self.geoRegion];
}

-(void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    self.mapIsMoving = NO;
}
-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    self.mapIsMoving = YES;
}

-(void) addCurrentAnnotation{
    self.currentAnno = [[MKPointAnnotation alloc]init];
    self.currentAnno.coordinate = CLLocationCoordinate2DMake(0.0,0.0);
    self.currentAnno.title = @"My Location";
}


-(void) centerMap:(MKPointAnnotation * )centerPoint{
    [self.mapView setCenterCoordinate:centerPoint.coordinate animated:YES];
}


#pragma mark - geoFence call backs
-(void) locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    if(state == CLRegionStateUnknown){
        self.statusLabel.text = @"Unknown";
    }else if(state == CLRegionStateInside){
        self.statusLabel.text = @"Inside";
    }
    else if(state == CLRegionStateOutside){
        self.statusLabel.text = @"Outside";
    }
    else self.statusLabel.text = @"Mystery";
}


#pragma mark = location call backs

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    self.currentAnno.coordinate = locations.lastObject.coordinate;
    if(self.mapIsMoving == NO){
        [self centerMap: self.currentAnno];
    }
}

-(void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    UILocalNotification *note = [[UILocalNotification alloc]init];
    note.fireDate = nil;
    note.repeatInterval = 0;
    note.alertTitle = @"Grocery Store";
    note.alertBody = [NSString stringWithFormat:@"Use Coupon code: X54672 & get discount of Rs 100. "];
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
    
    self.eventLable.text = @"Entered";
}

-(void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    UILocalNotification *note = [[UILocalNotification alloc]init];
    note.fireDate = nil;
    note.repeatInterval = 0;
    note.alertTitle = @"Grocery Store";
    note.alertBody = [NSString stringWithFormat:@"Do visit our store."];
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
    
    self.eventLable.text = @"Exited";
}

@end
