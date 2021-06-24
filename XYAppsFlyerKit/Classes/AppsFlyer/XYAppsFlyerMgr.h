//
//  XYAppsFlyerMgr.h
//  XYAppsFlyerKit
//
//  Created by Frenzy Feng on 2018/10/30.
//  Copyright (c) 2021 Hangzhou Xiaoying Innovation Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 接收到AppsFlyer信息的通知
FOUNDATION_EXTERN NSString * const XYAppsFlyerMediaSourceReceivedNotification;

/// mediaSource 属性的取值之一
FOUNDATION_EXTERN NSString * const XYAppsFlyerMediaSourceOrganic;
/// mediaSource 属性的取值之一
FOUNDATION_EXTERN NSString * const XYAppsFlyerMediaSourceNonorganic;

/// 以下都是mediaSourceDict的参数之一
FOUNDATION_EXTERN NSString * const XYAppsFlyerKeyStatus;
FOUNDATION_EXTERN NSString * const XYAppsFlyerKeyMediaSource;
FOUNDATION_EXTERN NSString * const XYAppsFlyerKeyCampaign;
FOUNDATION_EXTERN NSString * const XYAppsFlyerKeyKeywords;
FOUNDATION_EXTERN NSString * const XYAppsFlyerKeyIsFB;
FOUNDATION_EXTERN NSString * const XYAppsFlyerKeyFBCampaignId;
FOUNDATION_EXTERN NSString * const XYAppsFlyerKeyFBAdset;
FOUNDATION_EXTERN NSString * const XYAppsFlyerKeyFBAdsetId;
FOUNDATION_EXTERN NSString * const XYAppsFlyerKeyFBAdId;
FOUNDATION_EXTERN NSString * const XYAppsFlyerKeyAFChannel;
FOUNDATION_EXTERN NSString * const XYAppsFlyerKeyAFAdset;
FOUNDATION_EXTERN NSString * const XYAppsFlyerKeyAFAD;

@interface XYAppsFlyerMgr : NSObject

/// 原始的归因信息
@property (nonatomic, strong) NSDictionary *originConversionInfo;

/// 错误信息
@property (nonatomic, strong) NSError *originConversionError;

/// 归因结果，自然或者非自然用户
@property (nonatomic, strong) NSString *mediaSource;

/// 归因的结构化信息
@property (nonatomic, strong) NSDictionary *mediaSourceDict;

/// 是否是第一次启动，AppsFlyer回调之后会设置
@property (nonatomic, assign) BOOL isFirstLaunch;

+ (instancetype)sharedInstance;

/// 初始化AppsFlyer
/// @param appsFlyerDevKey key
/// @param appleAppID appid
- (void)xy_appsFlyerInitWithAppsFlyerDevKey:(NSString *)appsFlyerDevKey appleAppID:(NSString *)appleAppID;

/// 跟踪启动
- (void)xy_appsFlyerTrackAppLaunch;

/// 调用AppsFlyer的registerUninstall方法
/// @param deviceToken deviceToken
- (void)xy_appsFlyerRegisterUninstall:(NSData *)deviceToken;

/// 是否是非自然用户
- (BOOL)xy_appsFlyerIsNonorganic;

/// 返回uid
- (NSString *) xy_appsFlyerUID;

/// 发送AppsFlyer的埋点
/// @param eventId 埋点名称
/// @param attributes 埋点参数
- (void)xy_appsFlyerEvent:(NSString *)eventId attributes:(NSDictionary *)attributes;

@end

NS_ASSUME_NONNULL_END
