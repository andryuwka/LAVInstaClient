//
//  LAVPhotoCell.m
//  LAVInstaClient
//
//  Created by Andrew Lebedev on 14.12.15.
//  Copyright © 2015 Andrew Lebedev. All rights reserved.
//

#import "LAVPhotoCell.h"
#import "SAMCache.h"

@interface LAVPhotoCell ()

@property(nonatomic, weak) IBOutlet UIImageView *photo;
@property(nonatomic, weak) IBOutlet UILabel *likes;
@property(nonatomic, weak) IBOutlet UILabel *info;

@end

@implementation LAVPhotoCell

- (void)setMedia:(LAVMedia *)media {

  self.info.text = [NSString stringWithFormat:@"%@", media.caption];
  self.likes.text = @"  ❤️:0";
  self.likes.text = [NSString stringWithFormat:@"  ❤️:%ld ", media.likes];

  __block NSString *urlStr = media.takenPhoto;
  NSURL *url = [NSURL URLWithString:media.takenPhoto];
  __block SAMCache *cache = [SAMCache sharedCache];
  __block UIImage *image = cache[media.takenPhoto];
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
                   [self.photo setImage:image];
                 });
               }];
    [task resume];
  } else {
    [self.photo setImage:image];
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
