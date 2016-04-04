//
//  ViewController.m
//  ExampleProject
//
//  Created by Carnival Mobile
//  Copyright (c) 2015 Carnival Mobile. All rights reserved.
//
//  For documentation see http://docs.carnivalmobile.com
//

#import "ExampleViewController.h"
#import <Carnival/Carnival.h>

@interface ExampleViewController () <CarnivalMessageStreamDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ExampleViewController

#pragma mark - view lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLocationManager];
    
    // Set this viewcontroller as the CarnivalMessageStream's delegate
    [CarnivalMessageStream setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startLocationTrackingInBackground];
    
    [Carnival deviceID:^(NSString *deviceID, NSError *error) {
        NSLog(@"DeviceID of current device: %@, with possible error: %@",deviceID, error);
    }];
}

#pragma mark - setup

- (void)setupLocationManager {
    // Create the location manager and set ourselves as the delegate
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // The above is all you need for significant location updates
    // For standard location services you may want some extra settings
    //self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    //self.locationManager.distanceFilter = 1000.0f
}

#pragma mark - location tracking

- (void)startLocationTrackingInBackground {
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    
    // Always check if you are authorized to start location services
    if (authorizationStatus != kCLAuthorizationStatusDenied && authorizationStatus != kCLAuthorizationStatusRestricted) {
        CLLocationManager *manager = self.locationManager;
        
        // Check if we are on iOS 8, where we have to request permissions differently than on previous iOS versions
        if ([manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            // Request permission to always monitor location updates, in foreground and background
            // Note: this method prompts the user for location permissions on iOS 8 and above
            [manager requestAlwaysAuthorization];
        }
        
        if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
            // Note: this method prompts the user for location permissions on iOS 7 and below
            [manager startMonitoringSignificantLocationChanges];
        }
        else {
            // If you want to support devices that don't have significant location monitoring you can fall back to standard location services
            // Note: this method prompts the user for location permissions on iOS 7 and below
            [manager startUpdatingLocation];
        }
    }
}

- (void)stopLocationTrackingInBackground {
    if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
        [self.locationManager stopMonitoringSignificantLocationChanges];
    }
    else {
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)startLocationTrackingInForegroundOnly {
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    
    // Always check if you are authorized to start location services
    if (authorizationStatus != kCLAuthorizationStatusDenied && authorizationStatus != kCLAuthorizationStatusRestricted) {
        CLLocationManager *manager = self.locationManager;
        
        // Check if we are on iOS 8, where we have to requet permissions differently than on previous iOS versions
        if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            // Request permission to monitor location updates when the app is in use
            // Note: this method prompts the user for location permissions on iOS 8 and above
            [manager requestWhenInUseAuthorization];
        }
        
        // Note: this method prompts the user for location permissions on iOS 7 and below
        [manager startUpdatingLocation];
    }
}

- (void)stopLocationTrackingInForegroundOnly {
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // Send the last location object as that is the most recent one always
    [Carnival updateLocation:[locations lastObject]];
}

#pragma mark - CarnivalMessageStreamDelegate

- (void)willShowMessageOfType:(CarnivalMessageType)messageType {
    NSLog(@"willShowMessageOfType: %ld",(long)messageType);
    
    // You can use this method to mute audio during videos or fake phone calls
}

- (void)didShowMessageOfType:(CarnivalMessageType)messageType {
    NSLog(@"didShowMessageOfType: %li", (long)messageType);
    
    // You can use this method to mute audio during videos or fake phone calls
}

- (void)willDismissMessageOfType:(CarnivalMessageType)messageType {
    NSLog(@"willDismissMessageOfType: %li",(long)messageType);
    
    // You can use this method to unmute audio during videos or fake phone calls
}

- (void)didDismissMessageOfType:(CarnivalMessageType)messageType {
    NSLog(@"didDismissMessageOfType: %li", (long)messageType);
    
    // You can use this method to unmute audio during videos or fake phone calls
}

