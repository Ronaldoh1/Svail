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

@interface SelectTimeSlotsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UISlider *durationSlider;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property NSDate *timeForCell;
@property double durationTime;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *clearTimeSlotButtons;
@property NSMutableArray *selectedCellArray;
@property GenerateTimeSlot *timeSlot;
@property NSArray *timesArray;
@property (weak, nonatomic) IBOutlet UILabel *directionsLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveTimesButton;


@end

@implementation SelectTimeSlotsViewController

static NSString *const kReusableIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    [self performInitialSetUp];

}
//helper Method for initial set up
-(void)performInitialSetUp{

    //set slider
    [self.durationSlider setValue:0.5];
    //initially disable the save button
    self.saveTimesButton.enabled = false;

    //set the clear button color, background and roud
    self.clearTimeSlotButtons.tintColor = [UIColor whiteColor];
    self.clearTimeSlotButtons.backgroundColor = [UIColor colorWithRed:255/255.0 green:127/255.0 blue:59/255.0 alpha:1.0];


    //set navigation title color and text
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0 green:127/255.0 blue:59/255.0 alpha:1.0];

    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Noteworthy" size:20];
    titleView.text = @"Time Slots";
    titleView.textColor = [UIColor colorWithRed:21/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
    [self.navigationItem setTitleView:titleView];

    //set the directions label color
    self.directionsLabel.textColor = [UIColor colorWithRed:255/255.0 green:127/255.0 blue:59/255.0 alpha:1.0];
    //set the duration label color

    self.durationLabel.textColor = [UIColor colorWithRed:255/255.0 green:127/255.0 blue:59/255.0 alpha:1.0];

    self.durationSlider.tintColor = [UIColor colorWithRed:59/255.0 green:185/255.0 blue:255/255.0 alpha:1.0];
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

    //check if the service start time is empty ....if it is instantiate it.
    if (self.service.startTimes == nil) {

        self.service.startTimes = [NSMutableArray new];
    }


    //setup color tint and title color
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor orangeColor]forKey:NSForegroundColorAttributeName];
    

}
//Getting the duration for each service
- (IBAction)timeSlotSetter:(UISlider *)sender {

    self.durationTime = (double)(roundf(sender.value / 0.5f) * 0.5f);

    if (self.durationTime == 1) {
        self.durationLabel.text = [NSString stringWithFormat:@"%.01f hour",self.durationTime];


    }else {
        self.durationLabel.text = [NSString stringWithFormat:@"%.01f hours",self.durationTime];

    }

}
//on cancel go back to Post View Controller
- (IBAction)onCancelButton:(UIBarButtonItem *)sender {



}

- (IBAction)onClearButtonPressed:(UIButton *)sender {

    for(int i = 0; i < self.selectedCellArray.count; i++){

        [self.collectionView cellForItemAtIndexPath:self.selectedCellArray[i]].userInteractionEnabled = true;
        [self.collectionView cellForItemAtIndexPath:self.selectedCellArray[i]].backgroundColor = [UIColor whiteColor];


    }
    //remove all the indexPaths from the selected Cells Arrays
    [self.selectedCellArray removeAllObjects];

    //remove all the start times from service
    [self.service.startTimes removeAllObjects];

    //disable the save button as there are no times slots selected.
    self.saveTimesButton.enabled = false;

    //enable the slider again so the user can reselect new timeslot duration
    self.durationSlider.enabled = true;

}
- (IBAction)onSaveButtonPressed:(UIBarButtonItem *)sender {

}


#pragma marks - UICollectionView DataSource Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.timesArray.count;
}
-(CustomSelectTimeCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    CustomSelectTimeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReusableIdentifier forIndexPath:indexPath];


    //    cell.timeLabel.userInteractionEnabled = YES;
    cell.userInteractionEnabled = true;
    //    [cell.timeLabel addGestureRecognizer:tapGestureOnPhoto];

    //set the text color for the label for each cell
    cell.timeLabel.textColor = [UIColor colorWithRed:59/255.0 green:185/255.0 blue:255/255.0 alpha:1.0];

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
            cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:127/255.0 blue:59/255.0 alpha:1.0];

        }
    }



    return cell;
}

