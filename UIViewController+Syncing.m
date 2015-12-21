//
//  UIViewController+Syncing.m
//  UIViewController+Syncing
//
//  Created by Ken M. Haggerty on 10/9/13.
//  Copyright (c) 2013 Eureka Valley Co. All rights reserved.
//

#pragma mark - // NOTES (Private) //

#pragma mark - // IMPORTS (Private) //

#import "UIViewController+Syncing.h"
#import "AKDebugger.h"
#import "AKGenerics.h"
#import <objc/runtime.h>

#pragma mark - // DEFINITIONS (Private) //

static char syncViewControllerKey;
static char isSyncingKey;
static char viewForSyncViewKey;

@interface UIViewController ()
@property (nonatomic, strong, readwrite) SyncViewController *syncViewController;
@property (nonatomic, readwrite) BOOL isSyncing;
@end

@implementation UIViewController (Syncing)

#pragma mark - // SETTERS AND GETTERS //

- (void)setSyncViewController:(SyncViewController *)syncViewController
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    objc_setAssociatedObject(self, &syncViewControllerKey, syncViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SyncViewController *)syncViewController
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter tags:@[AKD_UI] message:nil];
    
    SyncViewController *syncViewController = objc_getAssociatedObject(self, &syncViewControllerKey);
    if (!syncViewController)
    {
        syncViewController = [[SyncViewController alloc] initWithNibName:NSStringFromClass([SyncViewController class]) bundle:nil];
        [syncViewController setDelegate:self];
        [syncViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [syncViewController.view setClipsToBounds:YES];
        [self setSyncViewController:syncViewController];
    }
    return syncViewController;
}

- (void)setIsSyncing:(BOOL)isSyncing
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    objc_setAssociatedObject(self, &isSyncingKey, [NSNumber numberWithBool:isSyncing], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isSyncing
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter tags:@[AKD_UI] message:nil];
    
    return [objc_getAssociatedObject(self, &isSyncingKey) boolValue];
}

- (UIView *)viewForSyncView
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter tags:@[AKD_UI] message:nil];
    
    UIView *viewForSyncView = objc_getAssociatedObject(self, &viewForSyncViewKey);
    if (!viewForSyncView)
    {
        viewForSyncView = [AKGenerics fullscreenWindow];
        [self setViewForSyncView:viewForSyncView];
    }
    return viewForSyncView;
}

#pragma mark - // INITS AND LOADS //

#pragma mark - // PUBLIC METHODS (Properties) //

- (void)setViewForSyncView:(UIView *)view
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    objc_setAssociatedObject(self, &viewForSyncViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.syncViewController.view setFrame:CGRectMake(0.0, 0.0, view.bounds.size.width, view.bounds.size.height)];
}

- (void)setSyncViewBackgroundColor:(UIColor *)color
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    [self.syncViewController setSyncViewBackgroundColor:color];
}

- (void)setSyncViewTextColor:(UIColor *)color
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    [self.syncViewController setSyncViewTextColor:color];
}

- (void)setSyncViewPrimaryText:(NSString *)text
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified tags:@[AKD_UI] message:nil];
    
    [self.syncViewController setSyncViewPrimaryText:text];
}

- (void)setSyncViewSecondaryText:(NSString *)text
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified tags:@[AKD_UI] message:nil];
    
    [self.syncViewController setSyncViewSecondaryText:text];
}

- (void)setSyncViewCancelButtonColor:(UIColor *)color
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    [self.syncViewController setSyncViewButtonColor:color];
}

- (void)setSyncViewCancelButtonText:(NSString *)text
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified tags:@[AKD_UI] message:nil];
    
    [self.syncViewController setSyncViewButtonText:text];
}

#pragma mark - // PUBLIC METHODS (Actions) //

- (void)startSyncViewWithPrimaryText:(NSString *)primaryText secondaryText:(NSString *)secondaryText progressView:(BOOL)showProgress cancelButton:(BOOL)showCancel animated:(BOOL)animated
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified tags:@[AKD_UI] message:nil];
    
    if (self.isSyncing)
    {
        [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeNotice methodType:AKMethodTypeUnspecified tags:@[AKD_UI] message:@"Syncing has already begun"];
        return;
    }
    
    [self setIsSyncing:YES];
    [self.syncViewController startSyncViewWithPrimaryText:primaryText secondaryText:secondaryText progressView:showProgress cancelButton:showCancel animated:animated];
    [self.viewForSyncView addSubview:self.syncViewController.view];
}

- (void)showSyncViewProgress
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified tags:@[AKD_UI] message:nil];
    
    [self.syncViewController showSyncViewProgress];
}

- (void)hideSyncViewProgress
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified tags:@[AKD_UI] message:nil];
    
    [self.syncViewController hideSyncViewProgress];
}

- (void)setSyncViewProgress:(float)progress animated:(BOOL)animated
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified tags:@[AKD_UI] message:nil];
    
    [self.syncViewController setSyncViewProgress:progress animated:animated];
}

- (void)showSyncViewCancelButton:(BOOL)animated withCompletionBlock:(void (^)(void))completionBlock
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified tags:@[AKD_UI] message:nil];
    
    [self.syncViewController showSyncViewCancelButton:animated withCompletionBlock:completionBlock];
}

- (void)hideSyncViewCancelButton:(BOOL)animated withCompletionBlock:(void (^)(void))completionBlock
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified tags:@[AKD_UI] message:nil];
    
    [self.syncViewController hideSyncViewCancelButton:animated withCompletionBlock:completionBlock];
}

- (void)cancelSyncViewWithPrimaryText:(NSString *)primaryText secondaryText:(NSString *)secondaryText animated:(BOOL)animated completionType:(SyncViewCompletionType)completionType alertController:(UIAlertController *)alertController delay:(NSTimeInterval)delay completionBlock:(void (^)(void))completionBlock
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified tags:@[AKD_UI] message:nil];
    
    if (!self.isSyncing)
    {
        [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeNotice methodType:AKMethodTypeUnspecified tags:@[AKD_UI] message:@"Syncing has already ended"];
        return;
    }
    
    [self setIsSyncing:NO];
    [self.syncViewController cancelSyncViewWithPrimaryText:primaryText secondaryText:secondaryText animated:animated completionType:completionType alertController:alertController delay:delay completionBlock:completionBlock];
}

#pragma mark - // DELEGATED METHODS //

#pragma mark - // OVERWRITTEN METHODS //

#pragma mark - // PRIVATE METHODS //

@end