//
//  zonecontrolFirstViewController.h
//  Zone Control
//
//  Created by Scott Monroe on 2/12/13.
//  Copyright (c) 2013 Scott Monroe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>



@class GCDAsyncSocket;



@interface zonecontrolFirstViewController : UIViewController <MKMapViewDelegate>
{
    
    
}


@property (weak, nonatomic) IBOutlet UILabel *score;
@property (strong, nonatomic) GCDAsyncSocket *asyncSocket;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) NSString *messageType;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pingButton;





@end

