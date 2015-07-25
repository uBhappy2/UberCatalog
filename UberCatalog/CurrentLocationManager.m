//
//  CurrentLocationManager.m
//  UberCatalog
//
//  Created by Rao, Amit on 7/24/15.
//  Copyright (c) 2015 Rao, Amit. All rights reserved.
//

@import CoreLocation;
#import "CurrentLocationManager.h"

@implementation CurrentLocationManager

- (instancetype)init
{
    if(self = [super init])
    {
        self.locationManager = [[CLLocationManager alloc] init];

        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }

    return self;
}


@end
