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
#import "EditPostViewController.h"
#import "PostViewController.h"

@interface PostHistoryViewController () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic) NSMutableArray *serviceSlots;
@property (nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UITableView *servicesTableView;
@property (nonatomic) Service *serviceSlotToDelete;

@end

@implementation PostHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentUser = [User currentUser];
    
    PFQuery *serviceQuery = [Service query];
    [serviceQuery whereKey:@"provider" equalTo:self.currentUser];
    PFQuery *serviceSlotQuery = [ServiceSlot query];
    [serviceSlotQuery whereKey:@"service" matchesQuery:serviceQuery];
    [serviceSlotQuery includeKey:@"service"];
    [serviceSlotQuery includeKey:@"participants"];
    [serviceSlotQuery orderByDescending:@"createdAt"];
    serviceSlotQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [serviceSlotQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,
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
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    cell.serviceSlot = self.serviceSlots[indexPath.row];
    cell.tag = indexPath.row;
    [cell awakeFromNib];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender
{
    if ([segue.identifier isEqualToString:@"PostHistoryToEditPostSegue"]) {
        EditPostViewController *editPostVC = segue.destinationViewController;
        editPostVC.service = self.serviceSlots[sender.tag];
    }
    
}

- (IBAction)onDeleteButtonTapped:(UIButton *)sender
{
    self.serviceSlotToDelete = self.serviceSlots[sender.tag];
    NSString *message = [NSString stringWithFormat:@"Delete %@?", self.serviceSlotToDelete.title];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alert.tag = 1;
    [alert show];
}

- (IBAction)onEditButtonTapped:(UIButton *)sender
{
    UIStoryboard *postStoryboard = [UIStoryboard storyboardWithName:@"Post" bundle:nil];
    UINavigationController *postNavVC = [postStoryboard instantiateViewControllerWithIdentifier:@"PostNavBar"];
    PostViewController *postVC =  postNavVC.childViewControllers[0];
    postVC.service =  ((ServiceSlot *)self.serviceSlots[sender.tag]).service;
    [self presentViewController:postNavVC animated:true completion:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            PFQuery *imageQuery = [Image query];
            [imageQuery whereKey:@"service" equalTo:self.serviceSlotToDelete];
            [imageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,
                                                 NSError *error)
             {
                 if (!error) {
                     for (Image *image in objects) {
                         [image deleteInBackground];
                     }
                 }
             }];
            
            [self.serviceSlotToDelete deleteInBackground];
            [self.serviceSlots removeObject:self.serviceSlotToDelete];
            [self.servicesTableView reloadData];
        }
        self.serviceSlotToDelete = nil;
    }

}

@end
