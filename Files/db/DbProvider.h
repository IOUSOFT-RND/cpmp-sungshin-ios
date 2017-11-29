//
//  DbProvider.h
//  emdm
//
//  Created by kdsooi on 13. 8. 6..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DbObserver;

@interface DbProvider : NSObject

+ (void)createDb;
+ (void)AllDeleteDb;
+ (void)addDbObserver:(DbObserver *)mdbobserver;

@end
