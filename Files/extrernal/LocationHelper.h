//
//  LocationHelper.h
//  SnowSmart
//
//  Created by kwangsik.shin on 2014. 9. 24..
//  Copyright (c) 2014년 SookmyungSmart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationHelper : NSObject

+ (void) setActive:(BOOL)active;

+ (instancetype)sharedLocationHelper;
+ (instancetype)sharedLocationHelperForRelocation;

- (BOOL)canGetLocationInformation;
- (CLLocationCoordinate2D)getCoordinate;

- (void)showAlertForAllowFindLocation;

@end
