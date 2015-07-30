//
//  DetailViewController.h
//  LocatorKappa
//
//  Created by Weiyu Huang on 7/30/15.
//  Copyright (c) 2015 Will.Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChaseATM;

@interface DetailViewController : UIViewController
@property(nonatomic) ChaseATM* atmInfo;


@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lobbyHours;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *driveupHours;


@end
