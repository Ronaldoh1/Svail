//
//  HistoryViewController.m
//  Svail
//
//  Created by zhenduo zhu on 4/27/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "PostHistoryViewController.h"
#import "Service.h"
#import "ServiceSlot.h"
#import "User.h"
#import "Image.h"
#import "PostTableViewCell.h"
#import "PostViewController.h"
#import "PostServiceSlotsViewController.h"
#import "MBProgressHUD.h"

@interface PostHistoryViewController () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic) NSMutableArray *services;
@property (nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UITableView *servicesTableView;
@property (nonatomic) Service *serviceToDelete;
@property (nonatomic) Service *serviceToEdit;
@property (nonnull) UILabel *noPostLabel;

@end

@implementation PostHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.servicesTableView.hidden = true;
    [self configureTableView];
    self.currentUser = [User currentUser];
    [self loadPostedServices];
}

-(void)configureTableView
{
    self.servicesTableView.rowHeight = UITableViewAutomaticDimension;
    self.servicesTableView.estimatedRowHeight = 200;
//    self.servicesTableView.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0.);
}

-(void)loadPostedServices
{
    PFQuery *serviceQuery = [Service query];
    [serviceQuery whereKey:@"provider" equalTo:self.currentUser];
    [serviceQuery orderByDescending:@"createdAt"];
//    serviceQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    serviceQuery.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [serviceQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,
                                                 NSError *error)
     {
         if (!error) {
             if (objects.count == 0) {
                 [self presentNoPostLabel];
                 self.servicesTableView.hidden = true;
                 
             } else {
                 [self removeNoPostLabel];
                 self.servicesTableView.hidden = false;
                 self.services = objects.mutableCopy;
                 [self.servicesTableView reloadData];
//                 [self.servicesTableView setNeedsDisplay];
                 [self.servicesTableView layoutIfNeeded];
                 [self.servicesTableView reloadData];
             }
         }
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }]; 
}

-(void)presentNoPostLabel
{
    CGRect viewBounds = self.view.bounds;
    CGRect labelFrame = CGRectMake(viewBounds.origin.x + viewBounds.size.width / 2. - 100., 150. - 20., 200., 40.);
    self.noPostLabel = [[UILabel alloc]initWithFrame:labelFrame];
    self.noPostLabel.text = @"You have no post.";
    self.noPostLabel.textAlignment = NSTextAlignmentCenter;
    self.noPostLabel.textColor = [UIColor lightGrayColor];
    self.noPostLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:self.noPostLabel];
}

-(void)removeNoPostLabel
{
    [self.noPostLabel removeFromSuperview];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.services.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    cell.vc = self;
    cell.service = self.services[indexPath.row];
    cell.tag = indexPath.row;
    [cell setupContent];

    return cell;
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%f",cell.contentView.bounds.size.width);
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender
{
    if ([segue.identifier isEqualToString:@"PostHistoryToServiceSlotsSegue"]) {
        PostServiceSlotsViewController *serviceSlotsVC = segue.destinationViewController;
        serviceSlotsVC.service = self.services[sender.tag];
    }
    
}

- (IBAction)onDeleteButtonTapped:(UIButton *)sender
{
    self.serviceToDelete = self.services[sender.tag];
    NSString *message = [NSString stringWithFormat:@"Press OK to confirm deleting: %@. Only unfinished service slots without reservations will be deleted", self.serviceToDelete.title];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alert.tag = 1;
    [alert show];
}

- (IBAction)onEditButtonTapped:(UIButton *)sender
{
    
    self.serviceToEdit = self.services[sender.tag];

    UIStoryboard *postStoryboard = [UIStoryboard storyboardWithName:@"Post" bundle:nil];
    UINavigationController *postNavVC = [postStoryboard instantiateViewControllerWithIdentifier:@"PostNavBar"];
    PostViewController *postVC =  postNavVC.childViewControllers[0];
    postVC.serviceToEdit =  self.serviceToEdit;
    [self presentViewController:postNavVC animated:true completion:nil];

    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            
            [self.serviceToDelete deleteServiceWithCompletion:^(BOOL shouldDeleteService)
            {
                if (shouldDeleteService) {
                    [self.services removeObject:self.serviceToDelete];
                    [self.servicesTableView reloadData];
                }
            }];
        }
    }

}

@end
