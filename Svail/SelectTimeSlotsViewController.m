//
//  SelectTimeSlotsViewController.m
//  Svail
//
//  Created by Ronald Hernandez on 4/26/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//
#import "CustomSelectTimeCell.h"
#import "SelectTimeSlotsViewController.h"
#import "GenerateTimeSlot.h"

@interface SelectTimeSlotsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UISlider *durationSlider;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property NSDate *timeForCell;
@property double durationTime;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *selectedCellArray;
@property GenerateTimeSlot *timeSlot;
@property NSArray *timesArray;


@end

@implementation SelectTimeSlotsViewController

static NSString *const kReusableIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //set the nsdate

    self.timeForCell = [NSDate date];

    self.selectedCellArray = [NSMutableArray new];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    [dateFormatter dateFromString:@"00:00"];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];

    self.timeSlot = [GenerateTimeSlot new];
    self.timesArray = [self.timeSlot generateTimesArrayInNSNumbers];

    //check if the service start tiem is empty ....if it is instantiate it.
    if (self.service.startTimes == nil) {

    self.service.startTimes = [NSMutableArray new];
    }

    //HIDE BACK BUTTON ITEM

    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;



}

//Getting the duration for each service
- (IBAction)timeSlotSetter:(UISlider *)sender {

    self.durationTime = (double)(roundf(sender.value / 0.5f) * 0.5f);
    self.durationLabel.text = [NSString stringWithFormat:@"%.01f hours",self.durationTime];


}



#pragma marks - UICollectionView DataSource Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 48;
}
-(CustomSelectTimeCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    CustomSelectTimeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReusableIdentifier forIndexPath:indexPath];

//    UITapGestureRecognizer  *tapGestureOnPhoto = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleCellTapped:)];
//    tapGestureOnPhoto.numberOfTapsRequired = 1;
//
//    cell.timeLabel.userInteractionEnabled = YES;
    cell.userInteractionEnabled = true;
//    [cell.timeLabel addGestureRecognizer:tapGestureOnPhoto];

    NSInteger hours = [self.timesArray[indexPath.row] integerValue] / 3600;

    NSInteger  minutes = ([self.timesArray[indexPath.row]integerValue] - hours * 3600) / 60;

    if (minutes == 0 && hours == 0) {
         cell.timeLabel.text  = [NSString stringWithFormat:@"%ld:0%ld",(long)hours, (long)minutes];
    }else if(minutes == 0){
         cell.timeLabel.text  = [NSString stringWithFormat:@"%ld:0%ld",(long)hours, (long)minutes];

    }else{
         cell.timeLabel.text  = [NSString stringWithFormat:@"%ld:%ld",(long)hours, (long)minutes];
    }




        cell.layer.borderWidth = 2.0f;



    cell.backgroundColor = [UIColor whiteColor];

    for (int i = 0; i<self.selectedCellArray.count; i++) {

        if(((NSIndexPath *)(self.selectedCellArray[i])).row == indexPath.row){

          cell.userInteractionEnabled = false;
            cell.backgroundColor = [UIColor blueColor];

        }
    }

//    for (int i = 0; i < self.selectedCellArray.count; i++) {
//
//        NSIndexPath *someIndexPath = self.selectedCellArray[i];
//
//
//        [collectionView cellForItemAtIndexPath:someIndexPath].userInteractionEnabled = false;
//        [collectionView cellForItemAtIndexPath:someIndexPath].backgroundColor = [UIColor blueColor];
//    }



    return cell;
}

#pragma marks - UICollectionView Delegate Methods.

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"%ld",(long)indexPath.row);


//    [collectionView cellForItemAtIndexPath:indexPath].userInteractionEnabled = false;

   // [collectionView cellForItemAtIndexPath:indexPath].userInteractionEnabled = false;

    [self.selectedCellArray addObject:indexPath];

    int numberOfCellsToDisable = (self.durationTime / .5);


    self.service.durationTime = self.durationTime;

    [self.service.startTimes addObject:
     self.timesArray[indexPath.row]];

    NSLog(@"start times is at %@", self.service.startTimes);

    NSLog(@"%d",numberOfCellsToDisable);

    for (int i = (int)(indexPath.row); i < (int)(indexPath.row) + numberOfCellsToDisable; i++) {

        NSIndexPath *someIndexPath = [NSIndexPath indexPathForRow:i inSection:0];

        [self.selectedCellArray addObject:someIndexPath];

//        [collectionView cellForItemAtIndexPath:someIndexPath].userInteractionEnabled = false;
//        [collectionView cellForItemAtIndexPath:someIndexPath].backgroundColor = [UIColor blueColor];
    }

    for (int i = 0; i < self.selectedCellArray.count; i++) {

        NSIndexPath *someIndexPath = self.selectedCellArray[i];


        [collectionView cellForItemAtIndexPath:someIndexPath].userInteractionEnabled = false;
        [collectionView cellForItemAtIndexPath:someIndexPath].backgroundColor = [UIColor blueColor];
    }


}

-(void)handleCellTapped{

    NSLog(@"cell has been tapped");
}

@end
