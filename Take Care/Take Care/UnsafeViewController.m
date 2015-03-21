//
//  UnsafeViewController.m
//  TakeCare
//
//  Created by codeegoh on 3/20/15.
//  Copyright (c) 2015 Digify. All rights reserved.
//

#import "UnsafeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import "Constants.h"
#import "AFNetworking.h"

@interface UnsafeViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) CLRegion *region;
@property (assign, nonatomic) CLLocationCoordinate2D center;
@property (weak, nonatomic) IBOutlet UIImageView *imgPressHandler;
@property (weak, nonatomic) IBOutlet UILabel *lblLat;
@property (weak, nonatomic) IBOutlet UILabel *lblLong;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (assign, nonatomic) BOOL isAudioPlaying;
@property (weak, nonatomic) IBOutlet UIView *PINView;
@property (weak, nonatomic) IBOutlet UITextField *txtPIN;
@end

@implementation UnsafeViewController
CLGeocoder *geocoder;
CLPlacemark *placemark;
AVAudioPlayer *newPlayer;

#pragma mark - View Controller Lifecycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    /* Region latitude and logitude */
    // GMA NETWORK CENTRE
    self.center = CLLocationCoordinate2DMake(14.6337, 121.0435);
    
    
    // initialized AVAudio Player
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"siren" ofType: @"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    
    newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
    newPlayer.numberOfLoops = -1; // Loop indefinately
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupLocationManager];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopRegionMonitoring];
    [self.manager stopUpdatingLocation];
    self.manager = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.isAudioPlaying)
    {
        [newPlayer stop];
        self.isAudioPlaying = NO;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Long Press Gesture Recognizer
- (IBAction)longPressed:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        [self holdDown];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self holdRelease];
    }
}

#pragma mark - Action Methods
- (IBAction)backClicked:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Helper Methods
- (void)holdRelease
{
    [AnimationUtils animateShow:self.imgPressHandler];
    self.imgPressHandler.image = [UIImage imageNamed:@"tapimage.png"];
    
    
    [newPlayer play];
    self.isAudioPlaying = YES;
    
    [AnimationUtils animateShow:self.PINView];
    [self.txtPIN becomeFirstResponder];
    
    
    /* SEND SMS TO INFORM YOUR FRIENDS THAT YOU FEEL UNSAFE AT YOUR CURRENT LOCATION */
    dispatch_queue_t q = dispatch_queue_create("ph.com.goleng", NULL);
    dispatch_async(q, ^{
        
        NSString *msg = [NSString stringWithFormat:K_MESSAGE_NOT_SAFE, @"Gaile Sarmiento", self.lblAddress.text];
        
        NSArray *friendsContact = @[@"639997090756", @"639997090756"];
        
        for (NSString *contact in friendsContact)
        {
            [self sendSMSTo:contact withMessage:msg];
        }
        
        
    });
}

- (void)holdDown
{
    self.imgPressHandler.image = [UIImage imageNamed:@"logo.png"];
}

- (void)sendSMSTo:(NSString *)mobileNumber withMessage:(NSString *)msg
{
    //    [self.array_stories removeAllObjects];
    //    [self displayHUD];
    NSString *msgID = [self randomStringWithLength:32];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"message_type" : K_MESSAGE_TYPE,
                             @"mobile_number" : mobileNumber,
                             @"shortcode" : K_SHORTCODE,
                             @"message_id" : msgID,//K_MESSAGE_ID,
                             @"message" : msg,
                             @"client_id" : K_CLIENT_ID,
                             @"secret_key" : K_SECRET_KEY
                             };
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"https://post.chikka.com/smsapi/request" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"CHIKKA RESPONSE: %@", [responseObject description]);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        //[self hideHUD];
    }];
}

- (void)setupLocationManager
{
    if (K_DEBUG) NSLog(@"startLocationUpdates");
    
    /* Pinpoint our location with the following accuracy:
     *
     *     kCLLocationAccuracyBestForNavigation  highest + sensor data
     *     kCLLocationAccuracyBest               highest
     *     kCLLocationAccuracyNearestTenMeters   10 meters
     *     kCLLocationAccuracyHundredMeters      100 meters
     *     kCLLocationAccuracyKilometer          1000 meters
     *     kCLLocationAccuracyThreeKilometers    3000 meters
     */
    
    self.manager = [CLLocationManager new];
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;  // kCLLocationAccuracyBestForNavigation;
    self.manager.distanceFilter = kCLLocationAccuracyBest;   // kCLDistanceFilterNone;
    [self.manager startUpdatingLocation];
    
    geocoder = [[CLGeocoder alloc] init]; // INITIALIZED GEOCODER
}

#pragma mark - Location Methods
- (void)updateRegionMonitoring
{
    if ([CLLocationManager regionMonitoringAvailable]) // Does your device supports Geofencing
    {
        switch( [CLLocationManager authorizationStatus] )
        {
                
                /* The user has not yet made a choice regarding whether this application can use location services. */
            case  kCLAuthorizationStatusNotDetermined:
                if(K_DEBUG) NSLog(@"The user has not yet made a choice regarding whether this application can use location services.");
                break;
                
                /* This application is not authorized to use location services.
                 The user cannot change this application’s status,
                 possibly due to active restrictions such as parental controls being in place. */
            case kCLAuthorizationStatusRestricted:
                if(K_DEBUG) NSLog(@"This application is not authorized to use location services. The user cannot change this application’s status, possibly due to active restrictions such as parental controls being in place.");
                break;
                
                /* The user explicitly denied the use of location services for this application
                 or location services are currently disabled in Settings. */
            case kCLAuthorizationStatusDenied:
                if(K_DEBUG) NSLog(@"The user explicitly denied the use of location services for this application or location services are currently disabled ");
                break;
                
                /* Authorized */
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            case kCLAuthorizationStatusAuthorized:
            {
                [self startRegionMonitoring];
                if (K_DEBUG) NSLog(@"REGION MONITORING OK!");
                break;
            }
        }
    }
}

