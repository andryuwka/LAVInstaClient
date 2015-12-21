//
//  LAVServerManager.m
//  LAVInstaClient
//
//  Created by Andrew Lebedev on 15.12.15.
//  Copyright © 2015 Andrew Lebedev. All rights reserved.
//

#import "LAVServerManager.h"
#import "AFNetworking.h"
#import "LAVInstagramObj.h"

@interface LAVServerManager ()

@property(nonatomic, strong, readwrite) AFHTTPSessionManager *sessionManager;

@end

static NSString *MAGIC = @"https://api.instagram.com/v1/media/"
    @"popular?client_id=24fc1af302d3442c86e5e3c1e8708015";

static NSString *MAGIC_CLIENT_ID = @"24fc1af302d3442c86e5e3c1e8708015";
static NSString *CLIENT_ID = @"bc694741e8ff4b249fe6f2dd34882017";

// https://api.instagram.com/v1/users/self/media/recent/?access_token=2071913381.bc69474.064913b86ae544d08c1efeb59e0f3bfc

@implementation LAVServerManager

+ (LAVServerManager *)sharedManager {
  static LAVServerManager *manager = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[LAVServerManager alloc] init];
  });
  return manager;
}

- (id)init {
  self = [super init];

  if (self) {
    NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/"];
    self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
  }
  return self;
}

- (void)getUserInfoOnSuccess:(void (^)(LAVUser *result))success
                   onFailure:(void (^)(NSError *error, NSInteger code))failure {
  NSDictionary *params = @{};
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *token = [userDefaults stringForKey:@"accessToken"];
  NSString *req = [NSString
      stringWithFormat:
          @"https://api.instagram.com/v1/users/self/?access_token=%@", token];

  [self.sessionManager GET:req
      parameters:params
      progress:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
        // NSLog(@"JSON : %@", responseObject);
        NSDictionary *data = responseObject[@"data"];

        NSString *username = data[@"username"];
        NSString *profilePic = data[@"profile_picture"];

        NSDictionary *counts = data[@"counts"];
        NSNumber *media = counts[@"media"];
        NSNumber *followers = counts[@"followed_by"];
        NSNumber *follows = counts[@"follows"];

        LAVUser *user = [LAVUser getUserWith:[media integerValue]
                                   followers:[followers integerValue]
                                     follows:[follows integerValue]
                                  profilePic:profilePic
                                    username:username];
        if (success) {
          success(user);
        }
      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (failure) {
          failure(error, task.error.code);
        }
      }];
}

- (void)getMedia:(NSString *)option
       onSuccess:(void (^)(NSArray *result))success
       onFailure:(void (^)(NSError *error, NSInteger code))failure {
  NSDictionary *params = @{};

  NSString *req = nil;

  if ([option isEqualToString:@"userData"]) {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults stringForKey:@"accessToken"];
    req = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/"
                                     @"media/recent/?access_token=%@",
                                     token];
  } else {
    req = MAGIC;
  }

  [self.sessionManager GET:req
      parameters:params
      progress:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
        // NSLog(@"JSON : %@", responseObject);
        NSArray *data = responseObject[@"data"];

        NSMutableArray *medias = [NSMutableArray array];

        for (int i = 0; i < [data count]; ++i) {
          NSMutableArray *comments = [NSMutableArray array];
          NSArray *comment = data[i][@"comments"][@"data"];

          for (int j = 0; j < [comment count]; ++j) {
            LAVComment *currentComm =
                [LAVComment getCommentWith:comment[j][@"from"][@"username"]
                                   andText:comment[j][@"text"]];
            [comments addObject:currentComm];
          }
          NSString *cap = nil;
          NSDictionary *capt = data[i][@"caption"];
          if (capt != [NSNull null]) {
            cap = capt[@"text"];
          } else {
            cap = @"";
          }

          NSDictionary *dictImages = data[i][@"images"];
          NSDictionary *dictResol = dictImages[@"standard_resolution"];
          NSString *takenPhoto = dictResol[@"url"];
          NSString *userid = data[i][@"user"][@"id"];
          NSString *username = data[i][@"user"][@"username"];
          NSString *avatarURL = data[i][@"user"][@"profile_picture"];
          NSInteger likes = [data[i][@"likes"][@"count"] integerValue];
          NSTimeInterval time = [data[i][@"created_time"] doubleValue];

          LAVMedia *currentMedia = [LAVMedia getMediaWith:takenPhoto
                                                   userid:userid
                                                 username:username
                                                avatarURL:avatarURL
                                                  caption:cap
                                                 comments:comments
                                                    likes:likes
                                                     time:time];
          [medias addObject:currentMedia];
        }

        if (success) {
          success(medias);
        }

      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (failure) {
          failure(error, task.error.code);
        }
      }];
}

@end
