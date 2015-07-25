//
//  CurrentLocationManager.h
//  UberCatalog
//
//  Created by Rao, Amit on 7/24/15.
//  Copyright (c) 2015 Rao, Amit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentLocationManager : NSObject

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;


@end