- (void)stopRegionMonitoring
{
    for (CLRegion *geofence in self.manager.monitoredRegions)
    {
        [self.manager stopMonitoringForRegion:geofence];
    }
}

- (void)startRegionMonitoring
{
    if (K_DEBUG) NSLog(@"STARTING BRANCHES MONITORING");
    
    // Remove old geogate data
    //[self stopRegionMonitoring];
    
    CLLocationDegrees radius = K_RADIUS;
    if (radius > self.manager.maximumRegionMonitoringDistance)
    {
        radius = self.manager.maximumRegionMonitoringDistance;
    }
    
    self.region = [[CLRegion alloc] initCircularRegionWithCenter:self.center radius:radius identifier:K_REGION_IDENTIFIER];
    
    [self.manager startMonitoringForRegion:self.region];
    
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:self.manager.location.coordinate.latitude longitude:self.manager.location.coordinate.longitude];
    
    CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude:self.region.center.latitude longitude:self.region.center.longitude];
    
    CLLocationDistance distance = [currentLocation distanceFromLocation:targetLocation];// DISTANCE IN METERS
    
    if (K_DEBUG) NSLog(@"ALL REGIONS:\n%@ - - DISTANCE:%f", [[self.manager monitoredRegions] description], distance);
    
    
    if (distance <= K_DISTANCE)
    {
        if (K_DEBUG) NSLog(@"distance <= K_DISTANCE");
        // Region is detected within monitored distance
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.lblLat.text = [NSString stringWithFormat:@"%.3f", self.manager.location.coordinate.latitude];
        self.lblLong.text = [NSString stringWithFormat:@"%.3f", self.manager.location.coordinate.longitude];
        
    });
    
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (K_DEBUG) NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0)
        {
            placemark = [placemarks lastObject];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.lblAddress.text = [NSString stringWithFormat:@" %@ %@\n%@ %@\n%@\n%@",
                                        placemark.subThoroughfare,
                                        placemark.thoroughfare,
                                        placemark.postalCode,
                                        placemark.locality,
                                        placemark.administrativeArea,
                                        placemark.country];
            });
            
        }
        else
        {
            if (K_DEBUG) NSLog(@"%@", error.debugDescription);
        }
    } ];
    
    
}


#pragma mark - Location Manager Update Methods
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (K_DEBUG) NSLog(@"didChangeAuthorizationStatus");
    
    switch (status)
    {
            /* The user has not yet made a choice regarding whether this application can use location services. */
        case  kCLAuthorizationStatusNotDetermined:
            if(K_DEBUG) NSLog(@"The user has not yet made a choice regarding whether this application can use location services.");
            break;
            
            /* This application is not authorized to use location services.
             The user cannot change this application’s status,
             possibly due to active restrictions such as parental controls being in place. */
        case kCLAuthorizationStatusRestricted:
            if(K_DEBUG) NSLog(@"This application is not authorized to use location services. The user cannot change this application’s status, possibly due to active restrictions such as parental controls being in place.");
            break;
            
            /* The user explicitly denied the use of location services for this application
             or location services are currently disabled in Settings. */
        case kCLAuthorizationStatusDenied:
            if(K_DEBUG) NSLog(@"The user explicitly denied the use of location services for this application or location services are currently disabled ");
            break;
            
            /* Authorized */
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorized:
        {
            [self startRegionMonitoring];
            if (K_DEBUG) NSLog(@"REGION MONITORING OK!");
            break;
        }
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (K_DEBUG) NSLog(@"didUpdateLocations");
    [self updateRegionMonitoring];
}

#pragma mark - Geofencing Callback Methods
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if (K_DEBUG) NSLog(@"didEnterRegion");
    
    /*
     CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:self.manager.location.coordinate.latitude longitude:self.manager.location.coordinate.longitude];
     
     CLLocation *fukuiLocation = [[CLLocation alloc] initWithLatitude:self.region.center.latitude longitude:self.region.center.longitude]; // DISTANCE IN METERS
     
     //1 meter == 100 centimeter
     //1 meter == 3.280 feet
     //1 square meter == 10.76 square feet
     */
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if (K_DEBUG) NSLog(@"didExitRegion");
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    if (K_DEBUG) NSLog(@"Monitoring failed: %@", error.localizedDescription);
}


#pragma mark - TextField Delegate Methods
- (IBAction)textEditingChanged:(UITextField *)sender
{
    if ([sender.text isEqualToString:@"1234"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [AnimationUtils animateHide:self.PINView withCallback:^{
                self.PINView.hidden = YES;
                [self.txtPIN resignFirstResponder];
            }];
        });
        
        
        /* SEND SMS TO INFORM YOUR FRIENDS THAT YOU NOW FEEL SAFE AT YOUR CURRENT LOCATION */
        dispatch_queue_t q = dispatch_queue_create("ph.com.goleng", NULL);
        dispatch_async(q, ^{
            
            NSString *msg = [NSString stringWithFormat:K_MESSAGE_SAFE, @"Gaile Sarmiento", self.lblAddress.text];
            
            NSArray *friendsContact = @[@"639997090756", @"639997090756"];
            
            for (NSString *contact in friendsContact)
            {
                [self sendSMSTo:contact withMessage:msg];
            }
            
        });
        
        if (self.isAudioPlaying)
        {
            [newPlayer stop];
            self.isAudioPlaying = NO;
        }
    }
}

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}


@end
