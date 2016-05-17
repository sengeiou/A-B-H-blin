//
//  SmaBusinessTool.h
//  SmaWatch
//
//  Created by 有限公司 深圳市 on 15/4/1.
//  Copyright (c) 2015年 smawatch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmaBusinessTool : NSObject
+(void)getSpliceCmd:(Byte)cmd Key:(Byte)key bytes1:(Byte [])bytes1 len:(int)len results:(Byte [])results;
+(void)getSpliceCmd1:(Byte)cmd Key:(Byte)key bytes1:(Byte [])bytes1 len:(int)len results:(Byte [])results;
+(void)copyValue:(Byte[])bytes len:(Byte)len dataBytes:(Byte[])dataBytes len1:(int)len1;
+(void)getSpliceCmdBand:(Byte)cmd Key:(Byte)key bytes1:(Byte [])bytes1 len:(int)len results:(Byte [])results;
/**
 *  <#Description#> CRC16校验方法
 *
 *  @param arrByte 传入需要CRC校验的byte数组
 *
 *  @return 返回CRC校验的结果true false;
 */
+(BOOL)checkCRC16:(Byte [])arrByte;
/**
 *  <#Description#> CRC16校验方法
 *
 *  @param arrByte 传入需要CRC校验的byte数组
 *
 *  @return 返回CRC校验的结果
 */
+(void)getCRC16:(Byte [])arrByte;

/**
 *  <#Description#> 是不是应答信号
 *
 *  @param bytes 蓝牙设备返回的结果bytes数组
 *
 *  @return 返回判断结果
 */
+(BOOL)checkNckBytes:(Byte [])bytes;
+(void)setAckCmdSeqId:(int16_t)seqId peripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic;
+(void)setNackCmdSeqId:(int16_t)seqId peripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic;
@end
