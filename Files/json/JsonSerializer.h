//
//  JsonSerializer.h
//  emdm
//
//  Created by kdsooi on 13. 7. 23..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JsonSerializer

- (id)encode;
- (void)decode:(id)input;
- (id)toString;

@end
