//
//  HistoryViewController.m
//  Svail
//
//  Created by zhenduo zhu on 4/27/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "NewPostHistoryViewController.h"
#import "Service.h"
#import "User.h"
#import "PostTableViewCell.h"
#import "EditPostViewController.h"

@interface NewPostHistoryViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) NSMutableArray *services;
@property (nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UITableView *servicesTableView;

@end

@implementation NewPostHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentUser = [User currentUser];
    
    PFQuery *serviceQuery = [Service query];
    [serviceQuery whereKey:@"provider" equalTo:self.currentUser];
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




@end
