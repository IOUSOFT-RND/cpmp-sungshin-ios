//
//  DbObserver.h
//  emdm
//
//  Created by kdsooi on 13. 8. 6..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDKQueue.h"

@interface DbObserver : NSObject <VDKQueueDelegate>
{
    @private
    VDKQueue *observerQueue;
}

@property (nonatomic) VDKQueue *observerQueue;

- (void)addPath:(NSString *)aPath;

@end
