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
#define CALLOUTACCESSORYVIEW_RECT (CGRectMake(0, 0, 50, 50))
#define GOOGLE_MAP_URL_FORMAT @"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&directionsmode=driving"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.delegate = self;
    self.locationManager.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    [self fetchData];
}

-(void)fetchData
{
    [self requestAuthorization];
    [self.atmTVC.refreshControl beginRefreshing];
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
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView addAnnotations:results.results];
    
    //info passing
    self.atmTVC.results = results;
    [self.atmTVC.refreshControl endRefreshing];
    [self.atmTVC.tableView reloadData];
}


#pragma mark - MapView delegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass: [MKUserLocation class]])
        return nil;//don't override the blue beacon!
    
    //init && reuse
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"ANNON"];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:@"ANNON"];
    } else {
        annotationView.annotation = annotation;
    }
    
    annotationView.canShowCallout = YES;
    annotationView.enabled = YES;
    
    //accessory view
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    button.frame = CALLOUTACCESSORYVIEW_RECT;
    annotationView.rightCalloutAccessoryView = button;
    button.tag = [self.mapView.annotations indexOfObject:annotation];
    //user button tag to pass index
    [button addTarget:self action:@selector(accessoryButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    return annotationView;
}

-(IBAction)accessoryButtonPress:(UIButton *)sender
{
    if (sender.tag == NSNotFound)
        return;
    
    id<MKAnnotation> atm = self.mapView.annotations[sender.tag];
    if([atm conformsToProtocol:@protocol(MKAnnotation)])
        [self navigateWithLocation:atm.coordinate];
}

-(void)navigateWithLocation:(CLLocationCoordinate2D)location
//Open Google map in the browser
{
    NSString *urlString = [NSString stringWithFormat:GOOGLE_MAP_URL_FORMAT, self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude, location.latitude, location.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    if([[UIApplication sharedApplication] canOpenURL:url])
        [[UIApplication sharedApplication] openURL:url];
}


#pragma mark - segue boys
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EmbeddedListSegue"]) {
        ATMListTableViewController* atmTVC = segue.destinationViewController;
        if ([atmTVC isKindOfClass:[ATMListTableViewController class]]) {
            self.atmTVC = atmTVC;
            atmTVC.mainVC = self;
        }
    }
}

@end
