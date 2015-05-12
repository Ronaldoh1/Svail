//
//  PickTimeSlotViewController.m
//  Svail
//
//  Created by zhenduo zhu on 4/29/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "PickTimeSlotViewController.h"
#import "CustomSelectTimeCell.h"

@interface PickTimeSlotViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *timeSlotsCollectionView;
@property (nonatomic) NSArray *availableSlots;
@property (nonatomic) ServiceSlot *serviceSlot;

@end

@implementation PickTimeSlotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   [self.service checkAvailableSlotsWithCompletion:^(NSArray *serviceSlots) {
       self.availableSlots = [[serviceSlots valueForKeyPath:@"startTime"] sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2)
       {
           if ([obj1 integerValue] >= [obj2 integerValue]) {
               return NSOrderedDescending;
           } else {
               return NSOrderedAscending;
           }
       }];
       [self.timeSlotsCollectionView reloadData];
   }];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.availableSlots.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomSelectTimeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TimeSlotCell" forIndexPath:indexPath];
    NSUInteger startTime = [self.availableSlots[indexPath.row] integerValue];
    NSUInteger startHour = (floor)((double)startTime / 60. /60.);
    NSUInteger startMinutes = (startTime - startHour * 60 * 60)/60;
    
    NSUInteger endTime = startTime + self.service.durationTime * 3600;
    NSUInteger endHour = (floor)((double)endTime / 60. /60.);
    NSUInteger endMinutes = (endTime - endHour * 60 * 60)/60;
                       
    cell.timeLabel.text = [NSString stringWithFormat:@"%02lu:%02lu -- %02lu:%02lu", (long)startHour,(long)startMinutes, (long)endHour, (long)endMinutes];
    
    cell.layer.borderWidth = 2.0f;
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.userInteractionEnabled = true;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PFQuery *query = [ServiceSlot query];
    [query whereKey:@"startTime" equalTo:self.availableSlots[indexPath.row]];
    [query whereKey:@"service" equalTo:self.service];
    [query includeKey:@"service"];
    [query includeKey:@"participants"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            self.serviceSlot = (ServiceSlot *)object;
            self.reviewVC.serviceSlot = self.serviceSlot;
            [self.navigationController popViewControllerAnimated:YES];
//            [self performSegueWithIdentifier:@"BackToReviewSegue" sender:self];
        }
    }];
}


- (IBAction)onCancelButtonTapped:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
