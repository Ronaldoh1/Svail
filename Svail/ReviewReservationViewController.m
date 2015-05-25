//
//  ReviewPurchaseViewController.m
//  Svail
//
//  Created by zhenduo zhu on 4/22/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "ReviewReservationViewController.h"
#import "User.h"
#import "Verification.h"
#import "Service.h"
#import "ServiceSlot.h"
#import "Reservation.h"
#import "Rating.h"
#import "Image.h"
#import "ConfirmPurchaseViewController.h"
#import "CustomViewUtilities.h"
#import "RatingViewController.h"
#import "ServiceImagesCollectionViewCell.h"
#import "ParticipantCollectionViewCell.h"
#import "PickTimeSlotViewController.h"
#import "ProfileImageView.h"
#import "ServiceImageView.h"
#import "Report.h"


@interface ReviewReservationViewController () <UICollectionViewDelegate,UICollectionViewDataSource, UIActionSheetDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet ProfileImageView *providerProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *providerNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *safetyImageView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfServicesLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *servicePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceCapacityLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *participantsLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *serviceImagesCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *participantsCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *pickTimeSlotButton;



@property (nonatomic) User *currentUser;
@property (nonatomic) NSMutableArray *participants;
@property (nonatomic) NSMutableArray *serviceImageArray;
@property (nonatomic) User *provider;

@end

@implementation ReviewReservationViewController

static const CGFloat kLabelFontSize = 13.0;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
       //setup color tint
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0 green:127/255.0 blue:59/255.0 alpha:1.0];
    
    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Noteworthy" size:20];
    titleView.text = @"Review Reservation";
    titleView.textColor = [UIColor colorWithRed:21/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
    [self.navigationItem setTitleView:titleView];
    
    
   
    

    self.safetyImageView.hidden = true;
    self.currentUser = [User currentUser];
    

    
    PFQuery *serviceQuery = [Service query];
    [serviceQuery includeKey:@"provider.verification"];
//    [serviceQuery includeKey:@"participants"];
    serviceQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [serviceQuery getObjectInBackgroundWithId:self.service.objectId block:^(PFObject *object, NSError *error)
     {
         
         if (!error) {
             self.service = (Service *)object;

             self.provider = self.service.provider;

             self.providerNameLabel.text = self.service.provider.name;
             
             if ([[self.provider.verification objectForKey:@"safetyLevel"] integerValue] >= 5) {
                 self.safetyImageView.hidden = false;
             } else {
                 self.safetyImageView.hidden = true;
             }
             
             self.providerProfileImageView.user = self.provider;
             self.providerProfileImageView.vc = self;
             
             
             PFQuery *providerServicesQuery = [Service query];
             [providerServicesQuery whereKey:@"provider" equalTo:self.service.provider];
             providerServicesQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
             [providerServicesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
              {
                  if (!error) {
                      self.numOfServicesLabel.text = [NSString stringWithFormat:@"%lu",(long)(objects.count)];
                      
                  }

              }];
             
             
             PFQuery *providerServiceQuery = [Service query];
             [providerServiceQuery whereKey:@"provider" equalTo:self.service.provider];
             PFQuery *providerServiceSlotQuery = [ServiceSlot query];
             [providerServiceSlotQuery whereKey:@"service" matchesQuery:providerServiceQuery];
             PFQuery *providerRatingsQuery = [Rating query];
             [providerRatingsQuery whereKey:@"serviceSlot" matchesQuery:providerServiceSlotQuery];
             providerRatingsQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
             [providerRatingsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
              {
                  if (!error) {
                      self.ratingLabel.text = [NSString stringWithFormat:@"%.1f",[[objects valueForKeyPath:@"@avg.value"] doubleValue]];
                  } else {
                      self.ratingLabel.text = @"0";
                  }
              }];
             
             
         } else {
             //             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             //            [alert show];
             return;
         }
         
     }];
    
    
    
    [self setupServiceImages];
    [self setupTitleLabel];
    [self setupPriceLabel];
    [self setupCapacityLabel];
    [self setupCategoryLabel];
    [self setupDateLabel];
    [self setupLocationLabel];
    [self setupDescriptionLabel];
    [self setupTimeLabel];
    [self setupParticipantsItems];
    
}

