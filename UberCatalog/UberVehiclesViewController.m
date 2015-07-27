//
//  UberVehiclesViewController.m
//  UberCatalog
//
//  Created by Rao, Amit on 7/24/15.
//  Copyright (c) 2015 Rao, Amit. All rights reserved.
//

@import CoreLocation;
#import "DSActivityView.h"
#import "UberService.h"
#import "UberVehicleModel.h"
#import "UberVehicleTableViewCell.h"
#import "UberVehiclesViewController.h"


@interface UberVehiclesViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, retain) NSDictionary *uberVehiclesData; //dictionary with <key, value> = <product_id, model>

@end

@implementation UberVehiclesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Uber Catalog";

    DSActivityView *activityView = [DSBezelActivityView newActivityViewForView: self.view withLabel:		@"Loading..." width: 120];

    [activityView setOpaque:YES];

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

    self.uberVehiclesData = [NSDictionary dictionary];
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
        UberVehicleModel *model = [[self.uberVehiclesData allValues] objectAtIndex:indexPath.row];

        if(model) {
            [cell renderCellWithModelOption2:model];
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
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse ||
       status == kCLAuthorizationStatusAuthorizedAlways)
    {
        self.currentLocation = self.locationManager.location;

        if(self.currentLocation) {
            [[self _uberService] getUberProductsData:self.currentLocation completionHandler:^(NSDictionary * dict, NSError *error) {
                if(error) {
                    //Handle Error
                    NSLog(@"Error while parsing products json response %@", error);
                    return;
                }

                if(dict) {
                    self.uberVehiclesData = [[self _uberService] parseJsonResponseIntoUberProductsModels:dict];


                    [[self _uberService] getCurrentETA:self.currentLocation completionHandler:^(NSDictionary * dict, NSError *error) {
                        if(error) {
                            //Handle Error
                            NSLog(@"Error while parsing ETA json response %@", error);
                            return;
                        }

                        if(dict) {
                            [[self _uberService] updateUberProductsModels:self.uberVehiclesData withETADictionary:dict];
                        }

                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                            [DSBezelActivityView removeViewAnimated:YES];
                        });

                    }];
                }
            }];
        }
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [DSBezelActivityView removeViewAnimated:YES];
        });
    }

}


@end
