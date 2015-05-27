//
//  UIViewController+Syncing.m
//  AKSuperViewController
//
//  Created by Ken M. Haggerty on 10/9/13.
//  Copyright (c) 2013 Eureka Valley Co. All rights reserved.
//

#pragma mark - // NOTES (Private) //

#pragma mark - // IMPORTS (Private) //

#import "UIViewController+Syncing.h"
#import "AKDebugger.h"
#import "AKGenerics.h"
#import "AKSystemInfo.h"
#import <objc/runtime.h>

#pragma mark - // DEFINITIONS (Private) //

#define DEFAULT_PROGRESSVIEW_VISIBLE NO
#define DEFAULT_CANCEL_VISIBLE NO

#define DEFAULT_SYNC_STATUS @"Syncing..."
#define DEFAULT_CANCEL_TEXT @"Cancel"
#define DEFAULT_SUCCESS_TEXT @"Success"
#define DEFAULT_WARNING_TEXT @"Error Syncing"
#define DEFAULT_QUESTION_TEXT @"Unknown Error"
#define DEFAULT_INCOMPLETE_TEXT @"Sync Failed"
#define DEFAULT_CANCELLED_TEXT @"Cancelled"
#define DEFAULT_DELAY 0.33

#define ANIMATION_DURATION 0.15
#define STATUS_BAR_STYLE UIStatusBarStyleBlackTranslucent

#define DEFAULT_BACKGROUND_COLOR [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.66]
#define BACKGROUND_ALPHA 0.5
#define DEFAULT_TEXT_COLOR [UIColor whiteColor]

#define ICONVIEW_WIDTH 50.0
#define ICONVIEW_HEIGHT 50.0
#define ICON_CHECK @"syncview_check.png"
#define ICON_EXCLAMATION @"syncview_exclamation.png"
#define ICON_QUESTION @"syncview_question.png"
#define ICON_X @"syncview_x.png"

#define ACTIVITYINDICATOR_WIDTH 37.0
#define ACTIVITYINDICATOR_HEIGHT 37.0

#define PADDING_TOP 8.0

#define PROGRESSVIEW_WIDTH 100.0
#define PROGRESSVIEW_HEIGHT 2.0
#define PROGRESSVIEW_PROGRESS_COLOR [UIColor darkGrayColor]
#define PROGRESSVIEW_TRACK_COLOR [UIColor lightTextColor]

#define PADDING_BOTTOM 12.0

#define STATUSLABEL_HEIGHT 21.0
#define STATUSLABEL_FONT_NAME_IOS_6 @"HelveticaNeue-Light"
#define STATUSLABEL_FONT_NAME_IOS_7 @"HelveticaNeue-Thin"
#define STATUSLABEL_FONT_SIZE 17.0

#define DEFAULT_BUTTON_COLOR [UIColor blackColor]
#define BUTTON_HEIGHT 50.0
#define BUTTON_FONT_NAME @"HelveticaNeue-Light"
#define BUTTON_FONT_SIZE 20.0
#define BUTTON_ALPHA 0.66

static char syncViewKey;
static char centerViewKey;
static char iconViewKey;
static char activityIndicatorKey;
static char progressViewKey;
static char statusLabelKey;
static char buttonCancelKey;
static char isSyncingKey;
static char viewForSyncViewKey;
static char defaultStatusBarStyleKey;

@interface UIViewController ()
@property (nonatomic, readwrite) BOOL isSyncing;
@end

@implementation UIViewController (Syncing)

#pragma mark - // SETTERS AND GETTERS //

- (void)setSyncView:(UIView *)syncView
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:@[AKD_UI] message:nil];
    
    objc_setAssociatedObject(self, &syncViewKey, syncView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)syncView
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter customCategories:@[AKD_UI] message:nil];
    
	UIView *syncView = objc_getAssociatedObject(self, &syncViewKey);
    if (!syncView)
    {
        syncView = [[UIView alloc] initWithFrame:self.viewForSyncView.frame];
        [syncView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [syncView setClipsToBounds:YES];
        [syncView setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
        [self setSyncView:syncView];
    }
    return syncView;
}

- (void)setCenterView:(UIView *)centerView
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:@[AKD_UI] message:nil];
    
    objc_setAssociatedObject(self, &centerViewKey, centerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)centerView
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter customCategories:@[AKD_UI] message:nil];
    
    UIView *centerView = objc_getAssociatedObject(self, &centerViewKey);
    if (!centerView)
    {
        CGFloat centerViewHeight = ICONVIEW_HEIGHT+PADDING_TOP+PROGRESSVIEW_HEIGHT+PADDING_BOTTOM+STATUSLABEL_HEIGHT;
        centerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.syncView.bounds.size.height/2.0-(ICONVIEW_HEIGHT-ACTIVITYINDICATOR_HEIGHT/2.0), self.syncView.bounds.size.width, centerViewHeight)];
        [centerView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
        [self setCenterView:centerView];
    }
    return centerView;
}

