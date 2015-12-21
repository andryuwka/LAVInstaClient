//
//  LAVServerManager.h
//  LAVInstaClient
//
//  Created by Andrew Lebedev on 15.12.15.
//  Copyright © 2015 Andrew Lebedev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LAVInstagramObj.h"

@interface LAVServerManager : NSObject

+ (LAVServerManager *)sharedManager;
- (void)getMedia:(NSString *)client_id
       onSuccess:(void (^)(NSArray *result))success
       onFailure:(void (^)(NSError *error, NSInteger code))failure;

- (void)getUserInfoOnSuccess:(void (^)(LAVUser *result))success
                   onFailure:(void (^)(NSError *error, NSInteger code))failure;

@end
