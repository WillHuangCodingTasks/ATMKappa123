//
//  DetailViewController.m
//  LocatorKappa
//
//  Created by Weiyu Huang on 7/30/15.
//  Copyright (c) 2015 Will.Huang. All rights reserved.
//

#import "DetailViewController.h"
#import "ChaseATM.h"

@interface DetailViewController ()
- (IBAction)getBack:(UIBarButtonItem *)sender;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.name.text = [NSString stringWithFormat:@"%@ %@", self.atmInfo.name, self.atmInfo.locType];
    
    self.address.text = [NSString stringWithFormat:@"%@, %@, %@", self.atmInfo.address, self.atmInfo.state, self.atmInfo.zip];
    self.distance.text =[self.atmInfo.distance.description stringByAppendingString:@" mi"];
    
    NSUInteger idx;
    
    for (idx = 0; idx <self.lobbyHours.count; idx++) {
        NSString* s = self.atmInfo.lobbyHrs[idx];
        UILabel* label = self.lobbyHours[idx];
        label.text = s.length ? s : @"N/A";
    }
    
    for (idx = 0; idx <self.driveupHours.count; idx++) {
        NSString* s = self.atmInfo.driveUpHrs[idx];
        UILabel* label = self.driveupHours[idx];
        label.text = s.length ? s : @"N/A";
    }
    
    self.phone.text = [self.atmInfo.phone isEqual:@(0)]? @"N/A" : self.atmInfo.phone.description;
}

- (IBAction)getBack:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
