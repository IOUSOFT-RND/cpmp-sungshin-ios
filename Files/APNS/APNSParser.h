//
//  APNSParser.h
//  emdm
//
//  Created by jaewon on 13. 8. 7..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>


@class warningPopupViewController;

@interface APNSParser : NSObject
{
    NSString *test;
    warningPopupViewController *mPopupView;
}

@property(strong,nonatomic) NSString *test;

+(void)executeAPNSMessage:(NSDictionary *)message;
@end
