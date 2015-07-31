//
//  ChaseATM.m
//  LocatorKappa
//
//  Created by Weiyu Huang on 7/29/15.
//  Copyright (c) 2015 Will.Huang. All rights reserved.
//

#import "ChaseATM.h"
#import <CoreLocation/CoreLocation.h>

@interface ChaseATM (){
    NSDictionary* _dictionary;
}

@end

@implementation ChaseATM


-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if ((self = [super init])) {
        _dictionary = dictionary;
    }
    return self;
}

-(CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(((NSString *)[_dictionary valueForKey:@"lat"]).doubleValue, ((NSString *)[_dictionary valueForKey:@"lng"]).doubleValue);
}

-(NSNumber *)distance
{
    return @(((NSString *)_dictionary[@"distance"]).doubleValue);
}

-(NSString *)type
{
    return _dictionary[@"type"];
}

-(NSString *)locType
{
    return _dictionary[@"locType"];
}

-(NSString *)name
{
    return _dictionary[@"name"];
}

-(NSString *)address
{
    return _dictionary[@"address"];
}

-(NSArray *)lobbyHrs
{
    return _dictionary[@"lobbyHrs"];
}

-(NSArray *)driveUpHrs
{
    return _dictionary[@"driveUpHrs"];
}

-(NSNumber *)phone
{
    return @(((NSString *)_dictionary[@"phone"]).integerValue);
}

-(NSNumber *)zip
{
    return @(((NSString *)_dictionary[@"zip"]).integerValue);
}

-(NSString *)state
{
    return _dictionary[@"state"];
}

-(NSString *)title
{
    return self.name;
}

-(NSString *)subtitle
{
    return [NSString stringWithFormat:@"%.2f mi %@", self.distance.floatValue, self.locType];
}
@end
