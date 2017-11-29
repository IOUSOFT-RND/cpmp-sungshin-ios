////
////  DataHelper.m
////  Smart
////
////  Created by hwansday on 2014. 5. 1..
////  Copyright (c) 2014년 GGIHUB. All rights reserved.
////
//
//#import "DataHelper.h"
//#import "AppDelegate.h"
//
//
//@implementation DataHelper
//
//+ (BOOL)insertPushData:(NSMutableDictionary *)dic
//{
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    PushData *pushData = (PushData *)[NSEntityDescription insertNewObjectForEntityForName:@"PushData" inManagedObjectContext:appDelegate.managedObjectContext];
//    
//    pushData.type = [NSString stringWithFormat:@"%@", [dic valueForKey:@"type"]];
//    pushData.title = [NSString stringWithFormat:@"%@", [dic valueForKey:@"title"]];
//    pushData.message = [NSString stringWithFormat:@"%@", [dic valueForKey:@"message"]];
//    pushData.sender = [NSString stringWithFormat:@"%@", [dic valueForKey:@"sender"]];
//    pushData.date = [NSString stringWithFormat:@"%@", [dic valueForKey:@"date"]];
//    pushData.time = [NSString stringWithFormat:@"%@", [dic valueForKey:@"time"]];
//    pushData.pushdata = [NSString stringWithFormat:@"%@", [dic valueForKey:@"pushdata"]];
//    pushData.addtime = [NSDate date];
//    
//    NSError *error;
//    
//    if (![[appDelegate managedObjectContext] save:&error]) {
//       DLog(@"PushData Insert Error : %@", [error localizedDescription]);
//        return NO;
//    }
//    
//    return YES;
//}
//
//+ (NSMutableArray *)getPushDataList
//{
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    NSFetchRequest *fetchRequest = [NSFetchRequest new];
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"PushData" inManagedObjectContext:[appDelegate managedObjectContext]];
//    
//    [fetchRequest setEntity:entityDescription];
//    
//    NSError *error;
//    
//    NSMutableArray *arrResult = [[[appDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error] mutableCopy];
//    
//    if (error) {
//       DLog(@"PushData getList Error : %@", [error localizedDescription]);
//        arrResult = [NSMutableArray array];
//    }
//
//    return [NSMutableArray arrayWithArray:arrResult];
//}
//
//+(BOOL)deleteMenuData{
//       NSError *error;
//       AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//       NSURL *storeURL = [[appDelegate applicationDocumentsDirectory] URLByAppendingPathComponent:@"Smart.sqlite"];
//       [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
//      if (error) {
//          return NO;
//      }else{
//        return YES;
//      }
//
//}
//
//@end
