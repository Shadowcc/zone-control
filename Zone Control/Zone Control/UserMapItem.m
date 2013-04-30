//
//  UserMapItem.m
//  Zone Control
//
//  Created by Scott Monroe on 4/5/13.
//  Copyright (c) 2013 Scott Monroe. All rights reserved.
//

#import "UserMapItem.h"

@implementation UserMapItem
- (CLLocationCoordinate2D)coordinate
{
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    return coordinate;
}
@end
