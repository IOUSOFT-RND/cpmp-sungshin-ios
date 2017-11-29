//
//  ActionManager.h
//  DAS
//
//  Created by VineIT-iMac on 2014. 12. 5..
//  Copyright (c) 2014년 VineIT-iMac. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ActionDelegate <NSObject>

@optional

- (void)beaconManager:(BeaconManager *)aManager didRangeBeacons:(NSArray *)aBeacons inRegion:(Region *)aRegion;

- (void)beaconManager:(BeaconManager *)aManager rangingBeaconsDidFailForRegion:(Region *)aRegion withError:(NSError *)aError;

- (void)beaconManager:(BeaconManager *)aManager didDetermineState:(CLRegionState)aState forRegion:(Region *)aRegion;

- (void)beaconManager:(BeaconManager *)aManager didEnterRegion:(Region *)aRegion;

- (void)beaconManager:(BeaconManager *)aManager didExitRegion:(Region *)aRegion;

- (void)beaconManager:(BeaconManager *)aManager didFailWithError:(NSError *)aError;

- (void)beaconManager:(BeaconManager *)aManager monitoringDidFailForRegion:(Region *)aRegion withError:(NSError *)aError;

- (void)beaconManager:(BeaconManager *)aManager didStartMonitoringForRegion:(CLRegion *)aRegion;

@end