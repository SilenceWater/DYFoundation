//
//  NSString+DYFoundation.m
//  DYFoundation
//
//  Created by 德一智慧城市 on 2019/7/1.
//

#import "NSString+DYFoundation.h"
#import <CommonCrypto/CommonDigest.h>
#import "DYDate.h"

static NSString *const kSpecialCharacter = @"^[A-Za-z0-9\\u4e00-\u9fa5]+$";

@implementation NSString (DYFoundation)

- (NSString *)md5String {
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}

- (BOOL)isStringType:(DYStringType)stringType {
    NSString *string = [self stringForId:self];
    switch (stringType) {
        case DYStringPhoneType:{
            NSString *phoneRegex = @"(\\+\\d+)?1[3456789]\\d{9}$";
            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
            return [phoneTest evaluateWithObject:string];
        }
            break;
        case DYStringEmailType:{
            NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
            return [emailTest evaluateWithObject:string];
        }
            break;
        case DYStringNumberType:{
            NSPredicate *specailPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",kSpecialCharacter];
            if ([specailPre evaluateWithObject:string]) {
                NSString *emailRegex = @"^[0-9]*$";
                NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
                return [emailTest evaluateWithObject:string];
            }else{
                return NO;
            }
        }
            break;
        case DYStringMinusculeType:{
            NSString *emailRegex = @"^[a-z]+$";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
            return [emailTest evaluateWithObject:string];
        }
            break;
        case DYStringMajusculeType:{
            NSString *emailRegex = @"^[A-Z]+$";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
            return [emailTest evaluateWithObject:string];
        }
            break;
        case DYStringIDCardType:{
            BOOL flag;
            if (string.length <= 0) {
                flag = NO;
                return flag;
            }
            NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
            NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
            return [identityCardPredicate evaluateWithObject:string];
        }
            break;
        case DYHasChineseStringType:{
            for(int i = 0; i < [string length]; i++){
                int a = [string characterAtIndex:i];
                if( a > 0x4e00 && a < 0x9fff)
                    return YES;
            }
            return NO;
        }
            break;
        case DYChineseStringType:{
            for(int i = 0; i < [string length]; i++){
                int a = [string characterAtIndex:i];
                if (a < 0x4e00 || a > 0x9fff) {
                    return NO;
                }
            }
            return YES;
        }
            break;
        case DYChineseAndLetterType:{
            NSString *regex = @"^[a-zA-Z\u4e00-\u9fa5]+$";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
            return [predicate evaluateWithObject:string];
        }
            break;
        case DYLetterAndNumberType:{
            NSString *regex = @"^[0-9a-zA-Z]+$";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
            return [predicate evaluateWithObject:string];
        }
            break;
        case DYChineseAndNumberType:{
            
            NSString *regex = @"[0-9\u4e00-\u9fa5➋-➒]*";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
            return [pred evaluateWithObject:string];
        }
            break;
        case DYChineseAndNumberAndLetterType:{
            
            NSString *regex = @"[a-zA-Z0-9\u4e00-\u9fa5➋-➒]*";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
            return [pred evaluateWithObject:string];
        }
            break;
            
        case DYLetterWithNumberType:
        {
            NSInteger leng = self.length;
            NSString *regex = [NSString stringWithFormat:@"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{0,%ld}$",(long)leng] ;
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
            return [pred evaluateWithObject:string];
        }
            break;
            
        case DYLetterAndNumberAndStrigulaType:
        {
            NSString *regex = [NSString stringWithFormat:@"^[0-9A-Za-z^-]+$"] ;
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
            return [pred evaluateWithObject:string];
        }
            break;
            
        case DYCarLicenseNumberType:
        {
            NSInteger leng = self.length;
            if ((leng != 6) && (leng != 7)) {
                return NO;
            }
            NSString *regex = [NSString stringWithFormat:@"^([A-Z]{1}[A-Z0-9]{%ld}[a-zA-Z0-9\u4e00-\u9fa5➋-➒]{1})", leng-2];
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
            return [pred evaluateWithObject:string];
        }
            break;
        default:
            return NO;
            break;
    }
}

