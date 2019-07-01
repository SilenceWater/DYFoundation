//
//  NSString+DYFoundation.h
//  DYFoundation
//
//  Created by 德一智慧城市 on 2019/7/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DYFoundation)

/**
 校验类型

 - DYStringPhoneType: 手机号
 - DYStringEmailType: 邮箱
 - DYStringNumberType: 全数字
 - DYStringMinusculeType: 全小写字母
 - DYStringMajusculeType: 全大写字母
 - DYStringIDCardType: 身份证
 - DYHasChineseStringType: 含有中文字符
 - DYChineseStringType: 全中文字符
 - DYChineseAndLetterType: 只能是汉字和字母
 - DYLetterAndNumberType: 只能是数字和字母
 - DYChineseAndNumberType: 只能是数字和汉字
 - DYChineseAndNumberAndLetterType: 只能是数字、汉字和字母
 - DYLetterWithNumberType: 只能是数字和字母并存
 - DYLetterAndNumberAndStrigulaType: 可包含：字母、数字和短横线
 - DYCarLicenseNumberType: 车牌号
 */
typedef NS_ENUM(NSInteger , DYStringType) {
    DYStringPhoneType = 0,
    DYStringEmailType,
    DYStringNumberType,
    DYStringMinusculeType,
    DYStringMajusculeType,
    DYStringIDCardType,
    DYHasChineseStringType,
    DYChineseStringType,
    DYChineseAndLetterType,
    DYLetterAndNumberType,
    DYChineseAndNumberType,
    DYChineseAndNumberAndLetterType,
    DYLetterWithNumberType,
    DYLetterAndNumberAndStrigulaType,
    DYCarLicenseNumberType
};

/*! md5加密 */
- (NSString *)md5String;

/**
 正则校验

 @param stringType 需要校验的类型
 @return YES？NO
 */
- (BOOL)isStringType:(DYStringType)stringType;


/*! 过滤指定字符串   里面的指定字符根据自己的需要添加 过滤特殊字符 */
- (NSString*)removeSpecialCharacter;

/*! 将汉字数字转换成阿拉伯数字（注，不超过10位数） */
- (NSString *)transformChineseNumberalsToArabicNumberals;

/**
 字符生成二维码
 
 @param size 生成二维码大小
 @return 二维码图片
 */
- (UIImage *)generateQRCodeWithSize:(CGSize)size;


/**
 字符生成条形码
 
 @param size 生成条形码的size
 @return 条形码图片
 */
- (UIImage *)generateBarCodeWithSize:(CGSize)size;


/**
 获取stringbytes长度
 
 @return string字节长度
 */
- (NSInteger)bytesOfString;

/**
 是否通过正则校验
 
 @param regularExpressionString 正则表达式
 @return 是否通过正则校验
 */
- (BOOL)isValidWithRegularExpressionString:(NSString *)regularExpressionString;


/**
 权限时间校验是否可用
 @warning 校验的基准时间是 2100-01-01 00:00:00
 @return 校验后结果，如果合法就返回校验的时间，如果非法则返回“不限时间”
 */
- (NSString *)dy_invoidJurisdictionDateString;


@end

NS_ASSUME_NONNULL_END
