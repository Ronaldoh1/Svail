//
//  ReviewPurchaseViewController.m
//  Svail
//
//  Created by zhenduo zhu on 4/22/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "ReviewPurchaseViewController.h"
#import "User.h"
#import "Verification.h"
#import "Service.h"
#import "ParticipantPurchaseCVCell.h"

@interface ReviewPurchaseViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *providerProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *providerNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *safetyImageView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfServicesLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *servicePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *travelOrHostLabel;
@property (weak, nonatomic) IBOutlet UITextView *serviceDescriptionTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *participantsProfileCollectionView;

@property (nonatomic) User *currentUser;
@property (nonatomic) NSMutableArray *participants;

@end

@implementation ReviewPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.participantsProfileCollectionView.showsHorizontalScrollIndicator = true;
    self.safetyImageView.hidden = true;
    self.currentUser = [User currentUser];
    
    //use query to get verification property of currentuser, because verification is pointer, its content will not be retrieved by simply calling currentuser.verification.
    PFQuery *currentUserQuery = [User query];
    [currentUserQuery includeKey:@"verification"];
    [currentUserQuery includeKey:@"verification"];
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
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    
    PFQuery *serviceQuery = [Service query];
    [serviceQuery includeKey:@"participants"];
    [serviceQuery getObjectInBackgroundWithId:self.serviceId block:^(PFObject *object, NSError *error)
     {
         Service *service = (Service *)object;
        if (!error) {
       //     self.participants = service.participants.mutableCopy;
       //    [self.participantsProfileCollectionView reloadData
            //];
            
        } else {
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
         
     }];
    
    PFQuery *participantQuery = [User query];
    [participantQuery whereKey:@"objectId" containedIn:@[@"PsC2VK0FaM",@"U51R8iDsYR"]];
    [participantQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error)
    {
        if (!error) {
            self.participants = results.mutableCopy;
            [self.participantsProfileCollectionView reloadData];
        } else {
            NSLog(@"fuck");
        }
        
    }];
    

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ParticipantPurchaseCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ParticipantCell" forIndexPath:indexPath];
    User *participant = self.participants[indexPath.row];
    
    [participant.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            cell.participantProfileImageView.image = image;
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

@end
