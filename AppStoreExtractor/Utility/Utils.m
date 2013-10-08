#import "Utils.h"

#define kChosenCipherBlockSize  kCCBlockSizeAES128
#define kChosenCipherKeySize    kCCKeySizeAES128
#define kChosenDigestLength     CC_SHA1_DIGEST_LENGTH


@implementation Utils

//format of dateString will be "yyyy-MM-dd HH:mm:ss XXX" wehre XXX is timezone for eg: UTC

+(NSDate *) convertStringToDate:(NSString *)dateString
{
	//0-18  : dateFormat
	//20-22 : timeZone
	
	NSString *dateStringPart= [dateString substringToIndex:18];
	NSDateFormatter* df = [[NSDateFormatter alloc] init];
	[df setDateFormat:kDateResponseFormat];
	NSDate *date =[df dateFromString:dateStringPart];
	[df release];
	return date;
}

+(NSString *) getDayFromDate:(NSDate *)date{
	
	NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];

	return [NSString stringWithFormat:@"%d",[components day]];
}

+(NSString *) getMonthNameFromDate:(NSDate *)date{
	
	NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
	
	NSInteger month = [components month];
	
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	
	NSString *monthName = [[df monthSymbols] objectAtIndex:(month-1)];
	
	[df release];
	
	return monthName;
	
	
}

+(NSString *) getYearFromDate:(NSDate *)date{
	
	NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
	
	NSInteger year = [components year];
	
	NSString *yearString = [NSString stringWithFormat:@"%d",year ];
	
	return yearString;
}

+ (void)showAlertMessage:(NSString *)message
{
	UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"CrowdFail" 
													   message:message
													  delegate:nil
											 cancelButtonTitle:@"Ok"
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}


+(BOOL) checkEmailFormat:(NSString *)email{
	if ([email rangeOfString:@"@"].length == 0 ){
		return NO;
	}
	else{
		NSArray* splitArray = [email componentsSeparatedByString:@"@"];
		if ([[splitArray objectAtIndex:splitArray.count-1] rangeOfString:@"."].location +1 
			>=
			[[splitArray objectAtIndex:splitArray.count-1] length]){
			
			return NO;
		}
	}
	
	return YES;
}


+(BOOL) isDeviceOS5;
{
    NSString *reqSysVer = @"5.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    return ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
}

