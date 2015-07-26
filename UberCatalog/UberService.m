//
//  UberService.m
//  UberCatalog
//
//  Created by Rao, Amit on 7/24/15.
//  Copyright (c) 2015 Rao, Amit. All rights reserved.
//

#import "UberService.h"
#import "UberVehicleModel.h"

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

- (void)getUberProductsData:(CLLocation *)location completionHandler:(DictionaryResponseBlock)completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@?latitude=%f&longitude=%f&server_token=%@",
                           kProductEndPoint, location.coordinate.latitude, location.coordinate.longitude, kServiceToken];

    NSString* encodedUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:
                                  NSUTF8StringEncoding];

    NSURL *url = [NSURL URLWithString:encodedUrlString];

    NSURLSession *session = [NSURLSession sharedSession];

    [[session dataTaskWithURL:url
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response

                if(error) {
                    //Handle error case
                    NSLog(@"Error download Uber products data %@, %@", url, error);
                    return;
                }
                else {
                    NSError* error;
                    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:kNilOptions
                                                                           error:&error];


                    completionBlock(json, error);

                }
            }] resume];

}


- (NSArray *)parseJsonResponseIntoUberProductsModels:(NSDictionary *)jsonDictionary
{
    NSMutableArray *vehicleModelsList = [NSMutableArray array];

    NSArray *productsList = jsonDictionary[@"products"];

    for( NSDictionary *productDict in productsList)
    {
        UberVehicleModel *model = [UberVehicleModel new];
        model.vehicleImageUrl = productDict[@"image"];
        model.vehicleType = productDict[@"display_name"];
        model.maxCapacity = [productDict[@"capacity"] integerValue];

        [vehicleModelsList addObject:model];
    }

    return vehicleModelsList;
}

- (UIImage *)getImage:(NSString *)imageUrl
{
    NSString* encodedUrlString = [imageUrl stringByAddingPercentEscapesUsingEncoding:
                                  NSUTF8StringEncoding];

    NSURL *url = [NSURL URLWithString:encodedUrlString];

    NSData *imageData = [NSData dataWithContentsOfURL:url];

    UIImage *image = [UIImage imageWithData:imageData];

    return image;
}

- (void)queryUrlString:(NSString *)imageUrl andProcessImageData:(void (^)(NSData *imageData))processImage
{
    NSString* encodedUrlString = [imageUrl stringByAddingPercentEscapesUsingEncoding:
                                  NSUTF8StringEncoding];

    NSURL *url = [NSURL URLWithString:encodedUrlString];

    dispatch_queue_t download_queue = dispatch_queue_create("download queue", NULL);
    dispatch_async(download_queue, ^{
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            processImage(imageData);
        });
    });
    
}

@end
