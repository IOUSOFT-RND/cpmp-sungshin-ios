//
//  Common.m
//  Smart
//
//  Created by hwansday on 2014. 5. 1..
//  Copyright (c) 2014년 GGIHUB. All rights reserved.
//
#import "Common.h"
#import "LocationHelper.h"
#import "DataManager.h"
#import "AESHelper.h"
#import "ServerIndexEnum.h"

#define M_PTO @"M_PTO.dat"

static NSString * serverAddress_ = SERVER_CORE;
static NSString * mobileServerAddress_ = SERVER_CORE;
static NSMutableDictionary * addressDic_ = nil;

@implementation Common




//Ryu add  아이콘 흰색으로 만들기
+(UIImage*)imageWhiteWithImage:(UIImage*)image
{
    // get width and height as integers, since we'll be using them as
    // array subscripts, etc, and this'll save a whole lot of casting
    CGSize size = image.size;
    int width = size.width;
    int height = size.height;
    
    // Create a suitable RGB+alpha bitmap context in BGRA colour space
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *memoryPool = (unsigned char *)calloc(width*height*4, 1);
    CGContextRef context = CGBitmapContextCreate(memoryPool, width, height, 8, width * 4, colourSpace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colourSpace);
    
    // draw the current image to the newly created context
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
    
    // run through every pixel, a scan line at a time...
    for(int y = 0; y < height; y++)
    {
        // get a pointer to the start of this scan line
        unsigned char *linePointer = &memoryPool[y * width * 4];
        
        // step through the pixels one by one...
        for(int x = 0; x < width; x++)
        {
            // get RGB values. We're dealing with premultiplied alpha
            // here, so we need to divide by the alpha channel (if it
            // isn't zero, of course) to get uninflected RGB. We
            // multiply by 255 to keep precision while still using
            // integers
            int r, g, b;
            if(linePointer[3])
            {
                // perform the colour inversion
                r = 255;
                g = 255;
                b = 255;
            }
            else
                r = g = b = 0;
            
            
            //            NSLog(@"RGB(%d,%d):%d,%d,%d", x,y,r,g,b);
            
            // multiply by alpha again, divide by 255 to undo the
            // scaling before, store the new values and advance
            // the pointer we're reading pixel data from
            linePointer[0] = r * linePointer[3] / 255;
            linePointer[1] = g * linePointer[3] / 255;
            linePointer[2] = b * linePointer[3] / 255;
            linePointer += 4;
        }
    }
    
    // get a CG image from the context, wrap that into a
    // UIImage
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    
    // clean up
    CGImageRelease(cgImage);
    CGContextRelease(context);
    free(memoryPool);
    
    // and return
    return returnImage;
}



+(void)setServerAddress:(NSString*)address {
    serverAddress_ = address;
}

+(void)setMobileServerAddress:(NSString*)address {
    mobileServerAddress_ = address;
}

+(void)setAddress:(NSString*)address key:(NSString*)key {
    if (key) {
        if (addressDic_ == nil) addressDic_ = [NSMutableDictionary dictionary];
        if (address)    [addressDic_ setObject:address forKey:key];
        else            [addressDic_ removeObjectForKey:key];
    }
}

+(NSString*)addressHomePage {
    return mobileServerAddress_;
}

+(NSString*)addressFaq {
    NSString * address = [addressDic_ objectForKey:NSStringFromSelector(_cmd)];
    if (address) {
        if ([address hasPrefix:HTTP]) {
            return address;
        }
    }
    else {
        address = @"/mobile/board.php?type=faq";
    }
    return [NSString stringWithFormat:@"%@%@%@", HTTP, serverAddress_, address];
}

+(NSString*)addressUpdate {
    NSString * address = [addressDic_ objectForKey:NSStringFromSelector(_cmd)];
    if (address) {
        if ([address hasPrefix:HTTP]) {
            return address;
        }
    }
    else {
        address = @"/interface/getVersionInfo.php";
    }
    return [NSString stringWithFormat:@"%@%@%@", HTTP, serverAddress_, address];
}