-(void)viewDidLayoutSubviews
{
     UIButton *reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reportButton setImage:[UIImage imageNamed:@"exclamation1"] forState:UIControlStateNormal];
    [reportButton setFrame:CGRectMake(self.pickTimeSlotButton.center.x * 2 - 30, self.pickTimeSlotButton.center.y - 10, 20, 20)];
    [reportButton addTarget:self action:@selector(showReportActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reportButton];
}

-(void)showReportActionSheet
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:@"Report Inappropriate"];
    
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    
    [actionSheet showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        Report *report = [Report object];
        report.reporter = [User currentUser];
        report.serviceReported = self.service;
        [report handleReportWithCompletion:^(NSError *error) {
            if (!error) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Your report has been submitted. Thanks!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alert.tag = 1;
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alert.tag = 2;
                [alert show];
            }
        }];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((alertView.tag == 1 || alertView.tag == 2) && buttonIndex == 0) {
        [self returnToMainTabBarVC];
    }
}



- (IBAction)onConfirmButton:(UIBarButtonItem *)sender {
    
    if (!self.serviceSlot) {
        UIAlertView *pickTimeAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Please pick a time slot." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [pickTimeAlert show];
        return;
    }
    

    if (![self.serviceSlot.participants containsObject:self.currentUser]) {
        [self.serviceSlot.participants addObject:self.currentUser];
        [self.serviceSlot saveInBackground];
        Reservation *reservation = [Reservation object];
        reservation.reserver = [User currentUser];
        reservation.serviceSlot = self.serviceSlot;


        [reservation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                    // Create our Installation query
                    PFQuery *pushQuery = [PFInstallation query];
                    // only return Installations that belong to a User that
                    // matches the innerQuery
                    [pushQuery whereKey:@"user" matchesQuery: self.service.provider];
                
                    // Send push notification to query
                    PFPush *push = [[PFPush alloc] init];
                    [push setQuery:pushQuery]; // Set our Installation query
                    [push setMessage:[NSString stringWithFormat:@"Your Service:%@ @ %@ has been requested. Please check your Service History for more information.", self.serviceSlot.service.title, [self.serviceSlot getTimeSlotString]]];
                    [push sendPushInBackground];


            } else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"There was an error confirming your reservation, please click Ok and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];

            }
        }];

        [self returnToMainTabBarVC];
    } else {
        UIAlertView *repetitiveReserveAlert = [[UIAlertView alloc]initWithTitle:nil message:@"You already reserved the service" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [repetitiveReserveAlert show];
    }
//    // Build the actual push notification target query
//    PFQuery *query = [PFInstallation query];
//
//    // only return Installations that belong to a User that
//    // matches the innerQuery
//    [query whereKey:@"user" equalTo:self.service.provider];
//
//    // Send the notification.
//    PFPush *push = [[PFPush alloc] init];
//    [push setQuery:query];
//    [push setMessage:@"Someone has requested your service!"];
//    [push sendPushInBackground];
}

-(void)setupServiceImages
{
    
    self.serviceImagesCollectionView.showsHorizontalScrollIndicator = true;
    self.serviceImagesCollectionView.layer.borderWidth = 0.5;
    self.serviceImagesCollectionView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.serviceImageArray = [[NSMutableArray alloc]initWithCapacity:kMaxNumberOfServiceImages];
    for (int i = 0; i < kMaxNumberOfServiceImages; i++) {
        self.serviceImageArray[i] = [UIImage imageNamed:@"image_placeholder"];
    }
    [self.serviceImagesCollectionView reloadData];
    [self.service getServiceImageDataWithCompletion:^(NSDictionary *imageDataDict)
     {
         NSUInteger imagesCount = [imageDataDict[@"count"] integerValue];
         NSData *imageData = imageDataDict[@"data"];
         NSUInteger imageIndex = [imageDataDict[@"index"] integerValue];
         self.serviceImageArray[imageIndex] = [UIImage imageWithData:imageData];
         for (int i = imagesCount; i < kMaxNumberOfServiceImages; i++) {
             self.serviceImageArray[i] = [UIImage imageNamed:@"image_placeholder"];
         }
         [self.serviceImagesCollectionView reloadData];
     }];
}


-(void)setupTitleLabel
{
    self.serviceTitleLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Title"
                                                                 content:self.service.title fontSize:kLabelFontSize];
    
}


