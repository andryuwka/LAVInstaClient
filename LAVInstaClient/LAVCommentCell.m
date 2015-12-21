//
//  LAVCommentCell.m
//  LAVInstaClient
//
//  Created by Andrew Lebedev on 14.12.15.
//  Copyright © 2015 Andrew Lebedev. All rights reserved.
//

#import "LAVCommentCell.h"

@interface LAVCommentCell ()

@property(nonatomic, weak) IBOutlet UILabel *comments;

@end

@implementation LAVCommentCell

- (void)setComment:(LAVComment *)comment {
  NSString *line = [NSString
      stringWithFormat:@"%@ : %@", comment.fromUserName, comment.text];
  NSMutableAttributedString *attributedString =
      [[NSMutableAttributedString alloc] initWithString:line];
  NSRange range = [line rangeOfString:comment.fromUserName];
  [attributedString addAttribute:NSForegroundColorAttributeName
                           value:[UIColor blueColor]
                           range:range];
  self.comments.attributedText = attributedString;
}

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
