//
//  UberVehicleTableViewCell.h
//  UberCatalog
//
//  Created by Rao, Amit on 7/24/15.
//  Copyright (c) 2015 Rao, Amit. All rights reserved.
//

@import UIKit;

@interface UberVehicleTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *vehicleImageView;
@property (nonatomic, weak) IBOutlet UILabel *vehicleTypeValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *maxCapacityValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *currentETAValueLabel;

- (void)renderCellWithModelOption1:(UberVehicleModel *)model;
- (void)renderCellWithModelOption2:(UberVehicleModel *)model;

@end