+(NSString*)addressLogin {
    NSString * address = [addressDic_ objectForKey:NSStringFromSelector(_cmd)];
    if (address) {
        if ([address hasPrefix:HTTP]) {
            return address;
        }
    }
    else {
        address = @"/interface/login.php";
    }
    return [NSString stringWithFormat:@"%@%@%@", HTTP, serverAddress_, address];       // (HTTP SERVER @"/custom/handong/login.php")
}

+(NSString*)addressServiceList {
    NSString * address = [addressDic_ objectForKey:NSStringFromSelector(_cmd)];
    if (address) {
        if ([address hasPrefix:HTTP]) {
            return address;
        }
    }
    else {
        address = @"/interface/getServiceList.php";
    }
    return [NSString stringWithFormat:@"%@%@%@", HTTP, serverAddress_, address];
}

+(NSString*)addressSendTocken {
    NSString * address = [addressDic_ objectForKey:NSStringFromSelector(_cmd)];
    if (address) {
        if ([address hasPrefix:HTTP]) {
            return address;
        }
    }
    else {
        address = @"/interface/savePushToken.php";
    }
    return [NSString stringWithFormat:@"%@%@%@", HTTP, serverAddress_, address];
}

+(NSString*)addressNoticeList {
    NSString * address = [addressDic_ objectForKey:NSStringFromSelector(_cmd)];
    if (address) {
        if ([address hasPrefix:HTTP]) {
            return address;
        }
    }
    else {
        address = @"/interface/getNoticeList.php";
    }
    return [NSString stringWithFormat:@"%@%@%@", HTTP, serverAddress_, address];
}

+(NSString*)addressNotice {
    NSString * address = [addressDic_ objectForKey:NSStringFromSelector(_cmd)];
    if (address) {
        if ([address hasPrefix:HTTP]) {
            return address;
        }
    }
    else {
        address = @"/mobile/board.php?type=notice";
    }
    return [NSString stringWithFormat:@"%@%@%@", HTTP, serverAddress_, address];
}

+(NSString*)addressMessageList {
    NSString * address = [addressDic_ objectForKey:NSStringFromSelector(_cmd)];
    if (address) {
        if ([address hasPrefix:HTTP]) {
            return address;
        }
    }
    else {
        address = @"/interface/getMessageList.php?user_id=%@";
    }
    return [NSString stringWithFormat:@"%@%@%@", HTTP, serverAddress_, address];
}

+(NSString*)addressMessage {
    NSString * address = [addressDic_ objectForKey:NSStringFromSelector(_cmd)];
    if (address) {
        if ([address hasPrefix:HTTP]) {
            return address;
        }
    }
    else {
        address = @"/mobile/message.php?user_id=%@";
    }
    return [NSString stringWithFormat:@"%@%@%@", HTTP, serverAddress_, address];
}

+(NSString*)addressShortCut {
    NSString * address = [addressDic_ objectForKey:NSStringFromSelector(_cmd)];
    if (address) {
        if ([address hasPrefix:HTTP]) {
            return address;
        }
    }
    else {
        address = @"/interface/getShortcutList.php";
    }
    return [NSString stringWithFormat:@"%@%@%@", HTTP, serverAddress_, address];
}

+(NSString*)addressSmartId {
    NSString * address = [addressDic_ objectForKey:NSStringFromSelector(_cmd)];
    if (address) {
        if ([address hasPrefix:HTTP]) {
            return address;
        }
    }
    else {
        address = @"/interface/getMIDInfo.php";
    }
    return [NSString stringWithFormat:@"%@%@%@", HTTP, serverAddress_, address];
}

+(NSString*)addressCheckSmartId {
    NSString * address = [addressDic_ objectForKey:NSStringFromSelector(_cmd)];
    if (address) {
        if ([address hasPrefix:HTTP]) {
            return address;
        }
    }
    else {
        address = @"/mobileid/mid_reg_m.php?user_id=%@&push_token=%@";
    }
    return [NSString stringWithFormat:@"%@%@%@", HTTP, serverAddress_, address];
}