- (void)setIconView:(UIImageView *)iconView
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:@[AKD_UI] message:nil];
    
    objc_setAssociatedObject(self, &iconViewKey, iconView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)iconView
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter customCategories:@[AKD_UI] message:nil];
    
    UIImageView *iconView = objc_getAssociatedObject(self, &iconViewKey);
    if (!iconView)
    {
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake((self.centerView.bounds.size.width-ICONVIEW_WIDTH)/2.0, 0.0, ICONVIEW_WIDTH, ICONVIEW_HEIGHT)];
        [iconView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin)];
        [self setIconView:iconView];
    }
    return iconView;
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:@[AKD_UI] message:nil];
    
    objc_setAssociatedObject(self, &activityIndicatorKey, activityIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView *)activityIndicator
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter customCategories:@[AKD_UI] message:nil];
    
    UIActivityIndicatorView *activityIndicator = objc_getAssociatedObject(self, &activityIndicatorKey);
    if (!activityIndicator)
    {
        activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.centerView.bounds.size.width-ACTIVITYINDICATOR_WIDTH)/2.0, ICONVIEW_HEIGHT-ACTIVITYINDICATOR_HEIGHT, ACTIVITYINDICATOR_WIDTH, ACTIVITYINDICATOR_HEIGHT)];
        [activityIndicator setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin)];
        [self setActivityIndicator:activityIndicator];
    }
    return activityIndicator;
}

- (void)setProgressView:(UIProgressView *)progressView
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:@[AKD_UI] message:nil];
    
    objc_setAssociatedObject(self, &progressViewKey, progressView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIProgressView *)progressView
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter customCategories:@[AKD_UI] message:nil];
    
    UIProgressView *progressView = objc_getAssociatedObject(self, &progressViewKey);
    if (!progressView)
    {
        progressView = [[UIProgressView alloc] initWithFrame:CGRectMake((self.centerView.bounds.size.width-PROGRESSVIEW_WIDTH)/2.0, ICONVIEW_HEIGHT+PADDING_TOP, PROGRESSVIEW_WIDTH, PROGRESSVIEW_HEIGHT)];
        [progressView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
        [progressView setProgress:0.0];
        [progressView setProgressTintColor:PROGRESSVIEW_PROGRESS_COLOR];
        [progressView setTrackTintColor:PROGRESSVIEW_TRACK_COLOR];
        [self setProgressView:progressView];
    }
    return progressView;
}

- (void)setStatusLabel:(UILabel *)statusLabel
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:@[AKD_UI] message:nil];
    
    objc_setAssociatedObject(self, &statusLabelKey, statusLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)statusLabel
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter customCategories:@[AKD_UI] message:nil];
    
    UILabel *statusLabel = objc_getAssociatedObject(self, &statusLabelKey);
    if (!statusLabel)
    {
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, ICONVIEW_HEIGHT+PADDING_TOP+PROGRESSVIEW_HEIGHT+PADDING_BOTTOM, self.centerView.bounds.size.width, STATUSLABEL_HEIGHT)];
        [statusLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];
        NSString *fontName = STATUSLABEL_FONT_NAME_IOS_7;
        if ([AKSystemInfo iOSVersion] < 7.0) fontName = STATUSLABEL_FONT_NAME_IOS_6;
        [statusLabel setFont:[UIFont fontWithName:fontName size:STATUSLABEL_FONT_SIZE]];
        [statusLabel setTextColor:DEFAULT_TEXT_COLOR];
        [statusLabel setTextAlignment:NSTextAlignmentCenter];
        [statusLabel setBackgroundColor:[UIColor clearColor]];
        [self setStatusLabel:statusLabel];
    }
    return statusLabel;
}

