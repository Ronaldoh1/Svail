//
//  HistoryViewController.m
//  Svail
//
//  Created by zhenduo zhu on 4/27/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "PostHistoryViewController.h"
#import "Service.h"
#import "User.h"
#import "Image.h"
#import "PostTableViewCell.h"
#import "EditPostViewController.h"

@interface PostHistoryViewController () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic) NSMutableArray *services;
@property (nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UITableView *servicesTableView;
@property (nonatomic) Service *serviceToDelete;

@end

@implementation PostHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentUser = [User currentUser];
    
    PFQuery *serviceQuery = [Service query];
    [serviceQuery whereKey:@"provider" equalTo:self.currentUser];
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
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    cell.service = self.services[indexPath.row];
    cell.tag = indexPath.row;
    [cell awakeFromNib];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender
{
    if ([segue.identifier isEqualToString:@"PostHistoryToEditPostSegue"]) {
        EditPostViewController *editPostVC = segue.destinationViewController;
        editPostVC.service = self.services[sender.tag];
    }
    
}

- (IBAction)onDeleteButtonTapped:(UIButton *)sender
{
    self.serviceToDelete = self.services[sender.tag];
    NSString *message = [NSString stringWithFormat:@"Delete %@?", self.serviceToDelete.title];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alert.tag = 1;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            PFQuery *imageQuery = [Image query];
            [imageQuery whereKey:@"service" equalTo:self.serviceToDelete];
            [imageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,
                                                 NSError *error)
             {
                 if (!error) {
                     for (Image *image in objects) {
                         [image deleteInBackground];
                     }
                 }
             }];
            
            [self.serviceToDelete deleteInBackground];
            [self.services removeObject:self.serviceToDelete];
            [self.servicesTableView reloadData];
        }
        self.serviceToDelete = nil;
    }

}

@end
