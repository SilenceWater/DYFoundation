//
//  DYDate.h
//  DYFoundation
//
//  Created by 德一智慧城市 on 2019/7/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYDate : NSObject

/**
 *  @brief 获取单例的NSDateFormatter实例，降低程序的开销
 *
 *  @return NSDateFormatter实例
 */
+ (NSDateFormatter *)sharedDateFormatter;

/**
 *  @brief 将String类型的date，按照指定的format，转换成Date类型
 *
 *  @param dateString   String类型的date
 *  @param formatString 指定的format
 *
 *  @return NSDate实例
 */
+ (NSDate *)dateFromString:(NSString *)dateString withDateFormat:(NSString *)formatString;

/**
 *  @brief 将Date按照指定的format，转换成响应的String
 *
 *  @param date         需要转换的Date实例
 *  @param formatString 指定的format
 *
 *  @return 转换得到的String
 */
+ (NSString *)stringFromDate:(NSDate *)date withDateFormat:(NSString *)formatString;

/**
 *
 *  @brief 将时间戳（timeInterval）按照指定的format，转换成相应的String
 *
 *  @param timeInterval 时间戳
 *  @param formatString 时间显示样式 （eg: yyyy-MM-dd HH:mm:ss）
 *
 *  @return 时间字符串
 */
+ (NSString *)stringFromTimestamp:(NSTimeInterval)timeInterval withDateFormat:(NSString *)formatString;

/**
 *  @brief 将Date类型转换为DateComponents类型，以获取年、月、日、时、分、秒的数据
 *
 *  @param date 需要转化的Date实体
 *
 *  @return 转化后的DateComponents实体
 */
+ (NSDateComponents *)componentFromDate:(NSDate *)date;

/**
 *  @brief 将DateComponents转化为Date类型
 *
 *  @param comps DateComponents类型的实体
 *
 *  @return 转化后得到的Date类型实体
 */
+ (NSDate *)dateFromComponents:(NSDateComponents *)comps;

/**
 *  @brief 将给出的字符串按照指定的format转换成时间戳并比较当前时间给出时间差
 *
 *  @param dateString         需要转换的DateString
 *  @param formatString 指定的format ，如果不给默认是 yyyy-MM-dd HH:mm:ss
 *
 *  @return 比较得到的String
 */
+ (NSString *)compareCurrentTime:(NSString *)dateString withDateFormat:(NSString *)formatString;

/**获取当前时区的date  转字符串不要用这date*/
+ (NSDate *)getCurrentDate DEPRECATED_MSG_ATTRIBUTE("use [NSDate date] instead");



/**
 *  @brief 将String类型的date，按照指定的format，转换成Date类型
 *
 *  @param dateString   String类型的date
 *  @param formatString 指定的format
 *
 *  @return NSDate实例
 */
+ (NSDate *)sa_dateFromString:(NSString *)dateString dateFormat:(NSString *)formatString;

/**
 *  @brief 将Date按照指定的format，转换成响应的String
 *
 *  @param date         需要转换的Date实例
 *  @param formatString 指定的format
 *
 *  @return 转换得到的String
 */
+ (NSString *)sa_stringFromDate:(NSDate *)date dateFormat:(NSString *)formatString;

/**
 *
 *  @brief 将时间戳（timeInterval）按照指定的format，转换成相应的String
 *
 *  @param timeInterval 时间戳
 *  @param formatString 时间显示样式 （eg: yyyy-MM-dd HH:mm:ss）
 *
 *  @return 时间字符串
 */
+ (NSString *)sa_stringFromTimestamp:(NSTimeInterval)timeInterval dateFormat:(NSString *)formatString;

/**
 *  @brief 将Date类型转换为DateComponents类型，以获取年、月、日、时、分、秒的数据
 *
 *  @param date 需要转化的Date实体
 *
 *  @return 转化后的DateComponents实体
 */
+ (NSDateComponents *)sa_componentFromDate:(NSDate *)date;

/**
 *  @brief 将DateComponents转化为Date类型
 *
 *  @param comps DateComponents类型的实体
 *
 *  @return 转化后得到的Date类型实体
 */
+ (NSDate *)sa_dateFromComponents:(NSDateComponents *)comps;

/**
 *  @brief 将给出的字符串按照指定的format转换成时间戳并比较当前时间给出时间差
 *
 *  @param dateString         需要转换的DateString
 *  @param formatString 指定的format ，如果不给默认是 yyyy-MM-dd HH:mm:ss
 *
 *  @return 比较得到的String
 */
+ (NSString *)sa_compareCurrentTime:(NSString *)dateString dateFormat:(NSString *)formatString;

@end

@interface NSDateComponents (DYExtend)

/**当前时间所在周的周一Date*/
@property (nonatomic , strong) NSDate * curWeekMondayDate;

/**当前时间所在周的周日Date*/
@property (nonatomic , strong) NSDate * curWeekSundayDate;

@end


NS_ASSUME_NONNULL_END
