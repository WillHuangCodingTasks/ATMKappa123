//
//  ATMListTableViewController.h
//  LocatorKappa
//
//  Created by Weiyu Huang on 7/29/15.
//  Copyright (c) 2015 Will.Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChaseAPIResult;
@class ViewController;
@interface ATMListTableViewController : UITableViewController

@property (nonatomic) ChaseAPIResult* results;
@property (nonatomic, weak) ViewController* mainVC;

@end
