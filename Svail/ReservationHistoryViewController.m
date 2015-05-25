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

@end

@implementation ReservationHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentUser = [User currentUser];
    
}

-(void)viewWillAppear:(BOOL)animated
{
     self.currentUser = [User currentUser];
    
    PFQuery *reservationQuery = [Reservation query];
    [reservationQuery whereKey:@"reserver" equalTo:[User currentUser]];
    [reservationQuery includeKey:@"serviceSLot"];
    reservationQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [reservationQuery addDescendingOrder:@"createdAt"];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [reservationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,
                                                     NSError *error)
     {
         if (!error)
         {
             if (objects.count == 0) {
                 [self presentNoReservationLabel];
             } else {
                 self.reservations = objects.mutableCopy;
                 [self.servicesTableView reloadData];
             }
             
         }
     }];

        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

-(void)presentNoReservationLabel
{
    CGRect viewBounds = self.view.bounds;
    CGRect labelFrame = CGRectMake(viewBounds.origin.x + viewBounds.size.width / 2. - 120., 150., 240., 40.);
    UILabel *label = [[UILabel alloc]initWithFrame:labelFrame];
    label.text = @"You have no reservation.";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reservations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReservationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReservationCell"];
    
    cell.tag = indexPath.row;
    cell.vc = self;
    cell.reservation = self.reservations[indexPath.row];
    [cell awakeFromNib];
    return cell;
}


@end
