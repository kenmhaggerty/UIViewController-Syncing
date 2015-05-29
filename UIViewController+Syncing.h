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
#import "SyncViewController.h"

#pragma mark - // PROTOCOLS //

#pragma mark - // DEFINITIONS (Public) //

@interface UIViewController (Syncing) <SyncViewDelegate>
@property (nonatomic, strong, readonly) SyncViewController *syncViewController;
@property (nonatomic, readonly) BOOL isSyncing;

// PROPERTIES //

- (void)setViewForSyncView:(UIView *)view;
- (void)setSyncViewBackgroundColor:(UIColor *)color;
- (void)setSyncViewTextColor:(UIColor *)color;
- (void)setSyncViewPrimaryText:(NSString *)text;
- (void)setSyncViewSecondaryText:(NSString *)text;
- (void)setSyncViewCancelButtonColor:(UIColor *)color;
- (void)setSyncViewCancelButtonText:(NSString *)text;

// ACTIONS //

- (void)startSyncViewWithPrimaryText:(NSString *)primaryText secondaryText:(NSString *)secondaryText progressView:(BOOL)showProgress cancelButton:(BOOL)showCancel;
- (void)showSyncViewProgress;
- (void)hideSyncViewProgress;
- (void)setSyncViewProgress:(float)progress animated:(BOOL)animated;
- (void)showSyncViewCancelButton:(BOOL)animated withCompletionBlock:(void (^)(void))completionBlock;
- (void)hideSyncViewCancelButton:(BOOL)animated withCompletionBlock:(void (^)(void))completionBlock;
- (void)cancelSyncViewWithPrimaryText:(NSString *)primaryText secondaryText:(NSString *)secondaryText completionType:(SyncViewCompletionType)completionType alertController:(UIAlertController *)alertController delay:(NSTimeInterval)delay completionBlock:(void (^)(void))completionBlock;

@end