- (void)setButtonCancel:(UIButton *)buttonCancel
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:@[AKD_UI] message:nil];
    
    objc_setAssociatedObject(self, &buttonCancelKey, buttonCancel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)buttonCancel
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter customCategories:@[AKD_UI] message:nil];
    
    UIButton *buttonCancel = objc_getAssociatedObject(self, &buttonCancelKey);
    if (!buttonCancel)
    {
        UIButton *buttonCancel = [[UIButton alloc] initWithFrame:CGRectMake(0.0, self.syncView.bounds.size.height-BUTTON_HEIGHT, self.syncView.bounds.size.width, BUTTON_HEIGHT)];
        [buttonCancel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];
        [buttonCancel addTarget:self action:@selector(buttonActionCancel:) forControlEvents:UIControlEventTouchUpInside];
        [AKGenerics setText:DEFAULT_CANCEL_TEXT forButton:buttonCancel];
        [buttonCancel.titleLabel setFont:[UIFont fontWithName:BUTTON_FONT_NAME size:BUTTON_FONT_SIZE]];
        [buttonCancel setBackgroundColor:DEFAULT_BUTTON_COLOR];
        [buttonCancel setAlpha:BUTTON_ALPHA];
        [self setButtonCancel:buttonCancel];
    }
    return buttonCancel;
}

- (void)setIsSyncing:(BOOL)isSyncing
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:@[AKD_UI] message:nil];
    
    objc_setAssociatedObject(self, &isSyncingKey, [NSNumber numberWithBool:isSyncing], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isSyncing
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter customCategories:@[AKD_UI] message:nil];
    
    return [objc_getAssociatedObject(self, &isSyncingKey) boolValue];
}

- (UIView *)viewForSyncView
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter customCategories:@[AKD_UI] message:nil];
    
    UIView *viewForSyncView = objc_getAssociatedObject(self, &viewForSyncViewKey);
    if (!viewForSyncView)
    {
        viewForSyncView = self.view;
        [self setViewForSyncView:viewForSyncView];
    }
    return viewForSyncView;
}

- (UIStatusBarStyle)defaultStatusBarStyle
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter customCategories:@[AKD_UI] message:nil];
    
    return [objc_getAssociatedObject(self, &defaultStatusBarStyleKey) integerValue];
}

#pragma mark - // INITS AND LOADS //

#pragma mark - // PUBLIC METHODS //

- (void)startSyncViewWithStatus:(NSString *)status cancelButton:(BOOL)showCancel
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified customCategories:@[AKD_UI] message:nil];
    
    if (self.isSyncing)
    {
        [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeNotice methodType:AKMethodTypeUnspecified customCategories:@[AKD_UI] message:@"Syncing has already begun"];
        return;
    }
    
    [self setIsSyncing:YES];
    [self.syncView setFrame:self.viewForSyncView.bounds];
    if (![self.viewForSyncView.subviews containsObject:self.syncView]) [self.viewForSyncView addSubview:self.syncView];
    if (![self.syncView.subviews containsObject:self.centerView]) [self.syncView addSubview:self.centerView];
    [self.iconView setAlpha:0.0];
    if (![self.centerView.subviews containsObject:self.iconView]) [self.centerView addSubview:self.iconView];
    [self.activityIndicator setAlpha:1.0];
    [self.activityIndicator startAnimating];
    if (![self.centerView.subviews containsObject:self.activityIndicator]) [self.centerView addSubview:self.activityIndicator];
    if (![self.centerView.subviews containsObject:self.statusLabel]) [self.centerView addSubview:self.statusLabel];
    if (status) [self setSyncViewStatusText:status];
    else [self setSyncViewStatusText:DEFAULT_SYNC_STATUS];
    [self setDefaultStatusBarStyle:[AKSystemInfo statusBarStyle]];
    [UIView animateWithDuration:ANIMATION_DURATION delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [AKSystemInfo setStatusBarStyle:STATUS_BAR_STYLE];
    } completion:nil];
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        [self.syncView setAlpha:1.0];
    } completion:^(BOOL finished){
        if (showCancel) [self showCancelButton:YES];
    }];
}

