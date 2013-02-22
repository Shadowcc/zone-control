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
    [self connectToServer];
}
- (IBAction)captureTargetButtonClick:(UIBarButtonItem *)sender {
    [self removeAllAnnotations];
}
- (IBAction)pingLocationButtonClick:(UIBarButtonItem *)sender {
    [self connectToServer];
}

-(void)addTargetToMap:(Target*)newTarget{
    [self removeAllAnnotations];
    
    
    
    [self.mapView addAnnotation:newTarget];
    
}
-(void)connectToServer
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
	_asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    NSLog(@"Made it here");
    NSError *err = nil;
    if((![_asyncSocket connectToHost:@"63.152.117.50" onPort:8001 error:&err]))
    {
        NSLog(@"Error connecting: %@", err);
        
    }
    [_asyncSocket readDataToData:[GCDAsyncSocket LFData] withTimeout:15 tag:1];
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
    [socket connectToHost:@"63.152.117.50" onPort:80 error:&err];
    
    
}
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    
    
    // We're just going to send a test string to the server.
    
    NSString *myStr = @"testing...123...\r\n";
    NSData *myData = [myStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [_asyncSocket writeData:myData withTimeout:5.0 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSLog(@"socket:%p didReadData:withTag:%ld", sock, tag);
    
    
	NSString *httpResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
	NSLog(@"%@", httpResponse);
    
    
    
    NSArray *chunks = [httpResponse componentsSeparatedByString: @"*"];
    
    CLLocationCoordinate2D cord;
    NSString *lat = chunks[0];
    NSString *lon = chunks[1];
    
    cord.latitude = [lat doubleValue];
    cord.longitude = [lon doubleValue];
    
    Target *newTarget = [[Target alloc] initWithTitle:@"Capture Point" andCoordinate:cord];
    
    [self addTargetToMap:newTarget];
    
    
    
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
	
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	NSLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
}

@end

