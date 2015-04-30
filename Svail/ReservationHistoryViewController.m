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
#import "ReservationTableViewCell.h"

@interface ReservationHistoryViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *servicesTableView;
@property (nonatomic) User *currentUser;
@property (nonatomic) NSMutableArray *serviceSlots;

@end

@implementation ReservationHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentUser = [User currentUser];
    
    PFQuery *serviceQuery = [ServiceSlot query];
    [serviceQuery whereKey:@"participants" equalTo:self.currentUser];
    [serviceQuery orderByDescending:@"startDate"];
    serviceQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [serviceQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,
                                                     NSError *error)
     {
         if (!error)
         {
             self.serviceSlots = objects.mutableCopy;
             [self.servicesTableView reloadData];
         }
     }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu",self.serviceSlots.count);
    return self.serviceSlots.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReservationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReservationCell"];
    cell.serviceSlot = self.serviceSlots[indexPath.row];
    [cell awakeFromNib];
    return cell;
}


@end
