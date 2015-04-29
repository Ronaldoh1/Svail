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
#import "ReservationTableViewCell.h"

@interface ReservationHistoryViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *servicesTableView;
@property (nonatomic) User *currentUser;
@property (nonatomic) NSMutableArray *services;

@end

@implementation ReservationHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentUser = [User currentUser];
    
    PFQuery *serviceQuery = [Service query];
    [serviceQuery whereKey:@"participants" equalTo:self.currentUser];
    [serviceQuery orderByDescending:@"startDate"];
    serviceQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [serviceQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,
                                                     NSError *error)
     {
         if (!error)
         {
             self.services = objects.mutableCopy;
             [self.servicesTableView reloadData];
         }
     }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu",self.services.count);
    return self.services.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReservationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReservationCell"];
    cell.service = self.services[indexPath.row];
    [cell awakeFromNib];
    return cell;
}


@end
