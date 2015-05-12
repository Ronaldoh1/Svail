//
//  PostServiceSlotsViewController.m
//  Svail
//
//  Created by zhenduo zhu on 5/9/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "PostServiceSlotsViewController.h"
#import "PostServiceSlotTableViewCell.h"
#import "Image.h"

@interface PostServiceSlotsViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *serviceSlotsTableView;
@property (nonatomic) NSMutableArray *serviceSlots;

@end

@implementation PostServiceSlotsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Noteworthy" size:15];
    titleView.text = self.service.title;
    titleView.textColor = [UIColor colorWithRed:21/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
    [self.navigationItem setTitleView:titleView];
    
    PFQuery *serviceSlotQuery = [ServiceSlot query];
    [serviceSlotQuery whereKey:@"service" equalTo:self.service];
    [serviceSlotQuery includeKey:@"service"];
    [serviceSlotQuery includeKey:@"participants"];
    serviceSlotQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [serviceSlotQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,
                                                         NSError *error)
     {
         if (!error)
         {
             self.serviceSlots = objects.mutableCopy;
             NSSortDescriptor *startTimeSD = [[NSSortDescriptor alloc]initWithKey:@"startTime" ascending:true];
//             NSSortDescriptor *participantCountSD = [[NSSortDescriptor alloc]initWithKey:@"participants.@count" ascending:false];
             [self.serviceSlots sortUsingDescriptors:@[startTimeSD]];
             [self.serviceSlotsTableView reloadData];
         }
     }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.serviceSlots.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostServiceSlotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostServiceSlotCell"];
    cell.vc = self;
    cell.service = self.service;
    cell.serviceSlot = self.serviceSlots[indexPath.row];
    [cell awakeFromNib];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceSlot *serviceSlot = self.serviceSlots[indexPath.row];
    return serviceSlot.participants.count == 0;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ServiceSlot *serviceSlot = self.serviceSlots[indexPath.row];
        [serviceSlot deleteInBackground];
        [self.serviceSlots removeObject:serviceSlot];
        [self.serviceSlotsTableView reloadData];
        [self.service.startTimes removeObject:serviceSlot.startTime];
        [self.service saveInBackground];
        
        if (self.serviceSlots.count == 0) {
            PFQuery *imageQuery = [Image query];
            [imageQuery whereKey:@"service" equalTo:self.service];
            [imageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
            {
                  if (!error) {
                      for (Image *image in objects) {
                          [image deleteInBackground];
                      }
                  }
            }];
            [self.service deleteInBackground];
        }
    }
}


@end
