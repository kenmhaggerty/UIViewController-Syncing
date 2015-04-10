//
//  UIViewController+Syncing.h
//  AKSuperViewController
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
- (void)syncViewDidCancelWithCompletionType:(AKSyncCompletionType)completionType;
@end

@interface UIViewController (Syncing) <SyncViewDelegate>
@property (nonatomic, readonly) BOOL isSyncing;
- (void)startSyncViewWithStatus:(NSString *)status cancelButton:(BOOL)showCancel;
- (void)cancelSyncViewWithStatus:(NSString *)status completionType:(AKSyncCompletionType)completionType actionSheet:(UIActionSheet *)actionSheet delay:(NSTimeInterval)delay completionBlock:(void (^)(BOOL))completionBlock;
- (void)setSyncViewStatusText:(NSString *)status;
- (void)setSyncViewCancelText:(NSString *)text;
- (void)showCancelButton:(BOOL)animated;
- (void)hideCancelButton:(BOOL)animated;
- (void)showProgressView;
- (void)hideProgressView;
- (void)setSyncViewProgress:(float)progress animated:(BOOL)animated;
- (void)dismissSyncViewWithCompletionBlock:(void (^)(BOOL))completionBlock;
- (void)setSyncViewBackgroundColor:(UIColor *)backgroundColor;
- (void)setSyncViewTextColor:(UIColor *)textColor;
- (void)setSyncViewCancelButtonColor:(UIColor *)buttonColor;
- (void)setViewForSyncView:(UIView *)view;
- (void)setDefaultStatusBarStyle:(UIStatusBarStyle)style;
@end