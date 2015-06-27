//
//  ReservationHistoryViewController.m
//  Svail
//
//  Created by zhenduo zhu on 4/28/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "ReservationHistoryViewController.h"
#import "User.h"
#import "Service.h"
#import "ServiceSlot.h"
#import "Reservation.h"
#import "ReservationTableViewCell.h"
#import "MBProgressHUD.h"

@interface ReservationHistoryViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *servicesTableView;
@property (nonatomic) User *currentUser;
@property (nonatomic) NSMutableArray *reservations;
@property (nonatomic) UILabel *noReservationLabel;


@end

@implementation ReservationHistoryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.servicesTableView.rowHeight = UITableViewAutomaticDimension;
    self.servicesTableView.estimatedRowHeight = 200;
    self.currentUser = [User currentUser];
//    [self loadReservations];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.servicesTableView.rowHeight = UITableViewAutomaticDimension;
    self.servicesTableView.estimatedRowHeight = 200;
//    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.servicesTableView.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    self.currentUser = [User currentUser];
    [self loadReservations];
}

-(void)loadReservations
{
    PFQuery *reservationQuery = [Reservation query];
    [reservationQuery whereKey:@"reserver" equalTo:[User currentUser]];
    [reservationQuery includeKey:@"serviceSlot.service.provider.verification"];
    [reservationQuery includeKey:@"serviceSlot.participants"];
    reservationQuery.cachePolicy = kPFCachePolicyNetworkElseCache;
    [reservationQuery addDescendingOrder:@"createdAt"];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [reservationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,
                                                         NSError *error)
     {
         if (!error)
         {
             if (objects.count == 0) {
                 [self presentNoReservationLabel];
             } else {
                 [self removeNoReservationLabel];
                 self.reservations = objects.mutableCopy;
                 [self.servicesTableView reloadData];
                 [self.servicesTableView setNeedsDisplay];
                 [self.servicesTableView layoutIfNeeded];
                 [self.servicesTableView reloadData];
             }
         }
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
     }];
}

-(void)presentNoReservationLabel
{
    CGRect viewBounds = self.view.bounds;
    CGRect labelFrame = CGRectMake(viewBounds.origin.x + viewBounds.size.width / 2. - 120., 150., 240., 40.);
    self.noReservationLabel = [[UILabel alloc]initWithFrame:labelFrame];
    self.noReservationLabel.text = @"You have no reservation.";
    self.noReservationLabel.textAlignment = NSTextAlignmentCenter;
    self.noReservationLabel.textColor = [UIColor lightGrayColor];
    self.noReservationLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:self.noReservationLabel];
}

-(void)removeNoReservationLabel
{
    [self.noReservationLabel removeFromSuperview];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reservations.count;
//    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReservationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReservationCell"];
    
    cell.tag = indexPath.row;
    cell.vc = self;
    cell.reservation = self.reservations[indexPath.row];
    [cell setupContent];

    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%f",cell.frame.size.height);
}


@end
