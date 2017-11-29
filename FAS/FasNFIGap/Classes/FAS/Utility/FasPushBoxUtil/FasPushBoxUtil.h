#import <UIKit/UIKit.h>

@interface FasPushBoxUtil : NSObject
{
}

- (id)init;
- (BOOL)isPushState;
- (void)checkPushState;
- (BOOL)isLastPushMessage:(NSString*)milliSec;
- (BOOL)isLastPushMessage:(NSString*)milliSec forAppCode:(NSString*)appCode;
- (void)setDeviceToken:(NSString*)deviceToken appCode:(NSString*)appCode;
- (NSString*)getDeviceToken:(NSString*)appCode;
- (void)setPushboxPrefSystemData:(NSString*)aData forKey:(NSString*)sysKey;
- (NSString*)getPushboxPrefSystemData:(NSString*)sysKey;
- (void)setMqttPrefData:(NSString*)aData forKey:(NSString*)sysKey;
- (NSString*)getMqttPrefData:(NSString*)sysKey;
- (void)setPushboxPrefData:(NSString*)aRootKey setData:(NSString*)aData forKey:(NSString*)aKey;
- (NSString*)getPushboxPrefData:(NSString*)aRootKey forKey:(NSString*)aKey;
- (id)getPushBoxPrefAllData;
- (id)getMqttPrefAllData;
- (void)logPushBoxPrefData;
- (NSDictionary*)getDeviceInfo;
- (NSString*) uniqueAppInstanceIdentifier;
- (BOOL)isOpenPushBox;
- (void)closePushBox;
- (void)alertBox:(NSString*)title message:(NSString*)msg buttonTitle:(NSString*)btn;
- (BOOL)confirmBox:(NSString*)title message:(NSString*)msg cancelButtonTitle:(NSString*)cancelBtn okButtonTitle:(NSString*)okBtn;
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (NSString*)NilToEmptyString:(NSString*)str;
- (void)setBadge:(NSInteger)badgeNumber;
- (void)upCountBadge;
- (void)downCountBadge;
- (void)dealloc;


@end