//
//  ACACL.h
//  AbleCloudLib
//
//  Created by 乞萌 on 15/8/31.
//  Copyright (c) 2015年 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACObject.h"
@interface ACACL : NSObject

typedef enum :NSInteger{
    READ,
    WRITE,
}OpType ;


@property (unsafe_unretained,nonatomic)BOOL isPublicReadAllow;
@property (unsafe_unretained,nonatomic)BOOL isPublicWriteAllow;
@property (retain,nonatomic) ACObject * userAccessObj;
@property (retain,nonatomic) ACObject * userDenyObj;
/**
 * 设置全局可读访问权限，不设置则默认为所有人可读
 *
 * @param allow 是否全局可读
 */
-(void)setPublicReadAccess:(BOOL)allow;
/**
 * 设置全局可写访问权限，不设置则默认为除自己外的所有人不可写
 *
 * @param allow 是否全局可写
 */
-(void)setPublicWriteAccess:(BOOL)allow;
/**
 * 设置用户可访问权限（白名单）
 *
 * @param opType 权限类型，OpType.READ为可读权限，OpType.WRITE为可写权限
 * @param userId 被设置用户Id
 */
-(void)setUserAccess:(OpType)optype userId:(long)userId;
/**暂不使用
 * 取消设置用户可访问权限（白名单），恢复默认权限
 *
 * @param opType 权限类型，OpType.READ为可读权限，OpType.WRITE为可写权限
 * @param userId 被设置用户Id
 */
-(void)unsetUserAccess:(OpType)optype userId:(long)userId;
/**
 * 设置用户访问权限（黑名单）
 *
 * @param opType 权限类型，OpType.READ为可读权限，OpType.WRITE为可写权限
 * @param userId 被设置用户Id
 */
-(void)setUserDeny:(OpType)optype userId:(long)userId;
/**暂不使用
 * 取消设置用户访问权限（黑名单），恢复默认权限
 *
 * @param opType 权限类型，OpType.READ为可读权限，OpType.WRITE为可写权限
 * @param userId 被设置用户Id
 */
-(void)unsetUserDeny:(OpType)optype userId:(long)userId;
//辅助函数
-(ACObject*)toACObject;
-(NSString *)getUserKey:(long)user;
-(ACObject *)getAuthObjectByKey:(ACObject * )accessObj  key:(NSString *)key create:(BOOL)create;
-(void)setUserAccessDictionaryWithObj:(ACObject *)obj  opType:(OpType)opType  isAllow:(BOOL)isAllow  key:(NSString *)key;
@end
