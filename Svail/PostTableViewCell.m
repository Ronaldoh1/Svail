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

@interface PostTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *capacityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *serviceImagesCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (nonatomic) NSMutableArray *serviceImageArray;

@end


@implementation PostTableViewCell

static NSUInteger kMaxNumberOfServiceImages = 4;

- (void)awakeFromNib
{
    self.serviceImagesCollectionView.delegate = self;
    self.serviceImagesCollectionView.dataSource = self;
    
    [self setupTitleLabel];
    [self setupLocationLabel];
    [self setupPriceLabel];
    [self setupCapacityLabel];
    [self setupDateLabel];
    [self setupTimeLabel];
    
    self.editButton.tag = self.tag;
    self.deleteButton.tag = self.tag;
    
    self.serviceImageArray = [[NSMutableArray alloc]initWithCapacity:kMaxNumberOfServiceImages];
        for (int i = 0; i < kMaxNumberOfServiceImages; i++) {
            self.serviceImageArray[i] = [UIImage imageNamed:@"image_placeholder"];
        }
    [self.serviceImagesCollectionView reloadData];
}


-(void)setupTitleLabel
{
    self.titleLabel.text = [NSString stringWithFormat:@"Title %@",self.service.title];
    self.titleLabel.font = [UIFont fontWithName:@"Arial" size:13.0];
    NSRange range = [self.titleLabel.text rangeOfString:@"Title"];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:self.titleLabel.text];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0]} range:range];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
    self.titleLabel.attributedText = attributedText;
}


-(void)setupTimeLabel
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"HH:MM"];
    self.timeLabel.text = [NSString stringWithFormat:@"Time %@ --- %@",
                                  [dateFormatter stringFromDate:self.service.startDate],
                                  [dateFormatter stringFromDate:self.service.endDate]];
    self.timeLabel.font = [UIFont fontWithName:@"Arial" size:13.0];
    NSRange range = [self.timeLabel.text rangeOfString:@"Time"];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:self.timeLabel.text];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0]} range:range];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
    self.timeLabel.attributedText = attributedText;
}


-(void)setupDateLabel
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    self.dateLabel.text = [NSString stringWithFormat:@"Date %@",
                                  [dateFormatter stringFromDate:self.service.startDate]],
    self.dateLabel.font = [UIFont fontWithName:@"Arial" size:13.0];
    NSRange range = [self.dateLabel.text rangeOfString:@"Date"];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:self.dateLabel.text];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0]} range:range];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
    self.dateLabel.attributedText = attributedText;
}


-(void)setupPriceLabel
{
    
    self.priceLabel.text = [NSString stringWithFormat:@"Price : $%@",self.service.price];
    self.priceLabel.font = [UIFont fontWithName:@"Arial" size:13.0];
    NSRange range = [self.priceLabel.text rangeOfString:@"Price"];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:self.priceLabel.text];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0]} range:range];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
    self.priceLabel.attributedText = attributedText;
}

-(void)setupCapacityLabel
{
    
    self.capacityLabel.text = [NSString stringWithFormat:@"Capacity : %@",self.service.capacity];
    self.capacityLabel.font = [UIFont fontWithName:@"Arial" size:13.0];
    NSRange range = [self.capacityLabel.text rangeOfString:@"Capacity"];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:self.capacityLabel.text];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0]} range:range];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
    self.capacityLabel.attributedText = attributedText;
}

-(void)setupLocationLabel
{
    self.locationLabel.numberOfLines = 0;
    self.locationLabel.text = [NSString stringWithFormat:@"Location %@",self.service.serviceLocationAddress];
    self.locationLabel.font = [UIFont fontWithName:@"Arial" size:13.0];
    NSRange range = [self.locationLabel.text rangeOfString:@"Location"];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:self.locationLabel.text];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0]} range:range];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
    self.locationLabel.attributedText = attributedText;
}

-(void)getServiceImages
{
    PFQuery *imagesQuery = [Image query];
    [imagesQuery whereKey:@"service" equalTo:self.service];
    [imagesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,
                                                    NSError *error)
     {
         if (!error) {
             [self.serviceImagesCollectionView reloadData];
             for (int i = 0;i < objects.count;i++) {
                 PFFile *imageFile = objects[i];
                 [imageFile getDataInBackgroundWithBlock:^(NSData *data,
                                                           NSError *error)
                  {
                      if (!error) {
                          self.serviceImageArray[i] = [UIImage imageWithData:data];
                          [self.serviceImagesCollectionView reloadData];
                      }
                  }];
              }
          }
     }];
}




-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.serviceImageArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceImagesCollectionViewCell *serviceImageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServiceImageCell" forIndexPath:indexPath];
    if (self.serviceImageArray.count > indexPath.row) {
        serviceImageCell.serviceImageView.image = self.serviceImageArray[indexPath.row];
    } else {
        serviceImageCell.serviceImageView.image = [UIImage imageNamed:@"image_placeholder"];
    }
    
    return serviceImageCell;
}



@end
