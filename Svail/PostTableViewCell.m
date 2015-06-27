//
//  PostTableViewCell.m
//  Svail
//
//  Created by zhenduo zhu on 4/27/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "PostTableViewCell.h"
#import "Image.h"
#import "ServiceImagesCollectionViewCell.h"
#import "CustomViewUtilities.h"

@interface PostTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *capacityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfReservationsLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *serviceImagesCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *viewSlotsButton;

@property (nonatomic) NSMutableArray *serviceImageArray;




@end


@implementation PostTableViewCell

static const CGFloat kLableFontSize = 13.0;


- (void)awakeFromNib
{
    self.serviceImagesCollectionView.delegate = self;
    self.serviceImagesCollectionView.dataSource = self;
    
    self.editButton.tag = self.tag;
    self.deleteButton.tag = self.tag;
    self.viewSlotsButton.tag = self.tag;
    self.serviceImagesCollectionView.tag = self.tag;
    
    [self setupDefaultContent];
    [self getServiceImages];
    
    [self setupTitleLabel];
    [self setupLocationLabel];
    [self setupPriceLabel];
    [self setupCapacityLabel];
    [self setupCategoryLabel];
    [self setupDescriptionLabel];
    [self setupDateLabel];
    [self setupNumOfReservationsLabel];
    

    
}

-(void)setupDefaultContent
{
    self.titleLabel.text = @"";
    self.locationLabel.text = @"";
    self.priceLabel.text = @"";
    self.capacityLabel.text = @"";
    self.categoryLabel.text = @"";
    self.descriptionLabel.text = @"";
    self.dateLabel.text = @"";
    self.numOfReservationsLabel.text = @"";
    
    self.serviceImageArray = [[NSMutableArray alloc]initWithCapacity:kMaxNumberOfServiceImages];
    for (int i = 0; i < kMaxNumberOfServiceImages; i++) {
        self.serviceImageArray[i] = [UIImage imageNamed:@"image_placeholder"];
    }
    [self.serviceImagesCollectionView reloadData];
}

-(void)setupTitleLabel
{
    NSLog(@"title %@",self.service.title);
    self.titleLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Title" content:self.service.title fontSize:kLableFontSize];
    
}

-(void)setupDateLabel
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    self.dateLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Date" content:[dateFormatter stringFromDate:self.service.startDate] fontSize:kLableFontSize];
}

-(void)setupPriceLabel
{
    self.priceLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Price" content:[NSString stringWithFormat:@"$%@",self.service.price] fontSize:kLableFontSize];
}

-(void)setupCapacityLabel
{
    
    self.capacityLabel.text = [NSString stringWithFormat:@"Capacity : %@",self.service.capacity];
    self.capacityLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Capacity" content:[self.service.capacity stringValue] fontSize:kLableFontSize];
}

-(void)setupLocationLabel
{
    if (self.service.travel) {
        self.locationLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Location" content:@"Travel" fontSize:kLableFontSize];
        return;
    }
    self.locationLabel.numberOfLines = 0;
    self.locationLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Location" content:self.service.serviceLocationAddress fontSize:kLableFontSize];
}


-(void)setupCategoryLabel
{
    self.categoryLabel.numberOfLines = 0;
    self.categoryLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Category" content:self.service.category fontSize:kLableFontSize];
}


-(void)setupDescriptionLabel
{
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Descripton" content:self.service.serviceDescription fontSize:kLableFontSize];
}

-(void)setupNumOfReservationsLabel
{
    [self.service getParticipantsWithCompletion:^(NSArray *participants)
    {
        self.numOfReservationsLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Number of reservations" content:[NSString stringWithFormat:@"%lu",(long)(participants.count)] fontSize:kLableFontSize];
    }];
}


-(void)getServiceImages
{
    [self.service getServiceImageDataWithCompletion:^(NSDictionary *imageDataDict)
     {
         NSData *imageData = imageDataDict[@"data"];
         NSUInteger imageIndex = [imageDataDict[@"index"] integerValue];
         self.serviceImageArray[imageIndex] = [UIImage imageWithData:imageData];
         NSIndexPath *imageIndexPath = [NSIndexPath indexPathForItem:imageIndex inSection:0];
         [self.serviceImagesCollectionView reloadItemsAtIndexPaths:@[imageIndexPath]];
     }];
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.serviceImageArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceImagesCollectionViewCell *serviceImageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServiceImageCell" forIndexPath:indexPath];
    serviceImageCell.serviceImageView.title = self.service.title;
    serviceImageCell.serviceImageView.vc = self.vc;
    serviceImageCell.serviceImageView.image = self.serviceImageArray[indexPath.row];
    
    return serviceImageCell;
}



@end
