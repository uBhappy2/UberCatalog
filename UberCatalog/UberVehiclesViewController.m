//
//  UberVehiclesViewController.m
//  UberCatalog
//
//  Created by Rao, Amit on 7/24/15.
//  Copyright (c) 2015 Rao, Amit. All rights reserved.
//

@import CoreLocation;
#import "UberVehicleTableViewCell.h"
#import "UberVehiclesViewController.h"

@interface UberVehiclesViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSMutableArray *uberVehiclesData;

@end

@implementation UberVehiclesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Uber Catalog";

    self.locationManager = [[CLLocationManager alloc] init];

    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }

    self.uberVehiclesData = [NSMutableArray array];
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
    return 10;
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

    
    return cell;
}


// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);

    [self.tableView reloadData];
}



@end
