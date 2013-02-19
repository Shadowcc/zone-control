//
//  zonecontrolFirstViewController.m
//  Zone Control
//
//  Created by Scott Monroe on 2/12/13.
//  Copyright (c) 2013 Scott Monroe. All rights reserved.
//

#import "zonecontrolFirstViewController.h"
#define METERS_PER_MILE 1609.344
#import "Target.h"
#import "GCDAsyncSocket.h"

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
    
    
    
    
    
}
- (IBAction)addTargetButtonClick:(UIBarButtonItem *)sender {
    [self addTargetToMap:[self getTargetFromServer]];
}
- (IBAction)captureTargetButtonClick:(UIBarButtonItem *)sender {
    [self removeAllAnnotations];
}
- (IBAction)pingLocationButtonClick:(UIBarButtonItem *)sender {
    [self removeAllAnnotations];
}

-(void)addTargetToMap:(Target*)newTarget{
    [self removeAllAnnotations];
    
    
    
    [self.mapView addAnnotation:newTarget];

}

-(void)removeAllAnnotations
{
    id userAnnotation = self.mapView.userLocation;
    
    NSMutableArray *annotations = [NSMutableArray arrayWithArray:self.mapView.annotations];
    [annotations removeObject:userAnnotation];
    
    [self.mapView removeAnnotations:annotations];
}

-(Target*)getTargetFromServer
{
    CLLocationCoordinate2D cord;
    cord.latitude = 41.987673;
    cord.longitude = -91.657144;
    
    Target *newTarget = [[Target alloc] initWithTitle:@"Capture Point" andCoordinate:cord];
    return newTarget;
}

-(void)confirmTargetFromServer
{
    GCDAsyncSocket *socket;
    
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err = nil;
    [socket connectToHost:@"192.168.0.1" onPort:80 error:&err];
}

@end
