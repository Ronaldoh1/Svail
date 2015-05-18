//
//  PurchaseTableViewCell.m
//  Svail
//
//  Created by zhenduo zhu on 4/27/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "ReservationTableViewCell.h"
#import "Rating.h"
#import "User.h"
#import "Image.h"
#import "CustomViewUtilities.h"
#import "ServiceImagesCollectionViewCell.h"
#import "ParticipantCollectionViewCell.h"
#import "ProfileImageView.h"
#import "RatingViewController.h"


@interface ReservationTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet ProfileImageView *providerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *safetyBadgeImageView;

@property (weak, nonatomic) IBOutlet UILabel *providerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *servicesNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *serviceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *servicePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceCapacityLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *participantsLabel;
@property (weak, nonatomic) IBOutlet UILabel *reservedAtLabel;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;

@property (weak, nonatomic) IBOutlet UICollectionView *serviceImagesCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *participantsCollectionView;

@property (nonatomic) User *provider;
@property (nonatomic) NSMutableArray *participants;
@property (nonatomic) NSMutableArray *serviceImageArray;
@property (nonatomic) Service *service;
@property (nonatomic) ServiceSlot *serviceSlot;

@end

@implementation ReservationTableViewCell

static const CGFloat kLabelFontSize = 10.0;

-(void)awakeFromNib {
    
    if (self.reservation) {
        
    
    self.participantsCollectionView.delegate = self;
    self.participantsCollectionView.dataSource = self;
    self.serviceImagesCollectionView.delegate = self;
    self.serviceImagesCollectionView.dataSource = self;
    

    
    PFQuery *serviceSlotQuery = [ServiceSlot query];
    [serviceSlotQuery includeKey:@"service.provider.verification"];
    [serviceSlotQuery includeKey:@"participants"];
    serviceSlotQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [serviceSlotQuery getObjectInBackgroundWithId:self.reservation.serviceSlot.objectId block:^(PFObject *object, NSError *error)
     {

         if (!error) {
             self.serviceSlot = (ServiceSlot *)object;
             self.service = self.serviceSlot.service;
             self.provider = self.serviceSlot.service.provider;
             
             [self setupServiceImages];
             [self setupTitleLabel];
             [self setupPriceLabel];
             [self setupCapacityLabel];
             [self setupCategoryLabel];
             [self setupDateLabel];
             [self setupTimeLabel];
             [self setupLocationLabel];
             [self setupDescriptionLabel];
             [self setupParticipantsItems];
             [self setupReservedAtLabel];
                 

             self.providerNameLabel.text = self.serviceSlot.service.provider.name;
             
             if ([[self.provider.verification objectForKey:@"safetyLevel"] integerValue] >= 5) {
                      self.safetyBadgeImageView.hidden = false;
                  } else {
                      self.safetyBadgeImageView.hidden = true;
             }
         
             self.providerImageView.user = self.provider;
             self.providerImageView.vc = self.vc;
             
              PFQuery *providerServiceQuery = [Service query];
             [providerServiceQuery whereKey:@"provider" equalTo:self.service.provider];
              PFQuery *providerServiceSlotsQuery = [ServiceSlot query];
              [providerServiceSlotsQuery whereKey:@"service" matchesQuery:providerServiceQuery];
              providerServiceSlotsQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
              [providerServiceSlotsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
              {
                   if (!error) {
                       self.servicesNumberLabel.text = [NSString stringWithFormat:@"%lu",(long)(objects.count)];
                       
                   }
                   
              }];
             
             PFQuery *serviceQuery = [Service query];
             [serviceQuery whereKey:@"provider" equalTo:self.provider];
             PFQuery *serviceSlotQuery = [ServiceSlot query];
             [serviceSlotQuery whereKey:@"service" matchesQuery:serviceQuery];
             PFQuery *providerRatingsQuery = [Rating query];
             [providerRatingsQuery whereKey:@"serviceSlot" matchesQuery:serviceSlotQuery];
             providerRatingsQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
              [providerRatingsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
               {
                   if (!error) {
                       self.ratingLabel.text = [NSString stringWithFormat:@"%.1f",[[objects valueForKeyPath:@"@avg.value"] doubleValue]];
                   } else {
                       self.ratingLabel.text = @"0";
                   }
               }];
             
             [self setupRateButton];
             
             
          } else {
                      //             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                      //            [alert show];
                      return;
          }
                  
    }];
    }
    
}

