//
//  LAVFeedTVC.h
//  LAVInstaClient
//
//  Created by Andrew Lebedev on 13.12.15.
//  Copyright © 2015 Andrew Lebedev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LAVInstagramObj.h"

@interface LAVFeedTVC : UITableViewController

@property(nonatomic, weak, readwrite) IBOutlet UIImageView *iwUser;
@property(nonatomic, weak, readwrite) IBOutlet UILabel *labelPosts;
@property(nonatomic, weak, readwrite) IBOutlet UILabel *labelFollowers;
@property(nonatomic, weak, readwrite) IBOutlet UILabel *labelFollowing;
@property(nonatomic, weak, readwrite) IBOutlet UIView *viewProfile;
@property(nonatomic, weak, readwrite) IBOutlet UIButton *buttonLogout;

@property(nonatomic, strong, readwrite) NSArray *medias;
@property(nonatomic, strong, readwrite) LAVUser *user;
@property(nonatomic, assign, readwrite) BOOL flag;

- (void)authorize;
- (IBAction)logout:(id)sender;

@end