+ (NSData *)doCipher:(NSData *)plainText key:(NSData *)symmetricKey iv:(NSData *)initVector context:(CCOperation)encryptOrDecrypt padding:(CCOptions *)pkcs7 {
    
    // Symmetric crypto reference.
    CCCryptorRef thisEncipher = NULL;
    // Cipher Text container.
    NSData * cipherOrPlainText = nil;
    // Pointer to output buffer.
    uint8_t * bufferPtr = NULL;
    // Total size of the buffer.
    size_t bufferPtrSize = 0;
    // Remaining bytes to be performed on.
    size_t remainingBytes = 0;
    // Number of bytes moved to buffer.
    size_t movedBytes = 0;
    // Length of plainText buffer.
    size_t plainTextBufferSize = 0;
    // Placeholder for total written.
    size_t totalBytesWritten = 0;
    // A friendly helper pointer.
    uint8_t * ptr;

    NSUInteger len = [initVector length];
    
    // Initialization vector; dummy in this case 0's.
    uint8_t iv[len];
    //memset((void *) iv, 0x0, (size_t) sizeof(iv));
	memcpy(iv, [initVector bytes], len);
  
    
    plainTextBufferSize = [plainText length];
	// We don't want to toss padding on if we don't need to
    if (encryptOrDecrypt == kCCEncrypt) {
        if (*pkcs7 != kCCOptionECBMode) {
            if ((plainTextBufferSize % kChosenCipherBlockSize) == 0) {
                *pkcs7 = 0x0000;
            } else {
                *pkcs7 = kCCOptionPKCS7Padding;
            }
        }
    } else if (encryptOrDecrypt != kCCDecrypt) {
		
    } 
    
    // Create and Initialize the crypto reference.
                CCCryptorCreate( encryptOrDecrypt, 
							   kCCAlgorithmAES128, 
							   *pkcs7, 
							   (const void *)[symmetricKey bytes], 
							   kChosenCipherKeySize, 
							   (const void *)iv, 
							   &thisEncipher
							   );
    
	// Calculate byte block alignment for all calls through to and including final.
    bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);
    
    // Allocate buffer.
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t) );
    
    // Zero out buffer.
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    // Initialize some necessary book keeping.
    
    ptr = bufferPtr;
    
    // Set up initial size.
    remainingBytes = bufferPtrSize;
    
    // Actually perform the encryption or decryption.
              CCCryptorUpdate( thisEncipher,
							   (const void *) [plainText bytes],
							   plainTextBufferSize,
							   ptr,
							   remainingBytes,
							   &movedBytes
							   );
    
    // Handle book keeping.
    ptr += movedBytes;
    remainingBytes -= movedBytes;
    totalBytesWritten += movedBytes;
    
    // Finalize everything to the output buffer.
            CCCryptorFinal(  thisEncipher,
							  ptr,
							  remainingBytes,
							  &movedBytes
							  );
    
    totalBytesWritten += movedBytes;
    
    if (thisEncipher) {
        (void) CCCryptorRelease(thisEncipher);
        thisEncipher = NULL;
    }
    
    
    cipherOrPlainText = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];
	
    if (bufferPtr) free(bufferPtr);
    
    return cipherOrPlainText;
    
    /*
     Or the corresponding one-shot call:
     
     ccStatus = CCCrypt(    encryptOrDecrypt,
	 kCCAlgorithmAES128,
	 typeOfSymmetricOpts,
	 (const void *)[self getSymmetricKeyBytes],
	 kChosenCipherKeySize,
	 iv,
	 (const void *) [plainText bytes],
	 plainTextBufferSize,
	 (void *)bufferPtr,
	 bufferPtrSize,
	 &movedBytes
	 );
     */
}

+(NSData *) dataFromHexString:(NSString *)command{
	
	NSMutableData *commandToSend= [[NSMutableData alloc] init];
	unsigned char whole_byte;
	char byte_chars[3] = {'\0','\0','\0'};
	int len=[command length]/2;
	int i;
	for (i=0; i < len; i++) {
		byte_chars[0] = [command characterAtIndex:i*2];
		byte_chars[1] = [command characterAtIndex:i*2+1];
		whole_byte = strtol(byte_chars, NULL, 16);
		[commandToSend appendBytes:&whole_byte length:1]; 
	}
	return [commandToSend autorelease];
}

+ (void)registerForAPNS
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}

+ (BOOL)checkValidityOnURL:(NSString *)urlString ForScheme:(BOOL)checkScheme Host:(BOOL)checkHost Path:(BOOL)checkPath{
    
    BOOL isValid=YES;
    NSURL *url=[NSURL URLWithString:urlString];
    
    if(url)
    {  
        if (checkScheme && ![url scheme])
        {
            isValid=NO;
            return isValid;
        }
        if (checkHost && ![url host])
        {
            isValid=NO;
            return isValid;
        }
        if (checkPath && ![url path])
        {
            isValid=NO;
            return isValid;
        }
        return isValid;
      }
    else
        return NO;
}

+ (NSString *)escapedString:(NSString*)stringToEscape
{    
    CFStringRef escapedStringRef = CFURLCreateStringByAddingPercentEscapes(
                                                                           NULL,
                                                                           (CFStringRef)stringToEscape,
                                                                           NULL,
                                                                           (CFStringRef)@" !*'();:@=+$,/?%#[]&",
                                                                           kCFStringEncodingUTF8 );
    
    NSString *result = [[NSString alloc] initWithFormat:@"%@",(NSString *)escapedStringRef];
    if(escapedStringRef)
    CFRelease(escapedStringRef);
    return [result autorelease];
}