- (NSString *)transformChineseNumberalsToArabicNumberals {
    
    if (self.length == 0) {
        return @"";
    }
    if ([self intValue] != 0) {
        return self;
    }
    
    NSString *arabic = self;
    NSDictionary *sepicalNumberDic = [self sepicalNumberDic];
    
    BOOL flag=YES;//yes表示正数，no表示负数
    NSString * s=[arabic substringWithRange:NSMakeRange(0, 1)];
    if([s isEqualToString:@"负"]){
        flag=NO;
    }
    
    int sum=0;//和
    NSArray *sepicalUnits = @[@"万万", @"萬萬", @"亿", @"万", @"萬"];
    for (NSString *unit in sepicalUnits) {
        if ([arabic containsString:unit]) {
            
            NSArray *subArabic = [arabic componentsSeparatedByString:unit];
            NSString *result = [[subArabic firstObject] transformChineseNumberalsToArabicNumberals];
            sum += ABS(result.intValue * [[sepicalNumberDic valueForKey:unit] intValue]);
            arabic = [subArabic lastObject];
            if (!flag) arabic = [NSString stringWithFormat:@"负%@",arabic];
        }
    }
    
    int i=0;
    if(!flag){
        i=1;
    }
    int num[20];//保存单个汉字信息数组
    for(int i=0;i<20;i++){//将其全部赋值为0
        num[i]=0;
    }
    int k=0;//用来记录数据的个数
    
    //如果是负数，正常的数据从第二个汉字开始，否则从第一个开始
    for(;i<[arabic length];i++){
        NSString * key=[arabic substringWithRange:NSMakeRange(i, 1)];
        int tmp=[[sepicalNumberDic valueForKey:key] intValue];
        num[k++]=tmp;
    }
    //将获得的所有数据进行拼装
    for(int i=0;i<k;i++){
        if(num[i+1]>=10 && num[i] != 0){
            sum+=num[i]*num[i+1];
            i++;
        }else{
            sum+=num[i];
        }
    }
    NSMutableString * result= nil;
    if(flag){//如果正数
        result=[NSMutableString stringWithFormat:@"%d",sum];
    }else{//如果负数
        result=[NSMutableString stringWithFormat:@"-%d",sum];
    }
    return result;
}

- (NSString *)stringForId:(id)object{
    NSString *str = (NSString *)object;
    
    if (str == nil) return @"";
    if (str == NULL) return @"";
    if ([str isKindOfClass:[NSNull class]]) return @"";
    
    str = [NSString stringWithFormat:@"%@",str];
    return str;
}

/**
 *  是否是整型数字类型的字符串
 *  @return YES？NO
 */
- (BOOL)isPureInt {
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}


//过滤指定字符串   里面的指定字符根据自己的需要添加 过滤特殊字符
- (NSString*)removeSpecialCharacter {
    NSRange urgentRange = [self rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @",.？、 ~￥#&<>《》()[]{}【】^@/￡¤|§¨「」『』￠￢￣~@#&*（）——+|《》$_€ "]];
    if (urgentRange.location != NSNotFound) {
        
        return [[self stringByReplacingCharactersInRange:urgentRange withString:@""] removeSpecialCharacter];
    }
    return self;
}

- (NSDictionary *)sepicalNumberDic {
    
    NSMutableDictionary * mdic =[[NSMutableDictionary alloc]init];
    
    [mdic setObject:[NSNumber numberWithInt:100000000] forKey:@"亿"];
    [mdic setObject:[NSNumber numberWithInt:2] forKey:@"两"];
    [mdic setObject:[NSNumber numberWithInt:0] forKey:@"零"];
    
    [mdic setObject:[NSNumber numberWithInt:100000000] forKey:@"万万"];
    [mdic setObject:[NSNumber numberWithInt:100000000] forKey:@"萬萬"];
    
    [mdic setObject:[NSNumber numberWithInt:10000] forKey:@"万"];
    [mdic setObject:[NSNumber numberWithInt:1000] forKey:@"千"];
    [mdic setObject:[NSNumber numberWithInt:100] forKey:@"百"];
    [mdic setObject:[NSNumber numberWithInt:10] forKey:@"十"];
    
    [mdic setObject:[NSNumber numberWithInt:9] forKey:@"九"];
    [mdic setObject:[NSNumber numberWithInt:8] forKey:@"八"];
    [mdic setObject:[NSNumber numberWithInt:7] forKey:@"七"];
    [mdic setObject:[NSNumber numberWithInt:6] forKey:@"六"];
    [mdic setObject:[NSNumber numberWithInt:5] forKey:@"五"];
    [mdic setObject:[NSNumber numberWithInt:4] forKey:@"四"];
    [mdic setObject:[NSNumber numberWithInt:3] forKey:@"三"];
    [mdic setObject:[NSNumber numberWithInt:2] forKey:@"二"];
    [mdic setObject:[NSNumber numberWithInt:1] forKey:@"一"];
    
    [mdic setObject:[NSNumber numberWithInt:10000] forKey:@"萬"];
    [mdic setObject:[NSNumber numberWithInt:1000] forKey:@"仟"];
    [mdic setObject:[NSNumber numberWithInt:100] forKey:@"佰"];
    [mdic setObject:[NSNumber numberWithInt:10] forKey:@"拾"];
    
    [mdic setObject:[NSNumber numberWithInt:9] forKey:@"玖"];
    [mdic setObject:[NSNumber numberWithInt:8] forKey:@"捌"];
    [mdic setObject:[NSNumber numberWithInt:7] forKey:@"柒"];
    [mdic setObject:[NSNumber numberWithInt:6] forKey:@"陆"];
    [mdic setObject:[NSNumber numberWithInt:5] forKey:@"伍"];
    [mdic setObject:[NSNumber numberWithInt:4] forKey:@"肆"];
    [mdic setObject:[NSNumber numberWithInt:3] forKey:@"叁"];
    [mdic setObject:[NSNumber numberWithInt:2] forKey:@"贰"];
    [mdic setObject:[NSNumber numberWithInt:1] forKey:@"壹"];
    
    return mdic;
}

