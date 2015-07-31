//
//  ChaseATM.h
//  LocatorKappa
//
//  Created by Weiyu Huang on 7/29/15.
//  Copyright (c) 2015 Will.Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ChaseATM : NSObject<MKAnnotation>

@property (nonatomic) NSString *state;
@property (nonatomic) NSString *locType; 
@property (nonatomic) NSString *label;   
@property (nonatomic) NSString *address; 
@property (nonatomic) NSString *city;    
@property (nonatomic) NSString *zip;     
@property (nonatomic) NSString *name;    
@property (nonatomic) float lat;
@property (nonatomic) float lng;
@property (nonatomic) NSString *bank;    
@property (nonatomic) NSString *type;    
@property (nonatomic) NSArray *lobbyHrs;
@property (nonatomic) NSArray *driveUpHrs;
@property (nonatomic) NSString *atms;    
@property (nonatomic) NSArray *services;
@property (nonatomic) NSString *phone;   
@property (nonatomic) NSNumber *distance;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