+ (NSString *)trimmedAndEscapedString:(NSString*)stringToEscape
{
    NSString *trimmedString = [stringToEscape stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    CFStringRef escapedStringRef = CFURLCreateStringByAddingPercentEscapes(
                                                                           NULL,
                                                                           (CFStringRef)trimmedString,
                                                                           NULL,
                                                                           (CFStringRef)@" !*'();:@=+$,/?%#[]&",
                                                                           kCFStringEncodingUTF8 );
    
    NSString *result = [[NSString alloc] initWithFormat:@"%@",(NSString *)escapedStringRef];
    if(escapedStringRef)
    CFRelease(escapedStringRef);
    return [result autorelease];
}

+ (UIImage *)imageNamed:(NSString*)name
{
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", bundlePath,name]];
}

+ (NSString *)stripTags:(NSString *)str

{
    NSMutableString *html = [NSMutableString stringWithCapacity:[str length]];
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner setCharactersToBeSkipped:[NSCharacterSet newlineCharacterSet]];
    NSString *tempText = nil;
    
    while(![scanner isAtEnd])
    {
        [scanner scanUpToString:@"<" intoString:&tempText];
        if(tempText != nil)
        [html appendString:tempText];

        [scanner scanUpToString:@">" intoString:NULL];
        
        if(![scanner isAtEnd])
        [scanner setScanLocation:[scanner scanLocation] + 1];
        
        tempText = nil;
    }
    
    return html;
}

+ (NSString *)hashFromString:(NSString*)str
{
	const char *cStr = [str UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
			];
}

+ (UIImage *)getLastUploadedImageFromDisk
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *tmpFilePath = [basePath stringByAppendingPathComponent:@"LargeUploadingImage.jpeg"];
    UIImage *image  = [UIImage imageWithContentsOfFile:tmpFilePath];
    return image;
}

// return date in "** days/hrs/mins/secs ago" format
+ (NSString *)getFormattedTimeInterval:(NSString*)date
{
    NSString* notificationTime = @"";
    NSInteger dateLength = [date length];
    NSString* notificationDate = [date substringToIndex:dateLength - 4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *deviceUTCDateString = [dateFormatter stringFromDate:[NSDate date]];
    NSTimeInterval interval = [[dateFormatter dateFromString:deviceUTCDateString] timeIntervalSinceDate:[dateFormatter dateFromString:notificationDate]];
    [dateFormatter release];
    NSInteger timeInterval;
    
    if (interval/(24 * 60 * 60) >= 1) 
    {
        timeInterval = interval/(24 * 60 * 60);
        
        if(timeInterval > 30)
        {
            timeInterval = timeInterval/30;
            notificationTime = [NSString stringWithFormat:@"%d month%@ ago", timeInterval, timeInterval!=1?@"s":@""];
        }
        else
        {
            notificationTime = [NSString stringWithFormat:@"%d day%@ ago", timeInterval, timeInterval!=1?@"s":@""];
        }
    }
    else if(interval/(60 * 60) >= 1)
    {
        timeInterval = interval/(60 * 60);
        notificationTime = [NSString stringWithFormat:@"%d hr%@ ago", timeInterval, timeInterval!=1?@"s":@""];
    }
    else if(interval/60 >= 1)
    {
        timeInterval = interval/(60);
        notificationTime = [NSString stringWithFormat:@"%d min%@ ago", timeInterval, timeInterval!=1?@"s":@""];
    }
    else
    {
        notificationTime = @"few seconds ago";
    }
    
    return notificationTime;
}

+ (void)writeAppVersionInfo:(CGFloat)number
{
    NSLog(@"Utils : writeAppVersionInfo");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSString stringWithFormat:@"%f", number] forKey:@"Version"];
    [defaults synchronize];
}