- (void)cancelSyncViewWithStatus:(NSString *)status completionType:(AKSyncCompletionType)completionType actionSheet:(UIActionSheet *)actionSheet delay:(NSTimeInterval)delay completionBlock:(void (^)(BOOL))completionBlock
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified customCategories:@[AKD_UI] message:nil];
    
    if (!self.isSyncing)
    {
        [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeNotice methodType:AKMethodTypeUnspecified customCategories:@[AKD_UI] message:@"Syncing has already ended"];
        return;
    }
    
    [self setIsSyncing:NO];
    if ((!actionSheet) && (delay == 0.0))
    {
        [self hideCancelButton:YES withCompletionBlock:^(BOOL finished){
            [self dismissWithDelay:delay completionBlock:completionBlock];
        }];
    }
    else
    {
        if (status) [self setSyncViewStatusText:status];
        [self hideProgressView];
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setAlpha:0.0];
        switch (completionType) {
            case AKSyncComplete:
                [self.iconView setImage:[UIImage imageNamed:ICON_CHECK]];
                if (!status) [self setSyncViewStatusText:DEFAULT_SUCCESS_TEXT];
                break;
            case AKSyncWarning:
                [self.iconView setImage:[UIImage imageNamed:ICON_EXCLAMATION]];
                if (!status) [self setSyncViewStatusText:DEFAULT_WARNING_TEXT];
                break;
            case AKSyncQuestion:
                [self.iconView setImage:[UIImage imageNamed:ICON_QUESTION]];
                if (!status) [self setSyncViewStatusText:DEFAULT_QUESTION_TEXT];
                break;
            case AKSyncFailed:
                [self.iconView setImage:[UIImage imageNamed:ICON_X]];
                if (!status) [self setSyncViewStatusText:DEFAULT_INCOMPLETE_TEXT];
                break;
            case AKSyncCancelled:
                [self.iconView setImage:[UIImage imageNamed:ICON_X]];
                if (!status) [self setSyncViewStatusText:DEFAULT_CANCELLED_TEXT];
                break;
            case AKSyncBlank:
                [self.iconView setImage:nil];
                [self setSyncViewStatusText:nil];
                break;
        }
        [self.iconView setAlpha:1.0];
        [self hideCancelButton:YES withCompletionBlock:^(BOOL finished){
            if (actionSheet)
            {
                [actionSheet setBackgroundColor:[UIColor clearColor]];
                [actionSheet showInView:self.syncView];
            }
            else
            {
                [self dismissWithDelay:delay completionBlock:completionBlock];
            }
        }];
    }
}

- (void)setSyncViewStatusText:(NSString *)status
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified customCategories:@[AKD_UI] message:nil];
    
    [self.statusLabel setText:status];
}

- (void)setSyncViewCancelText:(NSString *)text
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified customCategories:@[AKD_UI] message:nil];
    
    if (text) [AKGenerics setText:text forButton:self.buttonCancel];
    else [AKGenerics setText:DEFAULT_CANCEL_TEXT forButton:self.buttonCancel];
}

- (void)showCancelButton:(BOOL)animated
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified customCategories:@[AKD_UI] message:nil];
    
    [self showCancelButton:animated withCompletionBlock:^(BOOL finished){}];
}

- (void)hideCancelButton:(BOOL)animated
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified customCategories:@[AKD_UI] message:nil];
    
    [self hideCancelButton:animated withCompletionBlock:^(BOOL finished){}];
}

- (void)showProgressView
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified customCategories:@[AKD_UI] message:nil];
    
    [self.progressView setAlpha:1.0];
}

- (void)hideProgressView
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified customCategories:@[AKD_UI] message:nil];
    
    [self.progressView setAlpha:0.0];
}

- (void)setSyncViewProgress:(float)progress animated:(BOOL)animated
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified customCategories:@[AKD_UI] message:nil];
    
    [self.progressView setProgress:progress animated:animated];
}

- (void)dismissSyncViewWithCompletionBlock:(void (^)(BOOL))completionBlock
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified customCategories:@[AKD_UI] message:nil];
    
    [self dismissWithDelay:0.0 completionBlock:completionBlock];
}

- (void)setSyncViewBackgroundColor:(UIColor *)backgroundColor
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:@[AKD_UI] message:nil];
    
    UIColor *colorToSet = DEFAULT_BACKGROUND_COLOR;
    if (backgroundColor) colorToSet = [UIColor colorWithRed:[[backgroundColor CIColor] red] green:[[backgroundColor CIColor] green] blue:[[backgroundColor CIColor] blue] alpha:BACKGROUND_ALPHA];
    [self.syncView setBackgroundColor:colorToSet];
}

