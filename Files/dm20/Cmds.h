//
//  Cmds.h
//  emdm
//
//  Created by kdsooi on 13. 7. 26..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonSerializer.h"

@interface Cmds : NSObject <JsonSerializer>
{
    @private
    NSMutableArray *cmds;
}

@property (nonatomic) NSMutableArray *cmds;

@end
