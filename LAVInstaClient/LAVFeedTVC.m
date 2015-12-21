#import "LAVFeedTVC.h"
#import "LAVServerManager.h"
#import "SimpleAuth.h"
#import "LAVInstagramObj.h"
#import "LAVPhotoCell.h"
#import "LAVCommentCell.h"
#import "LAVHeaderCell.h"

@interface LAVFeedTVC () {
  NSString *_accessToken;
}

@end

static NSString *MAGIC_CLIENT_ID = @"24fc1af302d3442c86e5e3c1e8708015";

@implementation LAVFeedTVC

- (void)viewDidLoad {
  [super viewDidLoad];
  [self initRecognizers];
  self.tableView.tableFooterView = [[UIView alloc] init];
  if (self.flag != YES) {
    self.flag = NO;
  }

  [self.tableView setEstimatedRowHeight:450];
  [self.tableView setRowHeight:UITableViewAutomaticDimension];
  [self.tableView registerNib:[UINib nibWithNibName:@"LAVHeaderCell" bundle:nil]
       forCellReuseIdentifier:@"Header"];

  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self
                          action:@selector(refreshData)
                forControlEvents:UIControlEventValueChanged];
  [self.tableView addSubview:self.refreshControl];

  [self refreshData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)refreshData {
  if (self.flag == NO) {
    [self fetchMediaData];
  } else {
    [self fetchUserData];
  }
  [self fetchUserInfo];

  [self.refreshControl endRefreshing];
}

- (void)fetchUserData {
  LAVServerManager *manager = [LAVServerManager sharedManager];
  [manager getMedia:@"userData"
      onSuccess:^(NSArray *result) {
        self.medias = result;
      }
      onFailure:^(NSError *error, NSInteger code) {
        NSLog(@"Error at - (void)fetchMediaData: " @" error = %@, code = %ld",
              [error localizedDescription], (long)code);
      }];
}

- (void)fetchUserInfo {
  LAVServerManager *manager = [LAVServerManager sharedManager];
  [manager getUserInfoOnSuccess:^(LAVUser *result) {
    self.user = result;
  } onFailure:^(NSError *error, NSInteger code) {
    NSLog(@"Error at - (void)fetchMediaData: " @" error = %@, code = %ld",
          [error localizedDescription], (long)code);
  }];
}

- (void)fetchMediaData {
  LAVServerManager *manager = [LAVServerManager sharedManager];
  [manager getMedia:@"feed"
      onSuccess:^(NSArray *result) {
        self.medias = result;
      }
      onFailure:^(NSError *error, NSInteger code) {
        NSLog(@"Error at - (void)fetchMediaData: " @" error = %@, code = %ld",
              [error localizedDescription], (long)code);
      }];
}

- (void)setMedias:(NSArray *)medias {
  _medias = medias;
  [self.tableView reloadData];
}

- (void)setUser:(LAVUser *)user {
  self.labelFollowers.text =
      [NSString stringWithFormat:@"Followers : %ld", user.followers];
  self.labelFollowing.text =
      [NSString stringWithFormat:@"Follows : %ld", user.follows];
  self.labelPosts.text = [NSString stringWithFormat:@"Posts : %ld", user.posts];
  if (self.flag == YES) {
    self.navigationItem.title = user.username;
  }

  NSURL *url = [NSURL URLWithString:user.profilePic];
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionTask *task =
      [session dataTaskWithURL:url
             completionHandler:^(NSData *_Nullable data,
                                 NSURLResponse *_Nullable response,
                                 NSError *_Nullable error) {
               dispatch_async(dispatch_get_main_queue(), ^{
                 UIImage *img = [UIImage imageWithData:data];
                 [self.iwUser setImage:img];
               });
             }];
  [task resume];
}

- (void)authorize {
  NSDictionary *authDict = [NSDictionary
      dictionaryWithObjectsAndKeys:@"bc694741e8ff4b249fe6f2dd34882017",
                                   @"client_id",
                                   @"LAVInstaClient://auth/instagram",
                                   SimpleAuthRedirectURIKey, nil];

  SimpleAuth.configuration[@"instagram"] = authDict;
  NSUserDefaults *userDefalts = [NSUserDefaults standardUserDefaults];

  NSString *token = [userDefalts stringForKey:@"accessToken"];

  if (token) {
    self->_accessToken = token;
    NSLog(@"Already Log In");

  } else {

    [SimpleAuth
         authorize:@"instagram"
        completion:^(id responseObject, NSError *error) {
          NSDictionary *credentials = responseObject[@"credentials"];
          NSString *t = credentials[@"token"];
          self->_accessToken = [NSString stringWithString:t];

          [userDefalts setObject:self->_accessToken forKey:@"accessToken"];
          [userDefalts synchronize];

        }];
  }
}

- (IBAction)logout:(id)sender {
  NSUserDefaults *userDefalts = [NSUserDefaults standardUserDefaults];
  [userDefalts setObject:nil forKey:@"accessToken"];
  self->_accessToken = @"";
  [userDefalts synchronize];
  [self fetchUserInfo];
}

- (void)initRecognizers {
  UITapGestureRecognizer *recognizer =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(headerTapped)];
  [self.viewProfile addGestureRecognizer:recognizer];
}

- (void)headerTapped {
  [self authorize];

  if (self.flag == NO) {
    UIStoryboard *storyboard =
        [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LAVFeedTVC *tvc =
        [storyboard instantiateViewControllerWithIdentifier:@"Feed"];
    tvc.flag = YES;

    dispatch_async(dispatch_get_main_queue(), ^{
      [self.navigationController pushViewController:tvc animated:YES];
    });
  }
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForFooterInSection:(NSInteger)section {
  return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 60.0;
}

- (UIView *)tableView:(UITableView *)tableView
    viewForFooterInSection:(NSInteger)section {
  UIView *footer = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
  footer.backgroundColor = [UIColor lightGrayColor];
  return footer;
}

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {
  NSString *headerCellId = @"Header";
  LAVHeaderCell *cell =
      [self.tableView dequeueReusableCellWithIdentifier:headerCellId];
  if (!cell) {
    cell = [[LAVHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:headerCellId];
  }
  [cell setMedia:self.medias[section]];
  [cell setFrame:CGRectMake(0, 0, cell.frame.size.width, 100)];

  return cell;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

  return [self.medias count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

  LAVMedia *media = self.medias[section];
  return [media.comments count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  NSString *photoCellId = @"PhotoCell";
  NSString *commentCellId = @"CommentCell";

  if (indexPath.row == 0) {
    LAVPhotoCell *cell =
        [tableView dequeueReusableCellWithIdentifier:photoCellId
                                        forIndexPath:indexPath];
    if (!cell) {
      cell = [[LAVPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:photoCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setMedia:self.medias[indexPath.section]];

    return cell;
  } else {
    LAVCommentCell *cell =
        [tableView dequeueReusableCellWithIdentifier:commentCellId
                                        forIndexPath:indexPath];
    if (!cell) {
      cell = [[LAVCommentCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:commentCellId];
    }
    self.tableView.separatorStyle =
        UITableViewCellSeparatorStyleSingleLineEtched;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    LAVMedia *tempMedia = self.medias[indexPath.section];
    LAVComment *tempComment = tempMedia.comments[indexPath.row - 1];
    [cell setComment:tempComment];

    return cell;
  }
}

@end
