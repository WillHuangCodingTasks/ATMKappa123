//
//  ChaseJSONDictionary.m
//  LocatorKappa
//
//  Created by Weiyu Huang on 7/29/15.
//  Copyright (c) 2015 Will.Huang. All rights reserved.
//

#import "ChaseAPIResult.h"
#import "ChaseATM.h"

#define API_URL_FORMAT @"https://m.chase.com/PSRWeb/location/list.action?lat=%@&lng=%@"


@implementation ChaseAPIResult

- (instancetype)initWithLatitude:(NSNumber *)lat andLongtitude:(NSNumber *)lng
{
    self = [super init];
    if (self) {
        NSString *urlstring = [NSString stringWithFormat:API_URL_FORMAT, lat, lng];
        
#ifdef DEBUG
        NSLog(@"API request: %@", urlstring);
#endif
        NSURL *requestURL = [NSURL URLWithString: urlstring];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:requestURL];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        //sync is fine I guess
        NSDictionary *rawData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if (!rawData || ((NSArray *)rawData[@"error"]).count) {
            NSLog(@"Chase API init error: %@, lag = %@, lng = %@", (NSArray *)rawData[@"error"], lat, lng);
            //fixme
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error"
                                                                message:@"Unable to get data from Chase. Check your Internet connection please."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:nil];
            [alertView show];
            return nil;
        }
        
        NSMutableArray *tmp = [NSMutableArray new];
        for(NSDictionary* atm in rawData[@"locations"])
            [tmp addObject: [[ChaseATM alloc] initWithDictionary:atm]];
        _results = tmp;
        
        
        _furthestDistance =[rawData valueForKeyPath:@"locations.@max.distance"];
        //or you can simply return the last object?
    }
    return self;
}

@end