-(void)setupTimeLabel
{
    if (self.serviceSlot) {
        self.serviceTimeLabel.hidden = false;
        self.serviceTimeLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Time" content:[self.serviceSlot getTimeSlotString] fontSize:kLabelFontSize];
    } else {
        self.serviceTimeLabel.hidden = true;
    }
}

-(void)setupDateLabel
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    self.serviceDateLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Date" content:[dateFormatter stringFromDate:self.service.startDate] fontSize:kLabelFontSize];
}

-(void)setupPriceLabel
{
    self.servicePriceLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Price" content:[NSString stringWithFormat:@"$%@",self.service.price] fontSize:kLabelFontSize];
}

-(void)setupCapacityLabel
{
    
    self.serviceCapacityLabel.text = [NSString stringWithFormat:@"Capacity : %@",self.service.capacity];
    self.serviceCapacityLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Capacity" content:[self.service.capacity stringValue] fontSize:kLabelFontSize];
}

-(void)setupLocationLabel
{
    if (self.service.travel) {
        self.serviceLocationLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Location" content:@"Travel" fontSize:kLabelFontSize];
        return;
    }
    self.serviceLocationLabel.numberOfLines = 0;
    self.serviceLocationLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Location" content:self.service.serviceLocationAddress fontSize:kLabelFontSize];
}


-(void)setupCategoryLabel
{
    self.serviceCategoryLabel.numberOfLines = 0;
    self.serviceCategoryLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Category"
                                                                    content:self.service.category fontSize:kLabelFontSize];
}

-(void)setupDescriptionLabel
{
    self.serviceDescriptionLabel.numberOfLines = 0;
    self.serviceDescriptionLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Descripton" content:self.service.serviceDescription fontSize:kLabelFontSize];
}

-(void)setupParticipantsLabel
{
    self.participantsLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Participants" content:@"" fontSize:kLabelFontSize];
}

-(void)setupParticipantsItems
{
    self.participantsCollectionView.showsHorizontalScrollIndicator = true;
    self.participantsCollectionView.layer.borderWidth = 0.5;
    self.participantsCollectionView.layer.borderColor = [UIColor lightGrayColor].CGColor;
 
     if ([self.service.capacity integerValue] > 1 && self.serviceSlot) {
        self.participantsLabel.hidden = false;
        if (self.serviceSlot.participants.count > 0) {
            [self setupParticipantsLabel];
            self.participantsCollectionView.hidden = false;
            self.participants = self.serviceSlot.participants;
            [self.participantsCollectionView reloadData];
        } else {
            self.participantsLabel.text = @"No other participants yet";
            self.participantsCollectionView.hidden = true;
        }
    } else {
        self.participantsLabel.hidden = true;
        self.participantsCollectionView.hidden = true;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.serviceImagesCollectionView) {
        return self.serviceImageArray.count;
    } else {
        if (self.participants.count) {
            self.participantsLabel.hidden = false;
        }
        return self.participants.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == self.serviceImagesCollectionView) {
        ServiceImagesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServiceImageCell" forIndexPath:indexPath];
        cell.serviceImageView.title = self.service.title;
        cell.serviceImageView.vc = self;
        cell.serviceImageView.image = self.serviceImageArray[indexPath.row];
        return cell;
    } else {
        ParticipantCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ParticipantCell" forIndexPath:indexPath];
        User *participant = self.participants[indexPath.row];
        cell.profileImageView.user = participant;
        cell.profileImageView.vc = self;
        cell.nameLabel.text = participant.name;
        return cell;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
//    RatingViewController *ratingVC = [segue destinationViewController];
//    ratingVC.service = self.service;
    if ([segue.identifier isEqualToString:@"ToPickTimeSlotSegue"] ) {
        PickTimeSlotViewController *pickTimeSlotVC = segue.destinationViewController;
        pickTimeSlotVC.service = self.service;
        pickTimeSlotVC.reviewVC = self;
    }
}




- (IBAction)onCancelButtonTapped:(UIBarButtonItem *)sender
{
   
    [self returnToMainTabBarVC];
}

-(void)returnToMainTabBarVC
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mainTabBarVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainTabBarVC"];
    [self presentViewController:mainTabBarVC animated:true completion:nil];
}





@end
