//
//  ViewController.h
//  LocatorKappa
//
//  Created by Weiyu Huang on 7/29/15.
//  Copyright (c) 2015 Will.Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class ATMListTableViewController;
@interface ViewController : UIViewController<CLLocationManagerDelegate, UIAlertViewDelegate, MKMapViewDelegate>

@property (nonatomic, strong) ATMListTableViewController* atmTVC;

@end