+(NSString*)addressJoinSmartId {
    /* 쓰는데가 아직 없음. */
    NSString * address = [addressDic_ objectForKey:NSStringFromSelector(_cmd)];
    if (address) return address;
    return (HTTP @"/library/SelectSeat.html?user_sno={SNO}");
}

+(NSString*)addressSendPush {
    NSString * address = [addressDic_ objectForKey:NSStringFromSelector(_cmd)];
    if (address) {
        if ([address hasPrefix:HTTP]) {
            return address;
        }
    }
    else {
        address = @"/interface/push/sendPush.php";
    }
    return [NSString stringWithFormat:@"%@%@%@", HTTP, serverAddress_, address];
}

+(NSString*)addressPushInfo {
    NSString * address = [addressDic_ objectForKey:NSStringFromSelector(_cmd)];
    if (address) {
        if ([address hasPrefix:HTTP]) {
            return address;
        }
    }
    else {
        address = @"/interface/push/getPushInfo.php";
    }
    return [NSString stringWithFormat:@"%@%@%@", HTTP, serverAddress_, address];
}

+(NSString*)addressLoggingWithRunMenu {
    return [NSString stringWithFormat:@"%@", serverAddress_];
}

+(NSString*)addressLoggingWithErrorWeb {
    return [NSString stringWithFormat:@"%@", serverAddress_];

}

+(NSString*)addressLoggingWithTagging {
    return [NSString stringWithFormat:@"%@",serverAddress_];
}

+(NSString*)addressHttpCheck:(NSString *)address {
    
    if (address) {
        if ([address hasPrefix:HTTP]) {
            return address;
        }
    }
    else {
        address = @"";
    }
    return [NSString stringWithFormat:@"%@%@", HTTP, address];
}

+ (UIColor *) colorWithHexString: (NSString *) hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    if ([colorString length] == 1 || [colorString length] == 2 ) {
        

        if([hexString isEqualToString:@"1"]){
            colorString = @"6dc7dc";
        }else if([hexString isEqualToString:@"2"]){
            colorString = @"77add9";
        }else if([hexString isEqualToString:@"3"]){
            colorString = @"5e83cc";
        }else if([hexString isEqualToString:@"4"]){
            colorString = @"8e73b2";
        }else if([hexString isEqualToString:@"5"]){
            colorString = @"aab736";
        }else if([hexString isEqualToString:@"6"]){
            colorString = @"79938c";
        }else if([hexString isEqualToString:@"7"]){
            colorString = @"858b99";
        }else if([hexString isEqualToString:@"8"]){
            colorString = @"c1669a";
        }else if([hexString isEqualToString:@"9"]){
            colorString = @"ba840f";
        }else if([hexString isEqualToString:@"10"]){
            colorString = @"074475";
        }
        // Ryu Add 커스텀 컬러를 쓰는 경우
        if ([DataManager getInstance].isEnabledCustomFabvoritesColor && [DataManager getInstance].customColorArray) {
            int i = [hexString intValue];
            colorString = [[DataManager getInstance].customColorArray objectAtIndex:i-1];
        }
    }
    
    switch ([colorString length]) {
        case 1: // flow down
        case 2: {
        }
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            return nil;
//            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

+ (NSString *)convertGyosiNumber:(int)num
{
    switch (num) {
        case 1:
            return @"st";
            break;
            
        case 2:
            return @"nd";
            break;
            
        case 3:
            return @"rd";
            break;
            
        default:
            return @"th";
            break;
    }
}

+ (NSString *)dataPhotoFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:M_PTO];
}