-(void)setupRateButton
{
    [self.serviceSlot checkStatusWithCompletion:^(ServiceSlotStatus serviceSlotStatus)
    {
        
        self.rateButton.userInteractionEnabled = false;
        [self.rateButton setTitle:@"" forState:UIControlStateNormal];
        
        if (serviceSlotStatus != HasFinished) {
            self.rateButton.hidden = true;
        } else {

            self.rateButton.hidden = true;
              PFQuery *requesterRatingQuery = [Rating query];
             [requesterRatingQuery whereKey:@"serviceSlot" equalTo:self.serviceSlot];
             [requesterRatingQuery whereKey:@"rater" equalTo:[User currentUser]];
            requesterRatingQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
             [requesterRatingQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
             {
                 if (!error) {
                     Rating *requesterRating = (Rating *)object;
                    self.rateButton.hidden = false;
                     self.rateButton.userInteractionEnabled = false;
                     [self.rateButton setTitle:[NSString stringWithFormat:@"You rated this service %1.0f stars",requesterRating.value] forState:UIControlStateNormal];
                    [self.rateButton sizeToFit];
                 } else {
                    self.rateButton.hidden = false;
                    self.rateButton.userInteractionEnabled = true;
                    [self.rateButton setTitle:@"Rate it!" forState:UIControlStateNormal];
                    [self.rateButton sizeToFit];
                    [self.rateButton addTarget:self action:@selector(onRateButtonTapped) forControlEvents:UIControlEventTouchUpInside];
                 }
             }];
        }
    }];
    
}


-(void)onRateButtonTapped
{
    UIStoryboard *historyStoryboard = [UIStoryboard storyboardWithName:@"History" bundle:nil];
    RatingViewController *ratingVC = [historyStoryboard instantiateViewControllerWithIdentifier:@"RatingVC"];
    ratingVC.serviceSlot = self.serviceSlot;
    ratingVC.vc = self.vc;
    [self.vc presentViewController:ratingVC animated:true completion:nil];
    
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
    self.serviceTitleLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Title" content:self.service.title fontSize:kLabelFontSize];
    
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

-(void)setupReservedAtLabel
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM/dd/yy HH:mm"];
    self.reservedAtLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Reserved at" content:[dateFormatter stringFromDate:self.reservation.createdAt] fontSize:kLabelFontSize];
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
    self.serviceCategoryLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Category" content:self.service.category fontSize:kLabelFontSize];
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
     if ([self.service.capacity integerValue] > 1) {
        self.participantsLabel.hidden = false;
        if (self.serviceSlot.participants.count > 0) {
            [self setupParticipantsLabel];
            self.participantsCollectionView.hidden = false;
            self.participants = self.serviceSlot.participants;
            [self.participantsCollectionView reloadData];
        } else {
            self.participantsLabel.text = @"No other participants";
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
        return self.participants.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (collectionView == self.serviceImagesCollectionView) {
        ServiceImagesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServiceImageCell" forIndexPath:indexPath];
        cell.serviceImageView.title = self.service.title;
        cell.serviceImageView.vc = self.vc;
        cell.serviceImageView.image = self.serviceImageArray[indexPath.row];
        return cell;
    } else {
        ParticipantCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ParticipantCell" forIndexPath:indexPath];
        User *participant = self.participants[indexPath.row];
        cell.profileImageView.user = participant;
        cell.profileImageView.vc = self.vc;
        cell.nameLabel.text = participant.name;
        return cell;
    }
}


@end