- (void)willShowInAppNotificationForMessageType:(CarnivalMessageType)messageType {
    NSLog(@"willShowInAppNotificationForMessageType: %li", (long)messageType);
    
    // You can use this method to do something when an in-app notification is shown
}

- (void)didShowInAppNotificationForMessageType:(CarnivalMessageType)messageType {
    NSLog(@"didShowInAppNotificationForMessageType: %li", (long)messageType);
    
    // You can use this method to do something when an in-app notification is shown
}

#pragma mark - pressed actions

- (IBAction)getTagsButtonPressed:(UIButton *)sender {
    // Asyncronously gets the tags for this device.
    [Carnival getTagsInBackgroundWithResponse:^(NSArray *tags, NSError *error) {
        NSLog(@"getTagsInBackgroundWithResponse returned tags: %@",tags);
    }];
}

- (IBAction)addTagButtonPressed:(UIButton *)sender {
    // Asyncronously adds the tag for this device
    // If the tag is already registered with Carnival, this method does not add the tag again.
    [Carnival addTags:@[@"CARNIVAL_ADD_TAG_EXAMPLE_TAG"] inBackgroundWithResponse:^(NSArray *tags, NSError *error) {
        NSLog(@"addTag:inBackgroundWithResponse: returned tags: %@",tags);
    }];
}

- (IBAction)setTagsButtonPressed:(UIButton *)sender {
    NSArray *exampleTags = @[@"CARNIVAL_SET_TAGS_EXAMPLE_TAG_1", @"CARNIVAL_SET_TAGS_EXAMPLE_TAG_2"];
    
    // Asyncronously sets the tags for Carnival for this device
    // Calling this method will overwrite any previously set tags for this device.
    // Passing nil for the tags argument will clear the tags for this device
    [Carnival setTagsInBackground:exampleTags withResponse:^(NSArray *tags, NSError *error) {
        NSLog(@"setTagsInBackground:withResponse: returned tags: %@",tags);
    }];
}


- (IBAction)logEventButtonPressed:(UIButton *)sender {
    [Carnival logEvent:@"example_event_name"];
}

- (IBAction)setStringButtonPressed:(UIButton *)sender {
    [Carnival setString:@"example_string" forKey:@"example_string_key" withResponse:^(NSError *error) {
        NSLog(@"setString returned with possible error: %@",error);
    }];
}

- (IBAction)setFloatButtonPressed:(UIButton *)sender {
    [Carnival setFloat:1.23f forKey:@"example_float_key" withResponse:^(NSError *error) {
        NSLog(@"setFloat returned with possible error: %@",error);
    }];
}

- (IBAction)setIntegerButtonPressed:(UIButton *)sender {
    [Carnival setInteger:123 forKey:@"example_integer_key" withResponse:^(NSError *error) {
        NSLog(@"setInteger returned with possible error: %@",error);
    }];
}

- (IBAction)setDateButtonPressed:(UIButton *)sender {
    [Carnival setDate:[NSDate date] forKey:@"example_date_key" withResponse:^(NSError *error) {
        NSLog(@"setDate returned with possible error: %@",error);
    }];
}

- (IBAction)setBooleanButtonPressed:(UIButton *)sender {
    [Carnival setBool:YES forKey:@"example_bool_key" withResponse:^(NSError *error) {
        NSLog(@"setBOOL returned with possible error: %@",error);
    }];
}

- (IBAction)removeStringButtonPressed:(UIButton *)sender {
    [Carnival removeAttributeWithKey:@"example_string_key" withResponse:^(NSError *error) {
        NSLog(@"removeAttributeWithKey: returned with possible error: %@",error);
    }];
}

- (IBAction)setUserIDButtonPressed:(UIButton *)sender {
    [Carnival setUserId:@"example_user_id" withResponse:^(NSError *error) {
        NSLog(@"setUserID returned with possible error: %@",error);
    }];
}

@end
