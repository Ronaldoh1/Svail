//
//  PickTimeSlotViewController.m
//  Svail
//
//  Created by zhenduo zhu on 4/29/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "PickTimeSlotViewController.h"
#import "CustomSelectTimeCell.h"
#import "ReviewReservationViewController.h"

@interface PickTimeSlotViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *timeSlotsCollectionView;

@end

@implementation PickTimeSlotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.service.startTimes.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomSelectTimeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TimeSlotCell" forIndexPath:indexPath];
    NSUInteger startTime = [self.service.startTimes[indexPath.row] integerValue];
    NSUInteger hour = (floor)((double)startTime / 60. /60.);
    NSUInteger minutes = (startTime - hour * 60 * 60)/60;
                       
    cell.timeLabel.text = [NSString stringWithFormat:@"%02lu:%02lu", hour,minutes];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BackToReviewSegue"]) {
        ReviewReservationViewController *reviewVC = segue.destinationViewController;
        NSUInteger indexOfTappedCell = [[self.timeSlotsCollectionView indexPathsForSelectedItems].lastObject row];
        self.serviceSlot = [ServiceSlot object];
        self.serviceSlot.service = self.service;
        self.serviceSlot.startTime = self.service.startTimes[indexOfTappedCell];
        [self.serviceSlot saveInBackground];
        reviewVC.serviceSlot = self.serviceSlot;
        reviewVC.service = self.service;
    }
}


@end
