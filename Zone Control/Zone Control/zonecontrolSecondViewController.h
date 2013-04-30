//
//  zonecontrolSecondViewController.h
//  Zone Control
//
//  Created by Scott Monroe on 2/12/13.
//  Copyright (c) 2013 Scott Monroe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCDAsyncSocket;

@interface zonecontrolSecondViewController : UICollectionViewController

@property (strong, nonatomic) GCDAsyncSocket *asyncSocket;

@end
