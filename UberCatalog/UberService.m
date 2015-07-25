//
//  UberService.m
//  UberCatalog
//
//  Created by Rao, Amit on 7/24/15.
//  Copyright (c) 2015 Rao, Amit. All rights reserved.
//

#import "UberService.h"

const NSString * kServiceToken = @"9OVN_yz8N-FvD1Fz1nlZfcPQhsXB9BDfRd020Igc";
const NSString * kProductEndPoint = @"https://api.uber.com/v1/products";
const NSString * kTimeEndPoint = @"https://api.uber.com/v1/estimates/time";

@implementation UberService

+ (instancetype)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (void)getUberProductsData:(CLLocation *)location
{
    NSString *baseUrlString = kProductEndPoint;
    NSString *urlString = [NSString stringWithFormat:@"%@?latitude=%f,longitude=%f&server_token=%@",
                           location.coordinate.latitude, location.coordinate.longitude, kServiceToken];

    NSString* encodedUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:
                                  NSUTF8StringEncoding];

    NSURL *url = [NSURL URLWithString:encodedUrlString];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

    NSURLSession *session = [NSURLSession sharedSession];

    [[session dataTaskWithURL:urlRequest
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response

            }] resume];

}




@end
