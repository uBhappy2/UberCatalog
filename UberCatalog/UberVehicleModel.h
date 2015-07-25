//
//  UberVehicleModel.h
//  UberCatalog
//
//  Created by Rao, Amit on 7/24/15.
//  Copyright (c) 2015 Rao, Amit. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface UberVehicleModel : NSObject

@property (nonatomic, strong) UIImage *vehicleImage;
@property (nonatomic, assign) NSString *vehicleType;
@property (nonatomic, assign) NSInteger maxCapacity;
@property (nonatomic, assign) NSInteger etaInMins;

@end
