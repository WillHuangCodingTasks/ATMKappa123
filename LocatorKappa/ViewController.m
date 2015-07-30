//
//  ViewController.m
//  LocatorKappa
//
//  Created by Weiyu Huang on 7/29/15.
//  Copyright (c) 2015 Will.Huang. All rights reserved.
//

#import "ViewController.h"
#import "ChaseAPIResult.h"
#import "ChaseATM.h"
#import "ATMListTableViewController.h"
#import <MapKit/MapKit.h>

#define MILE2METER 1609.3
#define MAP_REGION_PADDING 100

@interface ViewController ()
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.mapView.delegate = self;
    self.locationManager.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    [self fetchData];
}

-(void)fetchData
{
    [self requestAuthorization];
    [self.locationManager startUpdatingLocation];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Location
-(CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 100;
    }
    return _locationManager;
}

-(void)requestAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
        status == kCLAuthorizationStatusDenied) {
        NSString *title = (status == kCLAuthorizationStatusAuthorizedWhenInUse) ?
        @"Background location is not enabled" :
        @"Location service is denied";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: title
                                                            message:@"Please turn on Location Service in the Settings"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Go To Settings", nil];
        [alertView show];
    } else if (status == kCLAuthorizationStatusNotDetermined)
            [self.locationManager requestAlwaysAuthorization];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - CLLocationManagerDelegate


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
#undef DEBUG
#ifdef DEBUG
    NSLog(@"%@", locations);
#endif
    CLLocation* loc = locations.firstObject;
    ChaseAPIResult *results = [[ChaseAPIResult alloc] initWithLatitude:@(loc.coordinate.latitude) andLongtitude:@(loc.coordinate.longitude)];
    
    if (!results.results) {
        NSLog(@"Nothing to be shown.");
        //fixme
        return;
    }
    
    double radius = results.furthestDistance.doubleValue*MILE2METER + MAP_REGION_PADDING;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(loc.coordinate, 2*radius, 2*radius);
    [self.mapView setRegion:viewRegion animated:YES];
    
    
    //MKAnnotation
    [self.mapView addAnnotations:results.results];
    self.atmTVC.results = results;
    [self.atmTVC.tableView reloadData];
}


#pragma mark - MapView delegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"ANNON"];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:@"ANNON"];
    } else {
        annotationView.annotation = annotation;
    }
    annotationView.canShowCallout = YES;
    
    return annotationView;
}


#pragma mark - segue boys
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EmbeddedListSegue"]) {
        ATMListTableViewController* atmTVC = segue.destinationViewController;
        if ([atmTVC isKindOfClass:[ATMListTableViewController class]]) {
            self.atmTVC = atmTVC;
        }
    }
}

@end
