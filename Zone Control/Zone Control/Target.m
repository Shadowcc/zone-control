//
//  Target.m
//  Zone Control
//
//  Created by Scott Monroe on 2/14/13.
//  Copyright (c) 2013 Scott Monroe. All rights reserved.
//

#import "Target.h"

@implementation Target

@synthesize title, coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d {
	self = [super init];
	title = ttl;
	coordinate = c2d;
	return self;
}


	


@end