#pragma marks - UICollectionView Delegate Methods.


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    //get the number of cell to disable
    int numberOfCellsToDisable = (self.durationTime / .5);
    if (numberOfCellsToDisable == 0) {
        [self displayAlertForNoDurationTimeSelected];

    }else {

    //get the duration time and disable slider.
    self.service.durationTime = self.durationTime;
    self.durationSlider.enabled = false;

    [self.service.startTimes addObject: self.timesArray[indexPath.row]];

    NSLog(@"start times is at %@", self.service.startTimes);

    NSLog(@"%d",numberOfCellsToDisable);

    BOOL allDone = NO;

    //calculate the cells to be set as selected.
    for (int i = (int)(indexPath.row); i < (int)(indexPath.row) + numberOfCellsToDisable; i++) {
        //get the indexPaths of the selected cells to be added to the selected cells arrays.
        NSIndexPath *someIndexPath = [NSIndexPath indexPathForRow:i inSection:0];

        if (self.selectedCellArray.count != 0){

        //check if the any of the indexPaths are already included in the selectedCellArray.
        for (int j = 0; j<self.selectedCellArray.count; j++) {
           // NSIndexPath *alreadySelectedIndexPath = self.selectedCellArray[j];

            //if the indextPath has already been added to the selectedCellsArray ...print error
            if ([self.selectedCellArray containsObject:someIndexPath]){



                [self displayAlertWhenTimesOverlap];
                allDone = true;
                break;

            //else add the indexpath to the cell
            }else{
                NSLog(@"adding cell to selected cell");


                [self.selectedCellArray addObject:someIndexPath];
                break;

            }
         }
        }else{
            NSLog(@"adding cell to selected cell");


            [self.selectedCellArray addObject:someIndexPath];

        }

        if (allDone) {
            break;
        }

    }

    //highlight the selected cells and also disable them.
    for (int i = 0; i < self.selectedCellArray.count; i++) {

        NSIndexPath *someIndexPath = self.selectedCellArray[i];

        [collectionView cellForItemAtIndexPath:someIndexPath].backgroundColor = [UIColor colorWithRed:255/255.0 green:127/255.0 blue:59/255.0 alpha:1.0];
        [collectionView cellForItemAtIndexPath:someIndexPath].userInteractionEnabled = false;
    }

    if (self.service.startTimes.count != 0){
        self.saveTimesButton.enabled = true;
    }
    }

}

#pragma marks - Alert View Delegate Method

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {

        for(int i = 0; i < self.selectedCellArray.count; i++){

            [self.collectionView cellForItemAtIndexPath:self.selectedCellArray[i]].userInteractionEnabled = true;
            [self.collectionView cellForItemAtIndexPath:self.selectedCellArray[i]].backgroundColor = [UIColor whiteColor];
            self.durationSlider.enabled = true;


        }

        [self.selectedCellArray removeAllObjects];
        [self.service.startTimes removeAllObjects];
    }
}


#pragma marks - alert messages

//Helper method to display success message to user.
-(void)displaySuccessMessage:(NSString *)text{


    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Success!" message:text delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
    
}

//display message to successfully show that the user's times have been saved.
-(void)displaySuccesfullTimeSelectionMessage{
    
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Success!" message:@"Your time slots have been saved!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
    
}
//display message when user user selects times that overlap.
-(void)displayAlertWhenTimesOverlap{


    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error in Times Selected!" message:@"Times Cannot Overlap - Please Try Again!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

    [alertView show];

}
-(void)displayAlertForNoTimesSelected{

    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"No Times Selected" message:@"You must select at least one time slot" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}
-(void)displayAlertForNoDurationTimeSelected{

    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"No Duration Time" message:@"Duration time cannot be 0 hours! Click Ok and try again. Thank you!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
