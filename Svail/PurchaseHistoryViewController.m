//
//  PurchaseHistoryViewController.m
//  Svail
//
//  Created by zhenduo zhu on 4/22/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "PurchaseHistoryViewController.h"
#import <Parse/Parse.h>
#import "Service.h"

@interface PurchaseHistoryViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *requestedServices;
@property NSIndexPath *serviceIndexPath;

@end

@implementation PurchaseHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    PFQuery *query = [Service query];
    [query includeKey:@"provider"];
    [query whereKey:@"participants" equalTo:[User currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (!error) {

            self.requestedServices = objects.mutableCopy;

            [self.tableView reloadData];

        } else {

            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];

    Service *requestedService = self.requestedServices[indexPath.row];

    cell.textLabel.text = requestedService.title;
    cell.detailTextLabel.text = requestedService.provider.name;

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.requestedServices.count;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle ==UITableViewCellEditingStyleDelete){
        self.serviceIndexPath = indexPath;

        [self displayAlert];
    }
}

-(void) displayAlert{

    NSDate *currentDate = [NSDate date];
    Service *theService = self.requestedServices[self.serviceIndexPath.row];
    NSDate *serviceDate = [theService objectForKey:@"startDate"];
    NSDate *serviceTimeMinus3h = [serviceDate dateByAddingTimeInterval:-3*60*60];

    if ([currentDate compare:serviceTimeMinus3h] == NSOrderedAscending)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Request?" message:@"Are you sure want to delete your request for this service from Svail? No cost will be reflected to your account." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];

        [alert show];
    }
    else if ([currentDate compare:serviceTimeMinus3h] == NSOrderedDescending || [currentDate isEqualToDate:serviceTimeMinus3h] || [currentDate compare:serviceDate] == NSOrderedAscending)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Request?" message:@"Are you sure want to delete your request for this service from Svail? The cost for delete will be %15 of the service price." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];

        [alert show];
    }
    else if ([currentDate compare:serviceDate] == NSOrderedDescending)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Request?" message:@"Are you sure want to delete your request for this service from Svail? The cost for delete will be full service price." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];

        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) {

    }else{

        Service *theService = self.requestedServices[self.serviceIndexPath.row];
        [theService deleteInBackground];
        [self.requestedServices removeObjectAtIndex:self.serviceIndexPath.row];
        [self.tableView reloadData];

    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{

    return @"Delete Purchase";
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//}

- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender {

    UIStoryboard *mapStoryBoard = [UIStoryboard storyboardWithName:@"Map" bundle:nil];
    UIViewController *mapTabVC = [mapStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBarVC"];
    [self presentViewController:mapTabVC animated:true completion:nil];
}

@end
