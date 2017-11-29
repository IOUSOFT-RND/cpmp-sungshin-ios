//
//  LocationHelper.m
//  SnowSmart
//
//  Created by kwangsik.shin on 2014. 9. 24..
//  Copyright (c) 2014년 SookmyungSmart. All rights reserved.
//

#import "LocationHelper.h"

#import <MapKit/MapKit.h>
#import "SmartDelegate.h"

@interface LocationHelper () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager * manager;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) NSTimer * timer;

@end

@implementation LocationHelper

static BOOL active_ = YES;
+ (void) setActive:(BOOL)active {
    active_ = active;
}

static __strong LocationHelper * loc_ = nil;

+ (instancetype)sharedLocationHelper {
    if (loc_ == nil) {
        loc_ = [[self alloc] init];
    }
    [loc_ startUpdatingLocation];
    return loc_;
}

+ (instancetype)sharedLocationHelperForRelocation {
    if (loc_ == nil) {
        loc_ = [[self alloc] init];
    }
    loc_.coordinate = CLLocationCoordinate2DMake(0, 0);
    [loc_ startUpdatingLocation];
    return loc_;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _coordinate = CLLocationCoordinate2DMake(0, 0);
        if (active_) {
            CLLocationManager * m = [[CLLocationManager alloc] init];
            m.delegate = self;
            m.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
            m.distanceFilter = 500.0f;
            self.manager = m;

            if ([m respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [m requestWhenInUseAuthorization];
            }
        }
    }
    return self;
}

- (void) startUpdatingLocation {
    if (active_) {
        [_manager startMonitoringSignificantLocationChanges];
        [_manager startUpdatingLocation];
    }
}

- (BOOL)canGetLocationInformation {
    if (active_) {
        return ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)? YES : NO;
    }
    else {
        return YES;
    }
}

static BOOL gettingCoordinate = YES;
- (CLLocationCoordinate2D)getCoordinate {
    if (active_) {
        if ([self canGetLocationInformation]) {
            if (_coordinate.latitude != 0.0) {
                return _coordinate;
            }
            [_manager startUpdatingLocation];

            _timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(gpsTimeout:) userInfo:nil repeats:NO];

            gettingCoordinate = YES;
            while (gettingCoordinate == YES) {
                [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2f]];
            }
        }
        return _coordinate;
    }
    return _coordinate;
}

- (void) timerInvalidate {
    [_timer invalidate];
    _timer = nil;
}

- (void) managerInvalidate {
    //    [_manager stopMonitoringSignificantLocationChanges];
    //    [_manager stopUpdatingLocation];
    //    _manager = nil;
}

- (void) gpsTimeout:(NSTimer*)timer {
    [self timerInvalidate];
    [self managerInvalidate];
    gettingCoordinate = NO;
}

- (void)showAlertForAllowFindLocation {
    [(id<SmartDelegate>)[UIApplication sharedApplication].delegate showAlertWithTitle:@"알림" :@"설정에서 위치서비스를 허용해주시기 바랍니다." :self :nil];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if ([locations count] > 0) {
        _coordinate = ((CLLocation*)[locations lastObject]).coordinate;
    }
    gettingCoordinate = NO;
    [self timerInvalidate];
    [self managerInvalidate];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    gettingCoordinate = NO;
    _coordinate.latitude = 0.0;
    _coordinate.longitude = 0.0;
    [self timerInvalidate];
    [self managerInvalidate];
}

- (void)dealloc {
    [self timerInvalidate];
    //[self managerInvalidate];
    [_manager stopMonitoringSignificantLocationChanges];
    [_manager stopUpdatingLocation];
    _manager = nil;
}

@end
