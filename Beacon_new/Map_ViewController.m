//
//  Map_ViewController.m
//  Beacon_new
//
//  Created by Aaron Crawfis on 10/4/13.
//  Copyright (c) 2013 Aaron Crawfis. All rights reserved.
//

#import "Map_ViewController.h"
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import "MapViewAnnotation.h"

#define METERS_PER_MILE 1609.344

@interface Map_ViewController ()

@end

@implementation Map_ViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            // do something with the new geoPoint
            // 1
            CLLocationCoordinate2D zoomLocation;
            zoomLocation.latitude = geoPoint.latitude;
            zoomLocation.longitude= geoPoint.longitude;
            
            // 2
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
            
            // 3
            [_mapView setRegion:viewRegion animated:YES];
        }
    }];
   
}



-(IBAction)createBeacon:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"New Beacon" message:@"Let Your Friends Know How to Find You" delegate:self cancelButtonTitle:@"Find Me!" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            // do something with the new geoPoint
            PFObject *send = [PFObject objectWithClassName:@"Beacon"];
            [send setObject:[[alertView textFieldAtIndex:0] text] forKey:@"beaconName"];
            [send setObject:geoPoint forKey:@"geolocation"];
            [send saveInBackground];
            UIAlertView *done = [[UIAlertView alloc]initWithTitle: @"Success"
                                                           message: @"Your Beacon is Now Active for 5 Minutes"
                                                          delegate: nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            
            
            [done show];
        }
    }];

}

@end
