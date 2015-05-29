//
//  SyncViewController.h
//  UIViewController+Syncing
//
//  Created by Ken M. Haggerty on 5/28/15.
//  Copyright (c) 2015 MCMDI. All rights reserved.
//

#pragma mark - // NOTES (Public) //

#pragma mark - // IMPORTS (Public) //

#import <UIKit/UIKit.h>

#pragma mark - // PROTOCOLS //

@class SyncViewController;

@protocol SyncViewDelegate <NSObject>
@required
- (void)syncViewCancelButtonWasTapped:(SyncViewController *)sender;
@end

#pragma mark - // DEFINITIONS (Public) //

typedef enum {
    SyncViewBlank,
    SyncViewComplete,
    SyncViewWarning,
    SyncViewQuestion,
    SyncViewFailed,
    SyncViewCancelled
} SyncViewCompletionType;

@interface SyncViewController : UIViewController
@property (nonatomic, strong) id <SyncViewDelegate> delegate;

// SETTERS //

- (void)setSyncViewBackgroundColor:(UIColor *)color;
- (void)setSyncViewTextColor:(UIColor *)color;
- (void)setSyncViewPrimaryText:(NSString *)text;
- (void)setSyncViewSecondaryText:(NSString *)text;
- (void)setSyncViewButtonColor:(UIColor *)color;
- (void)setSyncViewButtonText:(NSString *)text;

// ACTIONS //

- (void)startSyncViewWithPrimaryText:(NSString *)primaryText secondaryText:(NSString *)secondaryText progressView:(BOOL)showProgress cancelButton:(BOOL)showCancel;
- (void)showSyncViewProgress;
- (void)hideSyncViewProgress;
- (void)setSyncViewProgress:(float)progress animated:(BOOL)animated;
- (void)showCancelButton:(BOOL)animated withCompletionBlock:(void (^)(void))completionBlock;
- (void)hideCancelButton:(BOOL)animated withCompletionBlock:(void (^)(void))completionBlock;
- (void)cancelSyncViewWithPrimaryText:(NSString *)primaryText secondaryText:(NSString *)secondaryText completionType:(SyncViewCompletionType)completionType alertController:(UIAlertController *)alertController delay:(NSTimeInterval)delay completionBlock:(void (^)(void))completionBlock;

@end