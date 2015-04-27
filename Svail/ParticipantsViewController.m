//
//  ParticipantsViewController.m
//  Svail
//
//  Created by Mert Akanay on 4/19/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

//#import "ParticipantsViewController.h"
//#import "User.h"
//#import "Service.h"
//#import "UserProfileViewController.h"
//#import "Verification.h"
//
//@interface ParticipantsViewController () <UITableViewDataSource, UITableViewDelegate>
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
//
//@end
//
//@implementation ParticipantsViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
//    User *theUser = [self.participants objectAtIndex:indexPath.row];
//    cell.textLabel.text = theUser.name;
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"Safety level:%ld",(long)theUser.verification.safetyLevel];
//
//    [theUser.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//        if (!error) {
//            UIImage *image = [UIImage imageWithData:data];
//            cell.imageView.image = image;
//            cell.imageView.layer.cornerRadius = cell.imageView.frame.size.height / 2;
//            cell.imageView.layer.masksToBounds = YES;
//            cell.imageView.layer.borderWidth = 1.5;
//            cell.imageView.clipsToBounds = YES;
//            [cell layoutSubviews];
//        }
//    }];
//
//    return cell;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.participants.count;
//}
//
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    UserProfileViewController *userProfVC = [segue destinationViewController];
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    User *theUser = [self.participants objectAtIndex:indexPath.row];
//    userProfVC.selectedUser = theUser;
//}
//
//@end