+ (void)removeOldCacheContent
{
    // iOS Data Storage Guidelines - Remove downloadable/recreatable contents from Documents Directory
    // This block will remove all cached items from documents directory (created from previous builds - 1.0, 1.2 & 1.2)
    
    NSFileManager *fileManager;
    NSArray *dirPaths = nil;
    NSString *docsDir = nil;
    NSString *cachesDir = nil;
    BOOL isDir;
    fileManager =[NSFileManager defaultManager];    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                   NSUserDomainMask, YES);    
    if(dirPaths)
    docsDir = [dirPaths objectAtIndex:0];
    
    if(docsDir)
    cachesDir = [docsDir stringByAppendingPathComponent:@"CrowdFail"];
    
    if([fileManager fileExistsAtPath:cachesDir isDirectory:&isDir] && isDir)
    {
        if([fileManager removeItemAtPath:cachesDir error: nil] == NO)
        {
            // Directory removal failed. - don't do anything
        }
    }
}

+ (NSString *)generateRandomStr
{
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:20];
    
    for (NSUInteger i = 0U; i < 20; i++) 
    {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    
    return s;
}

#pragma mark -
#pragma mark action sheet & delegate functions

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size
{
    NSLog(@"Utils : scaleImageToSize");
    
    //Scaling selected image to targeted size
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), image.CGImage);

    switch (image.imageOrientation)
    {
        case UIImageOrientationUp:            // default orientation
        {
            NSLog(@"UIImageOrientationUp");
            CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), image.CGImage);
            break;
        }
        case UIImageOrientationDown:          // 180 deg rotation
        {
            NSLog(@"UIImageOrientationDown");
            CGContextRotateCTM(context, -M_PI);
            CGContextTranslateCTM(context, -size.width, -size.height);
            CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), image.CGImage);
            break;
        }
        case UIImageOrientationLeft:          // 90 deg CCW
        {
            NSLog(@"UIImageOrientationLeft");
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0.0f, -size.width);
            CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), image.CGImage);
            break;
        }
        case UIImageOrientationRight:         // 90 deg CW
        {
            NSLog(@"UIImageOrientationRight");
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -size.height, 0.0f);
            CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), image.CGImage);
            break;
        }
        case UIImageOrientationUpMirrored:    // as above but image mirrored along other axis. horizontal flip
        {
            NSLog(@"UIImageOrientationUpMirrored");
            CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), image.CGImage);
            break;
        }
        case UIImageOrientationDownMirrored:  // horizontal flip
        {
            NSLog(@"UIImageOrientationDownMirrored");
            CGContextRotateCTM(context, -M_PI);
            CGContextTranslateCTM(context, -size.width, -size.height);
            CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), image.CGImage);
            break;
        }
        case UIImageOrientationLeftMirrored:  // vertical flip
        {
            NSLog(@"UIImageOrientationLeftMirrored");
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0.0f, -size.width);
            CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), image.CGImage);
            break;
        }
        case UIImageOrientationRightMirrored: // vertical flip
        {
            NSLog(@"UIImageOrientationRightMirrored");
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -size.height, 0.0f);
            CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), image.CGImage);
            break;
        }
        default:
        {
            // unknown Orientation
            break;
        }
    }
    
    CGImageRef scaledImage=CGBitmapContextCreateImage(context);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    UIImage *newImage = [UIImage imageWithCGImage: scaledImage];    
    CGImageRelease(scaledImage);
    
    return newImage;
}

+ (UIImage *)scaleImage:(UIImage *)image proportionalToSize:(CGSize)size1
{
    NSLog(@"Utils : scaleImageProportionalToSize");
    
    CGSize size =image.size;
    
    if(size.width>size.height)
    {
        NSLog(@"Captured Image is LandScape Oriented");
        size1=CGSizeMake((size.width/size.height)*size1.height,size1.height);
    }
    else
    {
        NSLog(@"Captured Image is Potrait Oriented");
        size1=CGSizeMake(size1.width,(size.height/size.width)*size1.width);
    }
    
    return [Utils scaleImage:image toSize:size1];
}

+ (UIImage*)scaleAndCropImage:(UIImage *)image targetSize:(CGSize)size
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;        
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, size) == NO) 
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) 
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        }
        else 
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }       
    
    UIGraphicsBeginImageContext(size); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) 
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


@end
