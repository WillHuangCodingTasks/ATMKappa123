//
//  ATMListTableViewController.m
//  LocatorKappa
//
//  Created by Weiyu Huang on 7/29/15.
//  Copyright (c) 2015 Will.Huang. All rights reserved.
//

#import "ATMListTableViewController.h"
#import "ChaseAPIResult.h"
#import "ChaseATM.h"
#import "DetailViewController.h"
#import "ViewController.h"

@interface ATMListTableViewController ()

@end

@implementation ATMListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.refreshControl = [UIRefreshControl new];
    [self.tableView addSubview: self.refreshControl];
    
    [self.refreshControl addTarget:self.mainVC action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.results.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    ChaseATM* thisATM = self.results.results[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%.2f mi %@, %@", thisATM.distance.floatValue, thisATM.locType, thisATM.name];
    cell.detailTextLabel.text = thisATM.address;
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"toDetail"] && [segue.destinationViewController isKindOfClass:[DetailViewController class]]) {
        DetailViewController *detailVC = segue.destinationViewController;
        NSIndexPath* idxPath = [self.tableView indexPathForCell:sender];
        detailVC.atmInfo = self.results.results[idxPath.row];
        //idxpath.row is safe!
    }
    
}

@end
