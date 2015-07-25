//
//  UberService.h
//  UberCatalog
//
//  Created by Rao, Amit on 7/24/15.
//  Copyright (c) 2015 Rao, Amit. All rights reserved.
//

@import CoreLocation;
@import Foundation;

@interface UberService : NSObject

+ (instancetype)sharedInstance;

- (void)getUberProductsData:(CLLocation *)location;




@end
