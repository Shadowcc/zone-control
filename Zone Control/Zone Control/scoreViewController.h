//
//  scoreViewController.h
//  Zone Control
//
//  Created by user on 4/19/13.
//  Copyright (c) 2013 Scott Monroe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GCDAsyncSocket;

@interface scoreViewController : UICollectionViewController
@property (strong, nonatomic) GCDAsyncSocket *asyncSocketA;

@end
