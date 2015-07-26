//
//  UberVehiclesViewController.m
//  UberCatalog
//
//  Created by Rao, Amit on 7/24/15.
//  Copyright (c) 2015 Rao, Amit. All rights reserved.
//

@import CoreLocation;
#import "UberService.h"
#import "UberVehicleModel.h"
#import "UberVehicleTableViewCell.h"
#import "UberVehiclesViewController.h"


@interface UberVehiclesViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSArray *uberVehiclesData;

@end

@implementation UberVehiclesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Uber Catalog";

    if(self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }

    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }

    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager startUpdatingLocation];

    self.uberVehiclesData = [NSArray array];
}

- (UberService *)_uberService
{
    return [UberService sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


    [self.tableView reloadData];
}



#pragma mark - UITableViewDatasource delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.uberVehiclesData.count;
}



#pragma mark - UITableViewDelegate delegate methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"Uber Vehicle Cell";

    UberVehicleTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    if(!cell)
    {
        cell = [[UberVehicleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }


    if(self.uberVehiclesData.count > 0) {
        UberVehicleModel *model = [self.uberVehiclesData objectAtIndex:indexPath.row];

        if(model) {
            [cell renderCellWithModel:model];
        }
    }

    return cell;
}


#pragma mark - CLLocationManagerDelegate methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);


    [self.tableView reloadData];

}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        self.currentLocation = self.locationManager.location;

        if(self.currentLocation) {
            [[self _uberService] getUberProductsData:self.currentLocation completionHandler:^(NSDictionary * dict, NSError *error) {
                if(error) {
                    //Handle Error
                    NSLog(@"Error while parsing json response %@", error);
                    return;
                }

                if(dict) {
                    self.uberVehiclesData = [[self _uberService] parseJsonResponseIntoUberProductsModels:dict];
                    [self.tableView reloadData];
                }
            }];
        }
    }
}


@end
