//
//  ScoreCell.h
//  Zone Control
//
//  Created by user on 4/19/13.
//  Copyright (c) 2013 Scott Monroe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@end
