//
//  LAVInstagramObj.h
//  LAVInstaClient
//
//  Created by Andrew Lebedev on 15.12.15.
//  Copyright © 2015 Andrew Lebedev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LAVMedia : NSObject

@property(nonatomic, strong) NSString *takenPhoto;
@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *avatarURL;
@property(nonatomic, strong) NSString *caption;
@property(nonatomic, strong) NSArray *comments;
@property(nonatomic, assign) NSInteger likes;
@property(nonatomic, assign) NSTimeInterval time;

+ (LAVMedia *)getMediaWith:(NSString *)takenPhoto
                    userid:(NSString *)user_id
                  username:(NSString *)username
                 avatarURL:(NSString *)avatarURL
                   caption:(NSString *)caption
                  comments:(NSArray *)comments
                     likes:(NSInteger)likes
                      time:(NSTimeInterval)time;

@end

@interface LAVComment : NSObject

@property(nonatomic, strong) NSString *fromUserName;
@property(nonatomic, strong) NSString *text;

+ (LAVComment *)getCommentWith:(NSString *)fromUserName
                       andText:(NSString *)text;

@end

@interface LAVUser : NSObject

@property(nonatomic, assign) long posts;
@property(nonatomic, assign) long followers;
@property(nonatomic, assign) long follows;
@property(nonatomic, strong) NSString *profilePic;
@property(nonatomic, strong) NSString *username;

+ (LAVUser *)getUserWith:(long)posts
               followers:(long)followers
                 follows:(long)follows
              profilePic:(NSString *)photo
                username:(NSString *)username;

@end

@interface LAVInstagramObj : NSObject
@end
