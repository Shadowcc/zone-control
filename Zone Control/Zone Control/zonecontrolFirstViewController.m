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

#import "CustomMapItem.h"
#import "CustomAnnotationView.h"

#import "UserMapItem.h"
#import "UserAnnotationView.h"







enum
{
    kCityAnnotationIndex = 0,
    kBridgeAnnotationIndex,
    kCapturePointIndex
};

@interface zonecontrolFirstViewController ()
@property (nonatomic, strong) NSMutableArray *mapAnnotations;

@end


@implementation zonecontrolFirstViewController



+ (CGFloat)annotationPadding;
{
    return 10.0f;
}

+ (CGFloat)calloutHeight;
{
    return 40.0f;
}


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    NSLog(@"Holy COW");
    // in case it's the user location, we already have an annotation, so just return nil
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // handle our three custom annotations
    //
        
    else if ([annotation isKindOfClass:[CustomMapItem class]])  // for Japanese Tea Garden
    {
        static NSString *TeaGardenAnnotationIdentifier = @"TeaGardenAnnotationIdentifier";
        
        CustomAnnotationView *annotationView =
        (CustomAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:TeaGardenAnnotationIdentifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:TeaGardenAnnotationIdentifier];
        }
        return annotationView;
    }
    else if ([annotation isKindOfClass:[UserMapItem class]])
    {
        UserAnnotationView *annotationView =
        (UserAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"hello"];
        if(annotationView == nil)
        {
            annotationView = [[UserAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"hello"];
            
        }
        return annotationView;
    }
     
    
    return nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _mapView.delegate = self;
   
    
	// Do any additional setup after loading the view, typically from a nib.
    _messageType = @"score";
        
    [self connectToServer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)turnLocOff
{
    _mapView.showsUserLocation = NO;
    
    id userAnnotation = self.mapView.userLocation;
    
    NSMutableArray *annotations = [NSMutableArray arrayWithArray:self.mapView.annotations];
    id customMap;
   for(id i in annotations)
   {
       
    if([i isKindOfClass:[CustomMapItem class]])
    {
        customMap = i;
    }
   }
    [annotations removeObject:customMap];
    [annotations removeObject:userAnnotation];
    
    
    [self.mapView removeAnnotations:annotations];

}

-(void)turnLocOn
{  [self.view reloadInputViews];
    
    
    /*CLLocationCoordinate2D cord;
    cord.latitude = _mapView.userLocation.location.coordinate.latitude;
    cord.longitude = _mapView.userLocation.location.coordinate.longitude;
    [self addUserItem:_mapView.userLocation.location.coordinate];*/
    _mapView.showsUserLocation = YES;
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(addUserItem:)
                                   userInfo:nil
                                    repeats:NO];
    

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
    
    _messageType = @"get";
    [self connectToServer];
}
- (IBAction)captureTargetButtonClick:(UIBarButtonItem *)sender {
    
    
       _messageType = @"confirm";
    [self connectToServer];
    //[self.mapView removeAnnotations:self.mapView.annotations];  // remove any annotations that exist
    
    //[self.mapView addAnnotation:[self.mapAnnotations objectAtIndex:kTeaGardenAnnotationIndex]];
    
}
- (void)timerFinished:(NSTimer *)timer
{
    [self turnLocOff];
}
-(void)enablePing:(NSTimer *)timer
{
    _pingButton.enabled = YES;
}
- (IBAction)pingLocationButtonClick:(UIBarButtonItem *)sender {
   
    [
        NSTimer scheduledTimerWithTimeInterval:2.0
                                        target:self
                                      selector:@selector(timerFinished:)
                                      userInfo:nil
                                       repeats:NO];
    
    [self turnLocOn];
    
    [NSTimer scheduledTimerWithTimeInterval:15.0
                                     target:self
                                   selector:@selector(enablePing:)
                                   userInfo:nil
                                    repeats:NO];
    
    _pingButton.enabled = NO;
    
   
    
    
    
}

