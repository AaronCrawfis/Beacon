//
//  MapViewAnnotation.m
//  Beacon_new
//
//  Created by Aaron Crawfis on 10/5/13.
//  Copyright (c) 2013 Aaron Crawfis. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize title, coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d {
	self=[super init];
	title = ttl;
	coordinate = c2d;
	return self;
}

@end