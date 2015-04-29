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
#import "Rating.h"
#import "ParticipantPurchaseCVCell.h"
#import "ConfirmPurchaseViewController.h"
#import "CustomViewUtilities.h"
#import "RatingViewController.h"

@interface ReviewReservationViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *providerProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *providerNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *safetyImageView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfServicesLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *servicePriceLabel;
@property (weak, nonatomic) IBOutlet UITextView *serviceDescriptionTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *participantsProfileCollectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *hostOrTravelSegments;
@property (weak, nonatomic) IBOutlet UILabel *participantsLabel;

@property (nonatomic) User *currentUser;
@property (nonatomic) NSMutableArray *participants;
@property (nonatomic) Service *service;

@end

@implementation ReviewReservationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.participantsProfileCollectionView.showsHorizontalScrollIndicator = true;
    self.safetyImageView.hidden = true;
    self.currentUser = [User currentUser];
    
    self.participantsProfileCollectionView.layer.borderWidth = 0.5;
    self.participantsProfileCollectionView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    //use query to get verification property of currentuser, because verification is pointer, its content will not be retrieved by simply calling currentuser.verification.
    PFQuery *currentUserQuery = [User query];
    [currentUserQuery includeKey:@"verification"];
    currentUserQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [currentUserQuery getObjectInBackgroundWithId:self.currentUser.objectId block:^(PFObject *user, NSError *error)
    {
        if (!error) {
            User *currentUser = (User *)user;
            if ([[currentUser.verification objectForKey:@"safetyLevel"] integerValue] >= 5) {
                self.safetyImageView.hidden = false;
            } else {
                self.safetyImageView.hidden = true;
            }
        } else {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
            return;
        }
    }];
    
    PFQuery *serviceQuery = [Service query];
    [serviceQuery includeKey:@"provider"];
    [serviceQuery includeKey:@"participants"];
    serviceQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [serviceQuery getObjectInBackgroundWithId:self.serviceId block:^(PFObject *object, NSError *error)
     {
         self.service = (Service *)object;
        if (!error) {
            
            self.participants = self.service.participants;
            [self.participantsProfileCollectionView reloadData];
            
            [self.service.provider.profileImage getDataInBackgroundWithBlock:^(NSData *data,
                                                                          NSError *error)
            {
                if (!error) {
             [CustomViewUtilities setupProfileImageView:self.providerProfileImageView WithImage:[UIImage imageWithData:data]];
                }
            }];
            
            PFQuery *providerServicesQuery = [Service query];
            [providerServicesQuery whereKey:@"provider" equalTo:self.service.provider];
            providerServicesQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
            [providerServicesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,
                                                                      NSError *error)
            {
                if (!error) {
                    self.numOfServicesLabel.text = [NSString stringWithFormat:@"%li",objects.count];

                }
                
            }];
            
            PFQuery *providerRatingsQuery = [Rating query];
            [providerRatingsQuery whereKey:@"ratee" equalTo:self.service.provider];
            providerRatingsQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
            [providerRatingsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,
                                                                      NSError *error)
            {
                if (!error) {
                    self.ratingLabel.text = [NSString stringWithFormat:@"%.1f",[[objects valueForKeyPath:@"@avg.value"] doubleValue]];
                }
                
            }];
 
            
            
           self.ratingLabel.text =
            
            self.providerNameLabel.text = self.service.provider.name;
            [self setupServiceTitle];
            [self setupTimeLabel];
            [self setupPriceLabel];
            [self setupHostOrTravelSegements];
            [self setupServiceDescriptionTextView];
            [self setupParticipantsLabel];
            
            
        } else {
//             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
            return;
        }
         
     }];
    
//    PFQuery *participantQuery = [User query];
//    [participantQuery whereKey:@"objectId" containedIn:@[@"PsC2VK0FaM",@"U51R8iDsYR"]];
//    [participantQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error)
//    {
//        if (!error) {
//            self.participants = results.mutableCopy;
//            [self.participantsProfileCollectionView reloadData];
//        } else {
//            NSLog(@"shit");
//        }
//        
//    }];
    

}


-(void)setupServiceTitle
{
    self.serviceTitleLabel.text = [NSString stringWithFormat:@"Title %@",self.service.title];
    self.serviceTitleLabel.font = [UIFont fontWithName:@"Arial" size:13.0];
    NSRange range = [self.serviceTitleLabel.text rangeOfString:@"Title"];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:self.serviceTitleLabel.text];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0]} range:range];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
    self.serviceTitleLabel.attributedText = attributedText;
}

-(void)setupTimeLabel
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM/dd/yy HH:mm"];
    self.serviceTimeLabel.text = [NSString stringWithFormat:@"Time %@ --- %@",
                                  [dateFormatter stringFromDate:self.service.startDate],
                                  [dateFormatter stringFromDate:self.service.endDate]];
    self.serviceTimeLabel.font = [UIFont fontWithName:@"Arial" size:13.0];
     NSRange range = [self.serviceTimeLabel.text rangeOfString:@"Time"];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:self.serviceTimeLabel.text];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0]} range:range];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
    self.serviceTimeLabel.attributedText = attributedText;
}

-(void)setupPriceLabel
{
    
    self.servicePriceLabel.text = [NSString stringWithFormat:@"Price : $%@",self.service.price];
    self.servicePriceLabel.font = [UIFont fontWithName:@"Arial" size:13.0];
    NSRange range = [self.servicePriceLabel.text rangeOfString:@"Price"];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:self.servicePriceLabel.text];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0]} range:range];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
    self.servicePriceLabel.attributedText = attributedText;
    
}

-(void)setupParticipantsLabel
{
    
    self.participantsLabel.text = [NSString stringWithFormat:@"Participants"];
    self.participantsLabel.font = [UIFont fontWithName:@"Arial" size:13.0];
    NSRange range = [self.participantsLabel.text rangeOfString:@"Participants"];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:self.participantsLabel.text];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0]} range:range];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
    self.participantsLabel.attributedText = attributedText;
    
}

-(void)setupHostOrTravelSegements
{
    self.hostOrTravelSegments.userInteractionEnabled = false;
    self.hostOrTravelSegments.selectedSegmentIndex = self.service.travel ? 1 : 0;
}

-(void)setupServiceDescriptionTextView
{
    self.serviceDescriptionTextView.text = [NSString stringWithFormat:@"Description: %@", self.service.serviceDescription];
    self.serviceDescriptionTextView.font = [UIFont fontWithName:@"Arial" size:13.0];
        NSRange range = [self.serviceDescriptionTextView.text rangeOfString:@"Description"];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:self.serviceDescriptionTextView.text];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0]} range:range];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
    self.serviceDescriptionTextView.attributedText = attributedText;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ParticipantPurchaseCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ParticipantCell" forIndexPath:indexPath];
    User *participant = self.participants[indexPath.row];
    

    [participant.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            
            [CustomViewUtilities setupProfileImageView:cell.participantProfileImageView WithImage:[UIImage imageWithData:data]];
            [cell layoutSubviews];
        }
    }];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.participants.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (IBAction)onCancelButtonTapped:(UIBarButtonItem *)sender
{
    UIStoryboard *mapStoryboard = [UIStoryboard storyboardWithName:@"Map" bundle:nil];
    UIViewController *mapNavVC = [mapStoryboard instantiateViewControllerWithIdentifier:@"MapNavVC"];
    [self presentViewController:mapNavVC animated:true completion:nil];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    RatingViewController *ratingVC = [segue destinationViewController];
    ratingVC.service = self.service;
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (![self.service.participants containsObject:self.currentUser]) {
        return YES;
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"You already booked the service" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
}

@end