- (void)setSyncViewTextColor:(UIColor *)textColor
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:@[AKD_UI] message:nil];
    
    UIColor *colorToSet = DEFAULT_TEXT_COLOR;
    if (textColor) colorToSet = textColor;
    [self.statusLabel setTextColor:colorToSet];
    [self.buttonCancel.titleLabel setTextColor:colorToSet];
}

- (void)setSyncViewCancelButtonColor:(UIColor *)buttonColor
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:@[AKD_UI] message:nil];
    
    UIColor *colorToSet = DEFAULT_BUTTON_COLOR;
    if (buttonColor) colorToSet = [UIColor colorWithRed:[[buttonColor CIColor] red] green:[[buttonColor CIColor] green] blue:[[buttonColor CIColor] blue] alpha:BUTTON_ALPHA];
    [self.buttonCancel setBackgroundColor:colorToSet];
}

- (void)setViewForSyncView:(UIView *)view
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:@[AKD_UI] message:nil];
    
    objc_setAssociatedObject(self, &viewForSyncViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDefaultStatusBarStyle:(UIStatusBarStyle)style
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:@[AKD_UI] message:nil];
    
    objc_setAssociatedObject(self, &defaultStatusBarStyleKey, [NSNumber numberWithInteger:style], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - // DELEGATED METHODS //

#pragma mark - // OVERWRITTEN METHODS //

#pragma mark - // PRIVATE METHODS //

- (void)buttonActionCancel:(UIButton *)sender
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified customCategories:@[AKD_UI] message:nil];
    
    [self syncViewDidCancelWithCompletionType:AKSyncCancelled];
}

- (void)showCancelButton:(BOOL)animated withCompletionBlock:(void (^)(BOOL))completionBlock
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified customCategories:@[AKD_UI] message:nil];
    
    [self.buttonCancel setUserInteractionEnabled:NO];
    NSTimeInterval duration = 0.0;
    if (animated) duration = ANIMATION_DURATION;
    [self.buttonCancel setCenter:CGPointMake(self.syncView.bounds.size.width/2.0, self.syncView.bounds.size.height+self.buttonCancel.bounds.size.height/2.0)];
    if (![self.syncView.subviews containsObject:self.buttonCancel]) [self.syncView addSubview:self.buttonCancel];
    [UIView animateWithDuration:duration animations:^{
        [self.buttonCancel setCenter:CGPointMake(self.syncView.bounds.size.width/2.0, self.syncView.bounds.size.height-self.buttonCancel.bounds.size.height/2.0)];
    } completion:^(BOOL finished){
        [self.buttonCancel setUserInteractionEnabled:YES];
        completionBlock(finished);
    }];
}

- (void)hideCancelButton:(BOOL)animated withCompletionBlock:(void (^)(BOOL))completionBlock
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified customCategories:@[AKD_UI] message:nil];
    
    [self.buttonCancel setUserInteractionEnabled:NO];
    NSTimeInterval duration = 0.0;
    if (animated) duration = ANIMATION_DURATION;
//    [self.buttonCancel setCenter:CGPointMake(self.syncView.bounds.size.width/2.0, self.syncView.bounds.size.height-self.buttonCancel.bounds.size.height/2.0)];
    [UIView animateWithDuration:duration animations:^{
        [self.buttonCancel setCenter:CGPointMake(self.syncView.bounds.size.width/2.0, self.syncView.bounds.size.height+self.buttonCancel.bounds.size.height/2.0)];
    } completion:^(BOOL finished){
        completionBlock(finished);
    }];
}

- (void)dismissWithDelay:(NSTimeInterval)delay completionBlock:(void (^)(BOOL))completionBlock
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified customCategories:@[AKD_UI] message:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            [AKSystemInfo setStatusBarStyle:self.defaultStatusBarStyle];
        }];
    });
    [UIView animateWithDuration:ANIMATION_DURATION delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.syncView setAlpha:0.0];
    } completion:^(BOOL finished){
        [self.syncView removeFromSuperview];
        if (completionBlock) completionBlock(finished);
    }];
}

@end