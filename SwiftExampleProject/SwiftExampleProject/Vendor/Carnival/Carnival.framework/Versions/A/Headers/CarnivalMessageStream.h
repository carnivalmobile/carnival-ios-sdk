//
//  CarnivalStream.h
//  Carnival
//
//  Created by Carnival Mobile
//  Copyright (c) 2015 Carnival Mobile. All rights reserved.
//
//  For documentation see http://docs.carnivalmobile.com
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CarnivalMessage.h"
#import "CarnivalMacros.h"


carnival_ASSUME_NONNULL_BEGIN
// Notifications
extern NSString * const CarnivalMessageStreamWillShowMessageDetailNotification;
extern NSString * const CarnivalMessageStreamDidShowMessageDetailNotification;
extern NSString * const CarnivalMessageStreamWillDismissMessageDetailNotification;
extern NSString * const CarnivalMessageStreamDidDismissMessageDetailNotification;

extern NSString * const CarnivalMessageStreamWillShowInAppNotificationNotification;
extern NSString * const CarnivalMessageStreamDidShowInAppNotificationNotification;
extern NSString * const CarnivalMessageStreamWillDismissInAppNotificationNotification;
extern NSString * const CarnivalMessageStreamDidDismissInAppNotificationNotification;

extern NSString * const CarnivalMessageStreamUnreadMessageCountDidChangeNotification;

// Keys
extern NSString * const CarnivalMessageStreamUnreadCountKey;
extern NSString * const CarnivalMessageTypeKey;
extern NSString * const CarnivalMessageIDKey;
carnival_ASSUME_NONNULL_END

typedef NS_ENUM(NSInteger, CarnivalImpressionType) {
    CarnivalImpressionTypeInAppNotificationView,
    CarnivalImpressionTypeStreamView,
    CarnivalImpressionTypeDetailView
};

@protocol CarnivalMessageStreamDelegate <NSObject>

@optional

/**
 *  Tells the delegate that the CarnivalMessageStream will show the detail for a particular message type.
 *
 *  @param messageType the type of the message that will be displayed.
 */
- (void)willShowMessageOfType:(CarnivalMessageType)messageType;

/**
 *  Tells the delegate that the CarnivalMessageStream showed the detail for a particular message type.
 *
 *  @param messageType the type of the message that was displayed.
 */
- (void)didShowMessageOfType:(CarnivalMessageType)messageType;

/**
 *  Tells the delegate that the CarnivalMessageStream will dismiss the detail for a particular message type.
 *
 *  @param messageType the type of the message that will be dismissed.
 */
- (void)willDismissMessageOfType:(CarnivalMessageType)messageType;

/**
 *  Tells the delegate that the CarnivalMessageStream dismissed the detail for a particular message type.
 *
 *  @param messageType the type of the message that was dismissed.
 */
- (void)didDismissMessageOfType:(CarnivalMessageType)messageType;

/**
 *  Tells the delegate that the CarnivalMessageStream will show an in-app notification for a particular message.
 *
 *  @param messageType The type of the message that will be shown.
 */
- (void)willShowInAppNotificationForMessageType:(CarnivalMessageType)messageType;

/**
 *  Tells the delegate that the CarnivalMessageStream showed an in-app notification for a particular message.
 *
 *  @param messageType The type of the message that was shown.
 */
- (void)didShowInAppNotificationForMessageType:(CarnivalMessageType)messageType;

/**
 *  Tells the delegate that the CarnivalMessageStream will dismiss an in-app notification for a particular message.
 *
 *  @param messageType The type of the message that will be dismissed.
 */
- (void)willDismissInAppNotificationForMessageType:(CarnivalMessageType)messageType;

/**
 *  Tells the delegate that the CarnivalMessageStream dismissed an in-app notification for a particular message.
 *
 *  @param messageType The type of the message that was dismissed.
 */
- (void)didDismissInAppNotificationForMessageType:(CarnivalMessageType)messageType;

/**
 *  Asks the delegate whether to show the In App notification for a given message.
 *
 *  @param message The message that Carnival wishes to present an In App notification for.
 *  
 *  @return A boolean of whether or the notification should be presented internally by the Carnival SDK. Override and return NO if the host app would like to handle the rendering and presentation of in-app notifications. 
 */
- (BOOL)shouldPresentInAppNotificationForMessage:(carnival_nonnull CarnivalMessage *)message;

@end

@interface CarnivalMessageStream : NSObject

/** @name Message statistics */

/**
 *  Asynchronously returns the total number of unread messages in the message stream.
 *
 *  @param handler A block object which returns the number of unread messages when there is no error.  The error will be non-nil if there was a problem retrieving the message count.
 *
 *  @warning This method does nothing if the handler block is NULL.
 */
+ (void)unreadCount:(carnival_nonnull void (^)(NSUInteger unreadCount, NSError *__carnival_nullable error))handler;

/**
 *  Asynchronously marks a given message as read.
 *
 *  @param handler A block object which returns an error which will be non-nil if there was a problem marking the message as read.
 */
+ (void)markMessageAsRead:(carnival_nonnull CarnivalMessage *)message withResponse:(carnival_nullable void(^)(NSError *__carnival_nullable error))handler;

/**
 *  Asynchronously marks a given array of messages as read.
 *
 *  @param handler A block object which returns an error which will be non-nil if there was a problem marking the messages as read.
 */
+ (void)markMessagesAsRead:(carnival_nonnull NSArray *)messages withResponse:(carnival_nullable void(^)(NSError *__carnival_nullable error))handler;

/**
 *  Returns an array of Carnival Messages for the device.
 *
 *  @param block A block which gets called with an array of CarnivalMessage objects and a possbile error. Cannot be NULL.
 */
+ (void)messages:(carnival_nonnull void (^)(NSArray *__carnival_nullable messages, NSError *__carnival_nullable error))block;

/**
 *  Removes the message with the given messageID from the Carnival Message Stream
 *
 *  @param message The message to be removed.
 *  @param handler A block object which returns an error which will be non-nil if there was a problem removing the message.
 */
+ (void)removeMessage:(carnival_nonnull CarnivalMessage *)message withResponse:(carnival_nullable void (^)(NSError *__carnival_nullable error))handler;

/**
 *  Sets the delegate for the CarnivalMessageStream.
 *
 *  @param delegate the object you wish to be the delegate of the CarnivalMessageStream.
 */
+ (void)setDelegate:(carnival_nonnull id<CarnivalMessageStreamDelegate>)delegate;

/**
 * Shows the message detail screen for a given message
 *
 * @param message The Message you wish to present.
 **/
+ (void)presentMessageDetailForMessage:(carnival_nonnull CarnivalMessage *)message;

/**
 *  Dismisses the message detail screen
 */
+ (void)dismissMessageDetail;

/**
 *  Creates an impression for a message for a given interaction type.
 *
 *  @param impressionType the CarnivalImpressionType type of the impression.
 *
 *  @param message the CarnivalMessage message on which you wish to create the impression.
 */
+ (void)registerImpressionWithType:(CarnivalImpressionType)impressionType forMessage:(carnival_nonnull CarnivalMessage *)message;

@end
