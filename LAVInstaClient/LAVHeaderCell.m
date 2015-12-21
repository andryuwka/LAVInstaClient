//
//  LAVHeaderCell.m
//  LAVInstaClient
//
//  Created by Andrew Lebedev on 14.12.15.
//  Copyright © 2015 Andrew Lebedev. All rights reserved.
//

#import "LAVHeaderCell.h"
#import "DateTools.h"
#import "SAMCache.h"

@interface LAVHeaderCell ()

@property(nonatomic, weak) IBOutlet UIImageView *headPic;
@property(nonatomic, weak) IBOutlet UILabel *headUsername;
@property(nonatomic, weak) IBOutlet UILabel *headTime;

@end

@implementation LAVHeaderCell

- (void)setMedia:(LAVMedia *)media {
  self.headUsername.text = media.username;
  self.headTime.text = @"0h";
  NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:media.time];
  // self.headTime.text = date.shortTimeAgoSinceNow;
  self.headTime.text = date.timeAgoSinceNow;

  __block NSString *urlStr = media.avatarURL;
  NSURL *url = [NSURL URLWithString:urlStr];
  __block SAMCache *cache = [SAMCache sharedCache];
  __block UIImage *image = cache[urlStr];
  if (image == nil) {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task =
        [session dataTaskWithURL:url
               completionHandler:^(NSData *_Nullable data,
                                   NSURLResponse *_Nullable response,
                                   NSError *_Nullable error) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                   image = [UIImage imageWithData:data];
                   cache[urlStr] = image;
                   [self.headPic setImage:image];
                 });
               }];
    [task resume];
  } else {
    [self.headPic setImage:image];
  }
}

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
