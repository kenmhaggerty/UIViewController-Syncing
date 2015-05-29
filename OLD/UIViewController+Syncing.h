//
//  UIViewController+Syncing.h
//  UIViewController+Syncing
//
//  Created by Ken M. Haggerty on 10/9/13.
//  Copyright (c) 2013 Eureka Valley Co. All rights reserved.
//

#pragma mark - // NOTES (Public) //

#pragma mark - // IMPORTS (Public) //

#import <UIKit/UIKit.h>

#pragma mark - // PROTOCOLS //

#pragma mark - // DEFINITIONS (Public) //

typedef enum {
    AKSyncBlank,
    AKSyncComplete,
    AKSyncWarning,
    AKSyncQuestion,
    AKSyncFailed,
    AKSyncCancelled
} AKSyncCompletionType;

@protocol SyncViewDelegate <NSObject>
@required
- (void)syncViewDidCancel;
@end

@interface UIViewController (Syncing) <SyncViewDelegate>
@property (nonatomic, readonly) BOOL isSyncing;

// PROPERTIES //

- (void)setViewForSyncView:(UIView *)view;
- (void)setSyncViewBackgroundColor:(UIColor *)backgroundColor;
- (void)setSyncViewTextColor:(UIColor *)textColor;
- (void)setSyncViewStatusText:(NSString *)status;
- (void)setSyncViewCancelText:(NSString *)text;
- (void)showProgressView;
- (void)hideProgressView;
- (void)setSyncViewCancelButtonColor:(UIColor *)buttonColor;
- (void)showCancelButton:(BOOL)animated;
- (void)hideCancelButton:(BOOL)animated;
- (void)setDefaultStatusBarStyle:(UIStatusBarStyle)style;

// ACTIONS //

- (void)startSyncViewWithStatus:(NSString *)status cancelButton:(BOOL)showCancel;
- (void)setSyncViewProgress:(float)progress animated:(BOOL)animated;
- (void)dismissSyncViewWithCompletionBlock:(void (^)(BOOL))completionBlock;
- (void)cancelSyncViewWithStatus:(NSString *)status completionType:(AKSyncCompletionType)completionType actionSheet:(UIActionSheet *)actionSheet delay:(NSTimeInterval)delay completionBlock:(void (^)(BOOL))completionBlock;

@end