//
//  DFTools.h
//  DFUnits
//
//  Created by DFung on 16/1/22.
//  Copyright © 2016年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DFTools : NSObject

+(NSMutableData*)HexToData:(NSString*)hex;

+(NSString*)dataToHex:(NSData*)data;

/**
 *  Alignment data in length you like.
 *	将data按照指定的长度补齐
 */
+(NSData*)alignment:(NSData*)data length:(NSInteger)len;

/**
 *  NSData ==> NSDictory.
 *	将 Json 字节码转换成 NSDictory。
 */
+(id)jsonWithData:(NSData*)data;

/**
 *  NSDictory ==> NSString.
 */
+(NSString*)dictionaryToJson:(NSDictionary *)dic;

/**
 *  NSDictory ==> NSData.
 */
+(NSData*)makeDataByDictionary:(NSDictionary *)dic;

/**
 *  NSData ==> NSDictory.
 */
+(NSDictionary*)makeDictionaryByData:(NSData *)data;

/**
 *  NSArray ==> NSString.
 */
+(NSString*)arrayToJson:(NSArray *)array;

/**
 *	将 uint32_t 的4个字节转换成 NSData。
 */
+(NSData*)uInt32_data:(uint32_t)value;

/**
 *	将 uint32_t 的4个字节转换成 NSData。
 *	@param endian   是否改变大小端
 */
+(NSData*)uInt32_data:(uint32_t)value Endian:(BOOL)endian;

/**
 *	将 uint16_t 的2个字节转换成 NSData。
 */
+(NSData*)uInt16_data:(uint16_t)value;


+(NSData*)uInt16_data:(uint16_t)value Endian:(BOOL)endian;

+(NSData*)uInt8_data:(uint8_t)value;


+(NSData*)changeBigOrSmall:(NSData*)data;


+(NSInteger)dataToInt:(NSData*)data;

/**
 *  求自然数：aByte ==> -1 0 1 2 3...
 */
+(int)getNaturalNumber:(NSData*)aByte;

/**
 *  简写： [data subdataWithRange:NSMakeRange(index, length)];
 */
+(NSData*)data:(NSData*)data R:(NSInteger)index L:(NSInteger)length;

/**
 *  简写： [[NSString alloc] initWithData:data encoding:encoding];
 */
+(NSString*)string:(NSData*)data Encode:(NSStringEncoding)encoding;

/**
 *  简写： [NSString stringWithFormat:(NSString *)format, ...];
 */
+(NSString*)string:(NSArray*)array;


/**
 *  UNICODE 编码字符串
 */
+(NSString*)stringUnicode:(NSData*)data;

/**
 *  ANSI 编码字符串
 */
+(NSString*)stringANSI:(NSData*)data;

/**
 *  GBK 编码字符串
 */
+(NSString*)stringGBK:(NSData*)data;

/**
 *  存入 NSUserDefaults
 */
+(void)setUser:(id)objc forKey:(NSString*)key;

/**
 *  取出 NSUserDefaults
 */
+(id)getUserByKey:(NSString*)key;

/**
 *  移除 NSUserDefaults
 */
+(void)removeUserByKey:(NSString*)key;

@end
