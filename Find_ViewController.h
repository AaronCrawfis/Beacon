//
//  Find_ViewController.h
//  Beacon_new
//
//  Created by Aaron Crawfis on 10/5/13.
//  Copyright (c) 2013 Aaron Crawfis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface Find_ViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)locateBeacon:(id)sender;


@end
