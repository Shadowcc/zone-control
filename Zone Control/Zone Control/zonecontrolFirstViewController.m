//
//  zonecontrolFirstViewController.m
//  Zone Control
//
//  Created by Scott Monroe on 2/12/13.
//  Copyright (c) 2013 Scott Monroe. All rights reserved.
//

#import "zonecontrolFirstViewController.h"
#define METERS_PER_MILE 1609.344

@interface zonecontrolFirstViewController ()

@end

@implementation zonecontrolFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    // 1
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 41.987673;
    zoomLocation.longitude= -91.657144;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.2*METERS_PER_MILE, 0.2*METERS_PER_MILE);
    
    // 3
    [_mapView setRegion:viewRegion animated:YES];
    
    //CLLocationCoordinate2D cord;
    //cord.latitude = 41.987673;
    //cord.longitude = -91.657144;
    //NSDictionary *address;
   // //[address init];
    //MKPlacemark *place;
    //[place initWithCoordinate:cord addressDictionary: address];
    
    //[self.mapView addAnnotation:place];
    
    
    
}
@end
