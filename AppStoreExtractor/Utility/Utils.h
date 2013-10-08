#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "NSData+Base64.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#ifdef __IPHONE_5_0

#import <Twitter/TWTweetComposeViewController.h>
#import <Accounts/Accounts.h>
#import <Twitter/TWRequest.h>

#endif

#define kDateResponseFormat				@"yyyy-MM-dd HH:mm:ss"


@interface Utils : NSObject {
	
	
}

+(NSDate *) convertStringToDate:(NSString *)dateString; 

+(NSString *) getDayFromDate:(NSDate *)date;
    
+(NSString *) getMonthNameFromDate:(NSDate *)date;

+(NSString *) getYearFromDate:(NSDate *)date;


+(void) showAlertMessage:(NSString *)message;






//+(NSString *) googleMapImageURLForLocation:(CLLocationCoordinate2D) failPhotoCoordinate;
+(BOOL) checkEmailFormat:(NSString *)email;

// returns FALSE - for iOS < 5.0
+(BOOL) isDeviceOS5;


+ (NSData *)doCipher:(NSData *)plainText key:(NSData *)symmetricKey 
				  iv:(NSData *)initVector context:(CCOperation)encryptOrDecrypt padding:(CCOptions *)pkcs7;

+(NSData *) dataFromHexString:(NSString *)command;


+(void) registerForAPNS;

+(BOOL) checkValidityOnURL:(NSString *)urlString ForScheme:(BOOL)checkScheme Host:(BOOL)checkHost Path:(BOOL)checkPath;

+(NSString*)escapedString:(NSString*)stringToEscape;

+(NSString*)trimmedAndEscapedString:(NSString*)stringToEscape;

+(UIImage*) imageNamed : (NSString*) name;

+(NSString *) stripTags:(NSString *)str;


+(NSString*)getFormattedTimeInterval:(NSString*)date;

+(NSString*)hashFromString:(NSString*)str;

+(UIImage *)getLastUploadedImageFromDisk;

+(void) writeAppVersionInfo:(CGFloat)number;

+(void) removeOldCacheContent;

+(NSString *) generateRandomStr;



+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;

+ (UIImage *)scaleImage:(UIImage *)image proportionalToSize:(CGSize)size1;

+ (UIImage*)scaleAndCropImage:(UIImage *)image targetSize:(CGSize)size;

@end