-(void)addTargetToMap:(Target*)newTarget{
    [self removeAllAnnotations];
    
    
    
    [self.mapView addAnnotation: newTarget];
                            
    
}
-(void)connectToServer
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
	_asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    
    
    NSError *err = nil;
    if((![_asyncSocket connectToHost:@"172.16.14.80" onPort:8001 error:&err]))
       {
           NSLog(@"Error connecting: %@",	 err);
           
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
    NSString * userID = [UIDevice currentDevice].uniqueIdentifier;
    
    
    // We're just going to send a test string to the server.
    
    NSString *myStr = @"hello*hello*hello";
    
    if([_messageType isEqualToString:@"get"])
    {
        myStr = [NSString stringWithFormat:@"%@*get\r\n",userID];
    
    }
    if([_messageType isEqualToString:@"confirm"])
    {
        //need to get user location
        myStr = [NSString stringWithFormat:@"%@*confirm*%f*%f\r\n",userID,_mapView.userLocation.location.coordinate.latitude,
                 _mapView.userLocation.location.coordinate.longitude];
        
              
        
    
    }
    
    if([_messageType isEqualToString:@"score"])
    {
        
        
        myStr =[NSString stringWithFormat:@"%@*score\r\n",userID];
        
    }
    
    
    NSData *myData = [myStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [_asyncSocket writeData:myData withTimeout:5.0 tag:0];
}


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
	
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	NSLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSLog(@"socket:%p didReadData:withTag:%ld", sock, tag);
    
    
	NSString *httpResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
	NSLog(@"%@", httpResponse);
    
    
    
    NSArray *chunks = [httpResponse componentsSeparatedByString: @"*"];
    
    if([chunks[0] isEqualToString: @"confirm"])
    {
        if([chunks[1] isEqualToString:@"false"])
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you Lost???" message:@"FAILURE!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Jack Pot" message:@"Confirmed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [self removeAllAnnotations];
        
        }
        _score.text = chunks[2];
    }
    if([chunks[0] isEqualToString:@"get"])
    {
        NSLog(@"made it here to get");
        CLLocationCoordinate2D cord;
        NSString *lat = chunks[1];
        NSString *lon = chunks[2];
        
        cord.latitude = [lat doubleValue];
        cord.longitude = [lon doubleValue];
        
        [self addCaptureItem:cord];
    }
    if([chunks[0] isEqualToString:@"score"])
    {
        _score.text = chunks[1];    }
    /*
    CLLocationCoordinate2D cord;
    NSString *lat = chunks[0];
    NSString *lon = chunks[1];
    
    cord.latitude = [lat doubleValue];
    cord.longitude = [lon doubleValue];
    
    Target *newTarget = [[Target alloc] initWithTitle:@"Capture Point" andCoordinate:cord];
    
    [self addTargetToMap:newTarget];
     */
    
    
    
}

-(void)addCaptureItem:(CLLocationCoordinate2D)cord
{
    CustomMapItem *item = [[CustomMapItem alloc] init];
    item.place = @"Target";
    item.imageName = @"target";
    item.latitude = [NSNumber numberWithDouble:cord.latitude];
    item.longitude = [NSNumber numberWithDouble:cord.longitude];
    [self.mapView addAnnotation: item];

}

-(void)addUserItem:(NSTimer *)timer
{
    UserMapItem *item = [[UserMapItem alloc] init];
    item.place = @"User Location";
    item.imageName = @"android";
   
    item.latitude =[NSNumber numberWithDouble:_mapView.userLocation.location.coordinate.latitude];
    item.longitude = [NSNumber numberWithDouble:_mapView.userLocation.location.coordinate.longitude];
    NSLog([NSString stringWithFormat:@"%f", _mapView.userLocation.location.coordinate.latitude]);
    [self.mapView addAnnotation: item];
}





@end