+ (BOOL)dataFilePhotoDelete{
    // Documents 경로에 파일 삭제
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path;
    path = [documentsDirectory stringByAppendingPathComponent:M_PTO];
    
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

+ (BOOL)dataFilePhotoSave:(NSData*)saveData{
    return  [saveData writeToFile:[self dataPhotoFilePath] atomically:YES];
}

//
//+ (NSString *)dataFilePath{
//    // Documents 경로를 구하는 방법이다.
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    return [documentsDirectory stringByAppendingPathComponent:MenuList];
// 
//}
//+ (BOOL)dataFileSave:(NSData*)SavaList{
//    return  [SavaList writeToFile:[self dataFilePath] atomically:YES];
//}
//
//+ (NSMutableArray *)dataFileArray{
//    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSData alloc]initWithContentsOfFile:[self dataFilePath]]];
//}
//+ (BOOL)dataFilePathDelect{
//    // Documents 경로에 파일 삭제
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *path;
//    path = [documentsDirectory stringByAppendingPathComponent:MenuList];
// 
//    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
//}
//
//+ (NSString *)mutablearryToString:(NSMutableArray*)mutablearray{
//    
//     NSData * myData = [NSKeyedArchiver archivedDataWithRootObject:mutablearray];
//    
//
//    return [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
//}
//
//+ (NSMutableArray *)stringToMutablearray:(NSString*)datastring{
//
//    NSData* aData = [datastring dataUsingEncoding: NSUTF8StringEncoding];
//    
//    return [NSKeyedUnarchiver unarchiveObjectWithData:aData];
//}

+ (NSString *)updateTimecode
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
	[dateFormatter setDateFormat:@"dd"];
	NSInteger day = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    
	[dateFormatter setDateFormat:@"HH"];
	NSInteger hour = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    
	[dateFormatter setDateFormat:@"mm"];
	NSInteger minute = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    
    dateFormatter = nil;
    //    [NSString stringWithFormat:@"%d", currentIndex];
    
	NSInteger currentIndex = ( ( day*1440 + hour*60 + minute ) / 5 ) % 23;
    NSString *tempstring = [NSString stringWithFormat:@"%ld", (long)currentIndex];
    NSString *outputString =  @"0000000000";
    outputString =  [outputString substringWithRange:NSMakeRange(0,outputString.length-tempstring.length)];
    outputString = [NSString stringWithFormat:@"%@%@",outputString, tempstring];
    
    return outputString;
}

static BOOL useMidInfo_ = NO;
+(void) setUseMidInfo:(BOOL)use {
    useMidInfo_ = use;
}

+(BOOL) useMidInfo {
    return useMidInfo_;
}

+(NSString*)appid {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+(NSString*)currentVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSComparisonResult) checkVersion:(NSString*)originVersion targetVersion:(NSString*)targetVersion {

    NSComparisonResult r;

    NSArray * ovs = [originVersion componentsSeparatedByString:@"."];
    NSArray * tvs = [targetVersion componentsSeparatedByString:@"."];

    NSUInteger index = 0;

    do {
        r = [[ovs objectAtIndex:index] integerValue] - [[tvs objectAtIndex:index] integerValue];
        if (r == 0) {
            index++;
        }
        else {
            break;
        }
    } while ([tvs count] > index);

    return r;
}

+ (BOOL)needUpdate:(NSString*)version {
    return ([self checkVersion:[Common currentVersion]
                 targetVersion:version] < 0);
}

+(NSString*)bundleIdentifier {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+(NSString*)replaceReservedWord:(NSString*)urlString tag:(NSString*)tagString value:(NSString*)value {
    NSString * newUrlString = urlString;

    NSString * newTagString1 = [NSString stringWithFormat:@"=%@", tagString];
    NSString * newTagString2 = [NSString stringWithFormat:@"{%@}", tagString];
    NSString * newTagString3 = [NSString stringWithFormat:@"[%@]", tagString];
    if ([newUrlString rangeOfString:newTagString1].location != NSNotFound) {
        newUrlString = [newUrlString stringByReplacingOccurrencesOfString:newTagString1 withString:[NSString stringWithFormat:@"=%@", value]];
    }
    else if ([newUrlString rangeOfString:newTagString2].location != NSNotFound) {
        NSString * convertValue = value;
        if ([tagString isEqualToString:@"memberId"])
        {
            convertValue = [value base64EncodedString];
        }
        if (convertValue == nil)
            convertValue = @"";
        
        newUrlString = [newUrlString stringByReplacingOccurrencesOfString:newTagString2 withString:convertValue];
    }
    else if ([newUrlString rangeOfString:newTagString3].location != NSNotFound) {
        NSString * convertValue = [AESHelper aes128EncryptString:value];
        if (convertValue == nil) convertValue = @"";
        newUrlString = [newUrlString stringByReplacingOccurrencesOfString:newTagString3 withString:convertValue];
    }
    return newUrlString;
}

+(BOOL)boolAppYN:(NSString*)schemesURL{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:schemesURL]];
}

