//
//  UberVehicleTableViewCell.m
//  UberCatalog
//
//  Created by Rao, Amit on 7/24/15.
//  Copyright (c) 2015 Rao, Amit. All rights reserved.
//

#import "UberService.h"
#import "UberVehicleModel.h"
#import "UberVehicleTableViewCell.h"

@implementation UberVehicleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)renderCellWithModel:(UberVehicleModel *)model
{
    self.maxCapacityValueLabel.text = [NSString stringWithFormat:@"%ld",model.maxCapacity];
    self.vehicleTypeValueLabel.text = model.vehicleType;
    self.vehicleImageView.image = [[UberService sharedInstance] getImage:model.vehicleImageUrl];
}
@end
