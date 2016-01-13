//
//  Find_ViewController.m
//  Beacon_new
//
//  Created by Aaron Crawfis on 10/5/13.
//  Copyright (c) 2013 Aaron Crawfis. All rights reserved.
//

#import "Find_ViewController.h"
#import <Parse/Parse.h>
#import "Map_ViewController.h"
#import "MapViewAnnotation.h"
#define METERS_PER_MILE 1609.344

@interface Find_ViewController ()

@end

@interface AnnotationDelegate : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString * title;
    NSString * subtitle;
}
@end

@implementation Find_ViewController

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)locateBeacon:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Locate Beacon" message:@"What is Your Friend's Beacon?" delegate:self cancelButtonTitle:@"Find Friends!" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *beaconName =[[alertView textFieldAtIndex:0] text];
    NSLog(@"Entered: %@",beaconName);
    PFQuery *query = [PFQuery queryWithClassName:@"Beacon"];
    [query whereKey:@"beaconName" equalTo:beaconName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            for (PFObject *object in objects) {
                
                //////////////////////////////////////////////////////////////////
               
                NSTimeInterval timePassed = [object.createdAt timeIntervalSinceNow];
            
                if ( timePassed > -(5*60))
                {
                    NSLog(@"Success");
                   
                    
                    PFGeoPoint *geoPoint = [object objectForKey:@"geolocation"];
                    CLLocationCoordinate2D *beaconCoordinate = &((CLLocationCoordinate2D){geoPoint.latitude, geoPoint.longitude});
                    
                    // Map Annotation
                    MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc] initWithTitle:[[alertView textFieldAtIndex:0] text] andCoordinate:*beaconCoordinate];
                    [self.mapView addAnnotation:newAnnotation];
                    [self.mapView selectAnnotation:newAnnotation animated:YES];
                    
                    
                    // 1
                    CLLocationCoordinate2D zoomLocation;
                    zoomLocation.latitude = geoPoint.latitude;
                    zoomLocation.longitude= geoPoint.longitude;
                    
                    // 2
                    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
                    
                    // 3
                    [_mapView setRegion:viewRegion animated:YES];
                    
                    
                }
                //////////////////////////////////////////////////////////////////
                else
                {
                    NSLog(@"Fail");
                    UIAlertView *fail = [[UIAlertView alloc]initWithTitle: @"Please Try Again"
                                                                   message: @"This Beacon Does Not Exist"
                                                                  delegate: nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
                    
                    
                    [fail show];
                }
                
            }
            
        } else {
            
            
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];}

@end



