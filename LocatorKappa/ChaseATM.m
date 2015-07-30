//
//  ChaseATM.m
//  LocatorKappa
//
//  Created by Weiyu Huang on 7/29/15.
//  Copyright (c) 2015 Will.Huang. All rights reserved.
//

#import "ChaseATM.h"

@interface ChaseATM (){
    NSDictionary* _dictionary;
}

@end

@implementation ChaseATM
@dynamic state;
@dynamic locType; 
@dynamic label;   
@dynamic address; 
@dynamic city;    
@dynamic zip;     
@dynamic name;    
@dynamic lat;     
@dynamic lng;     
@dynamic bank;    
@dynamic type;    
@dynamic lobbyHrs;
@dynamic driveUpHrs;
@dynamic atms;    
@dynamic services;
@dynamic phone;   
@dynamic distance;

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

@end
