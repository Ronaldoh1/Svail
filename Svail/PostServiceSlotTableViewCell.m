//
//  PostServiceSlotTableViewCell.m
//  Svail
//
//  Created by zhenduo zhu on 5/9/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "PostServiceSlotTableViewCell.h"
#import "CustomViewUtilities.h"
#import "ParticipantCollectionViewCell.h"

@interface PostServiceSlotTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *participantsLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *participantsCollectionView;


@property (nonatomic) NSMutableArray *participants;

@end

@implementation PostServiceSlotTableViewCell

static const CGFloat kLabelFontSize = 13.0;

- (void)awakeFromNib
{
    self.participantsCollectionView.delegate = self;
    self.participantsCollectionView.dataSource = self;
    
    self.participants = self.serviceSlot.participants;
    
    [self setupTimeLabel];
    [self setupParticipantsItems];
    
}

-(void)setupTimeLabel
{
        self.timeLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Time" content:[self.serviceSlot getTimeSlotString] fontSize:kLabelFontSize];
}

-(void)setupParticipantsItems
{
//    self.participantsCollectionView.showsHorizontalScrollIndicator = true;
//    self.participantsCollectionView.layer.borderWidth = 0.5;
//    self.participantsCollectionView.layer.borderColor = [UIColor lightGrayColor].CGColor;
 
    self.participantsLabel.hidden = false;
    if (self.serviceSlot.participants.count > 0) {
        [self setupParticipantsLabel];
        self.participantsCollectionView.hidden = false;
        self.participants = self.serviceSlot.participants;
        [self.participantsCollectionView reloadData];
    } else {
        self.participantsLabel.text = @"No participant";
        self.participantsCollectionView.hidden = true;
    }
}

-(void)setupParticipantsLabel
{
    self.participantsLabel.attributedText = [CustomViewUtilities setupTextWithHeader:@"Participants" content:@"" fontSize:kLabelFontSize];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.participants.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ParticipantCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ParticipantCell" forIndexPath:indexPath];
    User *participant = self.participants[indexPath.row];
    cell.profileImageView.user = participant;
    cell.profileImageView.vc = self.vc;
    cell.nameLabel.text = participant.name;
    return cell;
}

@end
