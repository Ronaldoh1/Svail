//
//  ParticipantCollectionViewCell.h
//  Svail
//
//  Created by zhenduo zhu on 4/29/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileImageView.h"

@interface ParticipantCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet ProfileImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end
