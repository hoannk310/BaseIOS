/*
 *  Copyright 2024 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import <Foundation/Foundation.h>

#import <WebRTC/RTCMacros.h>

typedef NS_ENUM(NSInteger, RTCRtpTransceiverDirection);

NS_ASSUME_NONNULL_BEGIN

RTC_OBJC_EXPORT
@interface RTC_OBJC_TYPE (RTCRtpHeaderExtensionCapability) : NSObject

/** The URI of the RTP header extension, as defined in RFC5285. */
@property(nonatomic, readonly, copy) NSString *uri;

/** The value put in the RTP packet to identify the header extension. */
@property(nonatomic, readonly, nullable) NSNumber* preferredId;

/** Whether the header extension is encrypted or not. */
@property(nonatomic, readonly, getter=isPreferredEncrypted)
    BOOL preferredEncrypted;

/** Direction of the header extension. */
@property(nonatomic) RTCRtpTransceiverDirection direction;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
