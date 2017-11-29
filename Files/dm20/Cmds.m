//
//  Cmds.m
//  emdm
//
//  Created by kdsooi on 13. 7. 26..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "Cmds.h"
#import "Debug.h"

@implementation Cmds
@synthesize cmds;

- (id)encode
{    
    return cmds;
}

- (void)decode:(id)input
{
    if (input == nil)
    {
        LOG(INFO, "input == nil");
        return;
    }
    
    cmds = input;
}

- (NSString *)toString
{
    NSMutableString *string = [[NSMutableString alloc] init];
    
    [string appendString:@"Cmds ["];
    [string appendString:[NSString stringWithFormat:@"%@", cmds]];
    [string appendString:@"]"];
    
    return string;
}

@end