- (UIImage *)generateQRCodeWithSize:(CGSize)size {
    
    
    NSData *codeData = [self dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:codeData forKey:@"inputMesDYge"];
    CIImage *outputImage = filter.outputImage;
    CGRect extent = CGRectIntegral(outputImage.extent);
    
    CGAffineTransform transform ;
    if (size.width != 0 ) {
        transform = CGAffineTransformMakeScale(size.width/CGRectGetWidth(extent) , size.height/CGRectGetHeight(extent));
    }else{
        transform = CGAffineTransformMakeScale(20 , 20);
    }
    
    
    CIImage *transformImage = [outputImage imageByApplyingTransform:transform];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:transformImage fromRect:transformImage.extent];
    
    return [UIImage imageWithCGImage:imageRef];
    
    
}


- (UIImage *)generateBarCodeWithSize:(CGSize)size{
    
    NSString *filtername = @"CICode128BarcodeGenerator";
    CIFilter *filter = [CIFilter filterWithName:filtername];
    [filter setDefaults];
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMesDYge"];
    [filter setValue:[NSNumber numberWithInteger:0] forKey:@"inputQuietSpace"];
    
    CIImage *outputImage = [filter outputImage];
    
    if (outputImage) {
        CGRect extent = CGRectIntegral(outputImage.extent);
        CGFloat scaleWidth = size.width/CGRectGetWidth(extent);
        CGFloat scaleHeight = size.height/CGRectGetHeight(extent);
        size_t width = CGRectGetWidth(extent) * scaleWidth;
        size_t height = CGRectGetHeight(extent) * scaleHeight;
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
        CGContextRef contentRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef imageRef = [context createCGImage:outputImage fromRect:extent];
        CGContextSetInterpolationQuality(contentRef, kCGInterpolationNone);
        CGContextScaleCTM(contentRef, scaleWidth, scaleHeight);
        CGContextDrawImage(contentRef, extent, imageRef);
        CGImageRef imageRefResized = CGBitmapContextCreateImage(contentRef);
        CGContextRelease(contentRef);
        CGImageRelease(imageRef);
        return [UIImage imageWithCGImage:imageRefResized];
    }else{
        return nil;
    }
}


- (NSInteger)bytesOfString {
    NSInteger strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++)
    {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
    
}

- (BOOL)isValidWithRegularExpressionString:(NSString *)regularExpressionString {
    if (!regularExpressionString) {
        return YES;
        NSAssert(self, @"要有正则表达式啊哥");
    }
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularExpressionString];
    return [predicate evaluateWithObject:self];
}


- (NSString *)dy_invoidJurisdictionDateString {
    NSDate * standardDate = [DYDate dateFromString:@"2100-01-01 00:00:00" withDateFormat:@"YYYY-MM-DD HH:mm:ss"];
    NSDate * date = [DYDate dateFromString:self withDateFormat:@"YYYY-MM-DD HH:mm:ss"];
    
    if(date.timeIntervalSinceNow >= standardDate.timeIntervalSinceNow){
        return @"不限时间";
    }
    NSDateFormatter *dateFormatter = [DYDate sharedDateFormatter];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"YYYY-MM-DD HH:mm"];
    return [dateFormatter stringFromDate:date];
}

@end

@implementation NSDictionary (Log)
- (NSString *)description {
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            [strM appendFormat:@"\t\"%@\" : %@,\n", key, obj];
        }else if([obj isKindOfClass:[NSDictionary class]]){
            [strM appendFormat:@"\t\"%@\" : %@,\n", key, obj];
        }else{
            [strM appendFormat:@"\t\"%@\" : \"%@\",\n", key, obj];
        }
    }];
    
    // 查找最后一个逗号
    NSRange range = [strM rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound)
        [strM deleteCharactersInRange:range];
    [strM appendString:@"}\n"];
    
    return strM;
}

- (NSString *)descriptionWithLocale:(id)locale {
    
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            [strM appendFormat:@"\t\"%@\" : %@,\n", key, obj];
        }else if([obj isKindOfClass:[NSDictionary class]]){
            [strM appendFormat:@"\t\"%@\" : %@,\n", key, obj];
        }else{
            [strM appendFormat:@"\t\"%@\" : \"%@\",\n", key, obj];
        }
    }];
    
    // 查找最后一个逗号
    NSRange range = [strM rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound)
        [strM deleteCharactersInRange:range];
    [strM appendString:@"}\n"];
    
    return strM;
}



@end

@implementation NSArray (Log)

- (NSString *)description {
    NSMutableString *strM = [NSMutableString stringWithString:@"[\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    
    // 查找最后一个逗号
    NSRange range = [strM rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound)
        [strM deleteCharactersInRange:range];
    [strM appendString:@"]"];
    
    return strM;
}

- (NSString *)descriptionWithLocale:(id)locale {
    
    NSMutableString *strM = [NSMutableString stringWithString:@"[\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    
    // 查找最后一个逗号
    NSRange range = [strM rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound)
        [strM deleteCharactersInRange:range];
    [strM appendString:@"]"];
    
    return strM;
}


@end
