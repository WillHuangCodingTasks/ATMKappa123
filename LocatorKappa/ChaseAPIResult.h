//
//  ChaseJSONDictionary.h
//  LocatorKappa
//
//  Created by Weiyu Huang on 7/29/15.
//  Copyright (c) 2015 Will.Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChaseAPIResult : NSObject
@property(readonly, nonatomic) NSArray* results;
@property (nonatomic, readonly) NSNumber *furthestDistance;
//two approaches. lastObject or collection Operations
//in miles

- (instancetype)initWithLatitude:(NSNumber *)lat andLongtitude:(NSNumber *)lng;
@end