+(BOOL) openURL:(NSString*)urlString {
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

+(NSString*)getUrlStringWithApplyMetaData:(NSString*)urlString {
    NSArray * gpsInfoArray;
    return [self getUrlStringWithApplyMetaData:urlString dic:nil gpsInfo:&gpsInfoArray];
};

+(NSString*)getUrlStringWithApplyMetaData:(NSString*)urlString dic:(NSDictionary*)dic {
    return [self getUrlStringWithApplyMetaData:urlString dic:dic gpsInfo:nil];
}


+(NSString*)getUrlStringWithApplyMetaData:(NSString*)urlString dic:(NSDictionary*)dic gpsInfo:(NSArray *__autoreleasing *)gpsInfoArray {

    *gpsInfoArray = nil;

    UserData * ud = [UserData sharedUserData];
    NSString * newUrlString = urlString;
    NSString * latiStr = @"0";
    NSString * longStr = @"0";

    if ([urlString rangeOfString:@"latitude"].location != NSNotFound || [urlString rangeOfString:@"gpsLati"].location != NSNotFound) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        NSObject * obj = [UIApplication sharedApplication].delegate;
        if ([obj respondsToSelector:@selector(showIndecator)]) {
            [obj performSelector:@selector(showIndecator)];
        }

        // Ryu Edit
        if ([DataManager getInstance].gpsEnable) {
            LocationHelper * h = [LocationHelper sharedLocationHelper];
            
            if ([h canGetLocationInformation]) {
                CLLocationCoordinate2D coor = [h getCoordinate];
                latiStr = [NSString stringWithFormat:@"%0.6lf", coor.latitude];
                longStr = [NSString stringWithFormat:@"%0.6lf", coor.longitude];
                (*gpsInfoArray) = @[[NSString stringWithFormat:@"%@",latiStr], [NSString stringWithFormat:@"%@",longStr]];
            }
            else {
                [h showAlertForAllowFindLocation];
            }
        }
        
        if ([obj respondsToSelector:@selector(hideIndecator)]) {
            [obj performSelector:@selector(hideIndecator)];
        }


#pragma clang diagnostic pop
    }
    for (NSString * key in [dic allKeys]) {
        NSString * value = [dic objectForKey:key];
        newUrlString = [self replaceReservedWord:newUrlString tag:key value:value];
    }
    NSMutableDictionary * defaultTagDic = [NSMutableDictionary dictionaryWithDictionary:@{@"memberId":ud.getServiceId,
                                                                                          @"userId":ud.USER_ID,
                                                                                          @"nfcValue":@"",
                                                                                          @"nfcSid":@"",
                                                                                          @"nfcTid":@"",
                                                                                          @"latitude":latiStr,
                                                                                          @"longitude":longStr,
                                                                                          @"gpsLati":latiStr,
                                                                                          @"gpsLong":longStr}];
    
    // Ryu Add
    NSLog(@" defaultTagDic: %@", defaultTagDic);
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알람" message:[NSString stringWithFormat:@"위치정보: %@",  defaultTagDic] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
//    [alert show];
    
    
    if (ud.GB_WORK != nil) {
        [defaultTagDic setObject:ud.GB_WORK forKey:@"gbWork"];
        [defaultTagDic setObject:ud.GB_WORK forKey:@"GB_WORK"];
    }
    for (NSString * key in [defaultTagDic allKeys]) {
        NSString * value = [defaultTagDic objectForKey:key];
        newUrlString = [self replaceReservedWord:newUrlString tag:key value:value];
    }
    return newUrlString;
}

@end
