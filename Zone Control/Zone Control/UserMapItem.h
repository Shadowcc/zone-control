//
//  UserMapItem.h
//  Zone Control
//
//  Created by Scott Monroe on 4/5/13.
//  Copyright (c) 2013 Scott Monroe. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface UserMapItem : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, strong) NSString *place;
@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
