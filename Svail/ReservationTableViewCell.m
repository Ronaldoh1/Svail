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
#import "RatingViewController.h"
#import "MBProgressHUD.h"



@interface ReservationTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic) User *provider;
@property (nonatomic) NSArray *participants;
@property (nonatomic) NSMutableArray *serviceImageArray;
@property (nonatomic) Service *service;
@property (nonatomic) ServiceSlot *serviceSlot;
@property (weak, nonatomic) IBOutlet UIView *providerContainerView;

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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rateButtonHeightConstraint;
@property CGFloat rateButtonHeightConstant;

@property (weak, nonatomic) NSLayoutConstraint *participantsLabelHeightConstraint;
@property CGFloat participantsLabelHeightConstant;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *participantsCVHeightConstraint;
@property CGFloat participantsCVHeightConstant;

@end

@implementation ReservationTableViewCell

static const CGFloat kLabelFontSize = 13.0;


-(void)setupContent
{
    self.participantsCollectionView.delegate = self;
    self.participantsCollectionView.dataSource = self;
    self.serviceImagesCollectionView.delegate = self;
    self.serviceImagesCollectionView.dataSource = self;
    
    [self setupDefaultContent];

    self.serviceSlot = self.reservation.serviceSlot;
     self.service = self.serviceSlot.service;
     self.provider = self.serviceSlot.service.provider;
    
     self.providerImageView.user = self.provider;
     self.providerImageView.vc = self.vc;
    
    self.providerContainerView.layer.borderWidth = 0.5;
    self.providerContainerView.layer.borderColor = [UIColor colorWithRed:255/255.0 green:127/255.0 blue:59/255.0 alpha:1.0].CGColor;
    
     [self setupProviderNameLabel];
    [self setupProviderServiceNumberLabel];
    [self setupProviderRatingLabel];
    [self setupSafetyBadge];
    

     [self setupTitleLabel];
     [self setupPriceLabel];
     [self setupCapacityLabel];
     [self setupCategoryLabel];
     [self setupDateLabel];
     [self setupTimeLabel];
     [self setupLocationLabel];
     [self setupDescriptionLabel];
     [self setupReservedAtLabel];
     [self setupServiceImages];
     [self setupParticipantsItems];
     [self setupRateButton];
}

-(void)setupDefaultContent
{
    self.serviceTitleLabel.text = @"";
    self.serviceLocationLabel.text = @"";
    self.servicePriceLabel.text = @"";
    self.serviceCapacityLabel.text = @"";
    self.serviceCategoryLabel.text = @"";
    self.serviceDescriptionLabel.text = @"";
    self.serviceDateLabel.text = @"";
    self.reservedAtLabel.text = @"";
    self.serviceTimeLabel.text = @"";
    self.ratingLabel.text = @"";
    self.providerNameLabel.text = @"";
    self.providerImageView.image = nil;
    self.safetyBadgeImageView.hidden = true;
    self.servicesNumberLabel.text = @"";
    
    self.rateButtonHeightConstant = 20;
    self.rateButtonHeightConstraint.constant = 0.0;
    self.rateButton.hidden = true;

    self.participantsLabel.text = nil;
    
    self.participantsCVHeightConstant = 42;
    self.participantsCVHeightConstraint.constant = 0.0;
    self.participantsCollectionView.hidden = true;
    
    self.serviceImageArray = [[NSMutableArray alloc]initWithCapacity:kMaxNumberOfServiceImages];
    for (int i = 0; i < kMaxNumberOfServiceImages; i++) {
        self.serviceImageArray[i] = [UIImage imageNamed:@"image_placeholder"];
    }
    [self.serviceImagesCollectionView reloadData];
}

-(void)updateConstraints
{
    [super updateConstraints];
    [self.serviceImagesCollectionView addConstraint:[NSLayoutConstraint constraintWithItem:self.serviceImagesCollectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.serviceImagesCollectionView attribute:NSLayoutAttributeWidth multiplier:0.25 constant:0.0]];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat imageHeight = self.serviceImagesCollectionView.bounds.size.height;
    ((UICollectionViewFlowLayout *) self.serviceImagesCollectionView.collectionViewLayout).itemSize = CGSizeMake(imageHeight, imageHeight);
}

-(void)setupProviderNameLabel
{
    self.providerNameLabel.text = self.serviceSlot.service.provider.name;
}

-(void)setupProviderServiceNumberLabel
{
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
    
}

-(void)setupProviderRatingLabel
{
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
}

-(void)setupSafetyBadge
{
    if ([self.provider.verification hasReachedSafeLevel]) {
          self.safetyBadgeImageView.hidden = false;
     } else {
          self.safetyBadgeImageView.hidden = true;
     }
}

-(void)setupRateButton
{
    if ([self.serviceSlot checkStatus] == HasFinished) {

         self.rateButtonHeightConstraint.constant = self.rateButtonHeightConstant;
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
                 self.rateButton.tintColor = [UIColor lightGrayColor];
                 self.rateButton.layer.borderWidth = 0.0;
//                 self.rateButton.layer.shouldRasterize = true;
//                 self.rateButton.layer.rasterizationScale = [[UIScreen mainScreen] scale];

             } else {
                self.rateButton.hidden = false;
                self.rateButton.userInteractionEnabled = true;
                [self.rateButton setTitle:@"Rate it!" forState:UIControlStateNormal];
                [self.rateButton sizeToFit];
                 self.rateButton.tintColor = [UIColor colorWithRed:255/255.0 green:127/255.0 blue:59/255.0 alpha:1.0];
                 self.rateButton.layer.borderWidth = 1.0;
                 self.rateButton.layer.borderColor = [UIColor colorWithRed:21/255.0 green:137/255.0 blue:255/255.0 alpha:1.0].CGColor;
//                 self.rateButton.layer.shouldRasterize = true;
//                 self.rateButton.layer.rasterizationScale = [[UIScreen mainScreen] scale];

                [self.rateButton addTarget:self action:@selector(onRateButtonTapped) forControlEvents:UIControlEventTouchUpInside];
             }
         }];
    }
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
    [self.service getServiceImageDataWithCompletion:^(NSDictionary *imageDataDict)
     {
         NSData *imageData = imageDataDict[@"data"];
         NSUInteger imageIndex = [imageDataDict[@"index"] integerValue];
         self.serviceImageArray[imageIndex] = [UIImage imageWithData:imageData];
         NSIndexPath *indexPath = [NSIndexPath indexPathForItem:imageIndex inSection:0];
         [self.serviceImagesCollectionView reloadItemsAtIndexPaths:@[indexPath]];
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
    self.participantsLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Other participants" content:@"" fontSize:kLabelFontSize];
}

-(void)setupParticipantsItems
{
    if (self.serviceSlot.participants.count > 1) {
        [self setupParticipantsLabel];
        self.participantsCVHeightConstraint.constant = self.participantsCVHeightConstant;
        self.participantsCollectionView.hidden = false;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId != %@", [User currentUser].objectId];
        self.participants = [self.serviceSlot.participants filteredArrayUsingPredicate:predicate];
        [self.participantsCollectionView reloadData];
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
