//
//  LAVInstagramObj.m
//  LAVInstaClient
//
//  Created by Andrew Lebedev on 15.12.15.
//  Copyright © 2015 Andrew Lebedev. All rights reserved.
//

#import "LAVInstagramObj.h"
#import "LAVServerManager.h"

@implementation LAVInstagramObj

@end

@implementation LAVMedia

+ (LAVMedia *)getMediaWith:(NSString *)takenPhoto
                    userid:(NSString *)user_id
                  username:(NSString *)username
                 avatarURL:(NSString *)avatarURL
                   caption:(NSString *)caption
                  comments:(NSArray *)comments
                     likes:(NSInteger)likes
                      time:(NSTimeInterval)time {

  LAVMedia *media = [[LAVMedia alloc] init];

  media.takenPhoto = takenPhoto;
  media.user_id = user_id;
  media.username = username;
  media.avatarURL = avatarURL;
  media.caption = caption;
  media.comments = comments;
  media.likes = likes;
  media.time = time;

  return media;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"takenPhoto : %@, caption : %@, comments "
                                    @": %@, username : %@, time : %f",
                                    self.takenPhoto, self.caption,
                                    self.comments, self.username, self.time];
}

@end

@implementation LAVUser

+ (LAVUser *)getUserWith:(NSInteger)posts
               followers:(NSInteger)followers
                 follows:(NSInteger)follows
              profilePic:(NSString *)photo
                username:(NSString *)username {
  LAVUser *user = [[LAVUser alloc] init];

  user.posts = posts;
  user.followers = followers;
  user.follows = follows;
  user.profilePic = photo;
  user.username = username;

  return user;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"posts : %ld, followers : %ld, follows : "
                                    @"%ld, profile_photo : %@, username : %@",
                                    self.posts, self.followers, self.follows,
                                    self.profilePic, self.username];
}

@end

@implementation LAVComment

+ (LAVComment *)getCommentWith:(NSString *)fromUserName
                       andText:(NSString *)text {
  LAVComment *comment = [[LAVComment alloc] init];

  comment.fromUserName = fromUserName;
  comment.text = text;

  return comment;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"comment : %@, text : %@",
                                    self.fromUserName, self.text];
}

@end