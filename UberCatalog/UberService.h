//
//  UberService.h
//  UberCatalog
//
//  Created by Rao, Amit on 7/24/15.
//  Copyright (c) 2015 Rao, Amit. All rights reserved.
//

@import CoreLocation;
@import Foundation;
@import UIKit;

#define DEBUG 1

/**
 * The callback block for web requests that return a NSDictionary.
 *
 * @param dict   Dictionary from the request.
 * @param error  Either the error resulting of the request or attempting to parse the response as in having
 *               a problem deserializing the JSON.
 */
typedef void (^DictionaryResponseBlock)(NSDictionary *dict, NSError *error);

/**
 * The callback block for web requests that return a NSData object.
 *
 * @param data   Data from the request.
 * @param error  The error resulting from making the request.
 */
typedef void (^DataResponseBlock)(NSData *data, NSError *error);



@interface UberService : NSObject

+ (instancetype)sharedInstance;

- (void)getUberProductsData:(CLLocation *)location completionHandler:(DictionaryResponseBlock)completionBlock;
- (NSDictionary *)parseJsonResponseIntoUberProductsModels:(NSDictionary *)jsonDictionary;
- (UIImage *)getImage:(NSString *)imageUrl;
- (void)queryUrlString:(NSString *)imageUrl andProcessImageData:(DataResponseBlock)completionBlock;
- (void)queryUrlString:(NSString *)imageUrl andHandleImageData:(void (^)(NSData *imageData))completionHandler;
- (void)getCurrentETA:(CLLocation *)location completionHandler:(DictionaryResponseBlock)completionBlock;
- (void)updateUberProductsModels:(NSDictionary *)uberProductDictionary
               withETADictionary:(NSDictionary *)jsonDictionary;

@end
