//
//  DataBaseFileUpdataDB.h
//  emdm
//
//  Created by jaewon on 2014. 3. 24..
//
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import "Db.h"
#import "EnumDef.h"

@interface DataBaseFileUpdataDB : NSObject <Db>

+(void)dbFileUpdateCheck:(NSString *)CurrentVersion;

@end
