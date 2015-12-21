//
//  SyncViewController.m
//  UIViewController+Syncing
//
//  Created by Ken M. Haggerty on 5/28/15.
//  Copyright (c) 2015 MCMDI. All rights reserved.
//

#pragma mark - // NOTES (Private) //

#pragma mark - // IMPORTS (Private) //

#import "SyncViewController.h"
#import "AKDebugger.h"
#import "AKGenerics.h"
#import "SystemInfo.h"

#pragma mark - // DEFINITIONS (Private) //

#define DEFAULT_BACKGROUND_COLOR [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.66]
#define SYNC_VIEW_ALPHA 0.66

#define ICON_CHECK @"syncview_check.png"
#define ICON_EXCLAMATION @"syncview_exclamation.png"
#define ICON_QUESTION @"syncview_question.png"
#define ICON_X @"syncview_x.png"

#define DEFAULT_TEXT_COLOR [UIColor whiteColor]
#define DEFAULT_PRIMARY_TEXT @"Syncing ..."
#define DEFAULT_SECONDARY_TEXT @" "

#define DEFAULT_SUCCESS_TEXT @"Success"
#define DEFAULT_WARNING_TEXT @"Error Syncing"
#define DEFAULT_QUESTION_TEXT @"Unknown Error"
#define DEFAULT_INCOMPLETE_TEXT @"Sync Failed"
#define DEFAULT_CANCELLED_TEXT @"Cancelled"

#define DEFAULT_BUTTON_COLOR [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.66]
#define DEFAULT_BUTTON_TEXT @"Cancel"

#define ANIMATION_DURATION 0.18
#define ANIMATION_DURATION_FAST ANIMATION_DURATION/1.66

@interface SyncViewController ()
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) IBOutlet UIImageView *iconView;
@property (nonatomic, strong) IBOutlet UILabel *labelPrimaryText;
@property (nonatomic, strong) IBOutlet UILabel *labelSecondaryText;
@property (nonatomic, strong) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) IBOutlet UIButton *buttonCancel;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *buttonCancelBottomConstraint;
@property (nonatomic) UIStatusBarStyle statusBarStyle;
- (void)setup;
- (void)teardown;
- (IBAction)actionButtonCancel:(id)sender;
- (void)dismissWithDelay:(NSTimeInterval)delay animated:(BOOL)animated completionBlock:(void (^)(void))completionBlock;
@end

@implementation SyncViewController

#pragma mark - // SETTERS AND GETTERS //

@synthesize delegate = _delegate;
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize iconView = _iconView;
@synthesize labelPrimaryText = _labelPrimaryText;
@synthesize labelSecondaryText = _labelSecondaryText;
@synthesize progressView = _progressView;
@synthesize buttonCancel = _buttonCancel;
@synthesize buttonCancelBottomConstraint = _buttonCancelBottomConstraint;
@synthesize statusBarStyle = _statusBarStyle;

#pragma mark - // INITS AND LOADS //

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self setup];
    }
    else [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeWarning methodType:AKMethodTypeSetup tags:@[AKD_UI] message:[NSString stringWithFormat:@"Could not initialize %@", stringFromVariable(self)]];
    return self;
}

- (void)awakeFromNib
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    [super awakeFromNib];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    [self teardown];
}

#pragma mark - // PUBLIC METHODS (Setters) //

- (void)setSyncViewBackgroundColor:(UIColor *)color
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetter tags:@[AKD_UI] message:nil];
    
    if (color) [self.view setBackgroundColor:color];
    else [self.view setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
}

- (void)setSyncViewTextColor:(UIColor *)color
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetter tags:@[AKD_UI] message:nil];
    
    if (color)
    {
        [self.labelPrimaryText setTextColor:color];
        [self.labelSecondaryText setTextColor:color];
        [self.buttonCancel.titleLabel setTextColor:color];
    }
    else
    {
        [self.labelPrimaryText setTextColor:DEFAULT_TEXT_COLOR];
        [self.labelSecondaryText setTextColor:DEFAULT_TEXT_COLOR];
        [self.buttonCancel.titleLabel setTextColor:DEFAULT_TEXT_COLOR];
    }
}

- (void)setSyncViewPrimaryText:(NSString *)text
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetter tags:@[AKD_UI] message:nil];
    
    if (text) [self.labelPrimaryText setText:text];
    else [self.labelPrimaryText setText:DEFAULT_PRIMARY_TEXT];
}

- (void)setSyncViewSecondaryText:(NSString *)text
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetter tags:@[AKD_UI] message:nil];
    
    if (text) [self.labelSecondaryText setText:text];
    else [self.labelSecondaryText setText:DEFAULT_SECONDARY_TEXT];
}

- (void)setSyncViewButtonColor:(UIColor *)color
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetter tags:@[AKD_UI] message:nil];
    
    if (color) [self.buttonCancel setBackgroundColor:color];
    else [self.buttonCancel setBackgroundColor:DEFAULT_BUTTON_COLOR];
}

- (void)setSyncViewButtonText:(NSString *)text
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetter tags:@[AKD_UI] message:nil];
    
    if (text) [self.buttonCancel.titleLabel setText:text];
    else [self.buttonCancel.titleLabel setText:DEFAULT_BUTTON_TEXT];
}

#pragma mark - // PUBLIC METHODS (Actions) //

- (void)startSyncViewWithPrimaryText:(NSString *)primaryText secondaryText:(NSString *)secondaryText progressView:(BOOL)showProgress cancelButton:(BOOL)showCancel animated:(BOOL)animated
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeAction tags:@[AKD_UI] message:nil];
    
    [self.view setAlpha:0.0];
    [self setSyncViewPrimaryText:primaryText];
    [self setSyncViewSecondaryText:secondaryText];
    [self.iconView setAlpha:0.0];
    [self.activityIndicatorView setAlpha:1.0];
    [self.activityIndicatorView startAnimating];
    [self setSyncViewProgress:0.0 animated:NO];
    if (showProgress) [self showSyncViewProgress];
    else [self hideSyncViewProgress];
    if (showProgress) [self showSyncViewProgress];
    [self hideSyncViewCancelButton:NO withCompletionBlock:nil];
    [self setStatusBarStyle:[SystemInfo statusBarStyle]];
    NSTimeInterval duration = 0.0;
    if (animated) duration = ANIMATION_DURATION_FAST;
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [SystemInfo setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    } completion:nil];
    [UIView animateWithDuration:duration animations:^{
        [self.view setAlpha:1.0];
    } completion:^(BOOL finished){
        if (showCancel) [self showSyncViewCancelButton:animated withCompletionBlock:nil];
    }];
}

- (void)showSyncViewProgress
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified tags:@[AKD_UI] message:nil];
    
    [self.progressView setAlpha:1.0];
}

- (void)hideSyncViewProgress
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified tags:@[AKD_UI] message:nil];
    
    [self.progressView setAlpha:0.0];
}

- (void)setSyncViewProgress:(float)progress animated:(BOOL)animated
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetter tags:@[AKD_UI] message:nil];
    
    [self.progressView setProgress:progress animated:animated];
}

- (void)showSyncViewCancelButton:(BOOL)animated withCompletionBlock:(void (^)(void))completionBlock
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified tags:@[AKD_UI] message:nil];
    
    [self.buttonCancel setUserInteractionEnabled:NO];
    NSTimeInterval duration = 0.0;
    if (animated) duration = ANIMATION_DURATION;
    [self.buttonCancel setCenter:CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height+self.buttonCancel.bounds.size.height/2.0)];
    if (![self.view.subviews containsObject:self.buttonCancel]) [self.view addSubview:self.buttonCancel];
    [UIView animateWithDuration:duration animations:^{
        [self.buttonCancel setCenter:CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height-self.buttonCancel.frame.size.height/2.0)];
        [self.buttonCancelBottomConstraint setConstant:0.0];
        [self.buttonCancel setAlpha:1.0];
    } completion:^(BOOL finished){
        [self.buttonCancel setUserInteractionEnabled:YES];
        if (completionBlock) completionBlock();
    }];
}

- (void)hideSyncViewCancelButton:(BOOL)animated withCompletionBlock:(void (^)(void))completionBlock
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified tags:@[AKD_UI] message:nil];
    
    [self.buttonCancel setUserInteractionEnabled:NO];
    NSTimeInterval duration = 0.0;
    if (animated) duration = ANIMATION_DURATION;
    [UIView animateWithDuration:duration animations:^{
        [self.buttonCancel setCenter:CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height+self.buttonCancel.frame.size.height/2.0)];
        [self.buttonCancelBottomConstraint setConstant:-1.0*self.buttonCancel.frame.size.height];
        [self.buttonCancel setAlpha:0.0];
    } completion:^(BOOL finished){
        if (completionBlock) completionBlock();
    }];
}

- (void)cancelSyncViewWithPrimaryText:(NSString *)primaryText secondaryText:(NSString *)secondaryText animated:(BOOL)animated completionType:(SyncViewCompletionType)completionType alertController:(UIAlertController *)alertController delay:(NSTimeInterval)delay completionBlock:(void (^)(void))completionBlock
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeAction tags:@[AKD_UI] message:nil];
    
    if ((!alertController) && (delay == 0.0))
    {
        [self hideSyncViewCancelButton:YES withCompletionBlock:^{
            [self dismissWithDelay:delay animated:animated completionBlock:completionBlock];
        }];
        return;
    }
    
    [self.activityIndicatorView stopAnimating];
    [self setSyncViewPrimaryText:primaryText];
    [self setSyncViewSecondaryText:secondaryText];
    switch (completionType) {
        case SyncViewComplete:
            [self.iconView setImage:[UIImage imageNamed:ICON_CHECK]];
            if (!primaryText) [self setSyncViewPrimaryText:DEFAULT_SUCCESS_TEXT];
            break;
        case SyncViewWarning:
            [self.iconView setImage:[UIImage imageNamed:ICON_EXCLAMATION]];
            if (!primaryText) [self setSyncViewPrimaryText:DEFAULT_WARNING_TEXT];
            break;
        case SyncViewQuestion:
            [self.iconView setImage:[UIImage imageNamed:ICON_QUESTION]];
            if (!primaryText) [self setSyncViewPrimaryText:DEFAULT_QUESTION_TEXT];
            break;
        case SyncViewFailed:
            [self.iconView setImage:[UIImage imageNamed:ICON_X]];
            if (!primaryText) [self setSyncViewPrimaryText:DEFAULT_INCOMPLETE_TEXT];
            break;
        case SyncViewCancelled:
            [self.iconView setImage:[UIImage imageNamed:ICON_X]];
            if (!primaryText) [self setSyncViewPrimaryText:DEFAULT_CANCELLED_TEXT];
            break;
        case SyncViewBlank:
            [self.iconView setImage:nil];
            break;
    }
    NSTimeInterval duration = 0.0;
    if (animated) duration = ANIMATION_DURATION_FAST;
    [UIView animateWithDuration:duration animations:^{
        [self.activityIndicatorView setAlpha:0.0];
        [self.iconView setAlpha:1.0];
        [self hideSyncViewProgress];
    } completion:^(BOOL finished){
        [self setSyncViewProgress:0.0 animated:NO];
    }];
    [self hideSyncViewCancelButton:animated withCompletionBlock:^{
        if (!alertController)
        {
            [self dismissWithDelay:delay animated:animated completionBlock:completionBlock];
            return;
            
        }
        
        [self presentViewController:alertController animated:animated completion:completionBlock];
    }];
}

#pragma mark - // DELEGATED METHODS //

#pragma mark - // OVERWRITTEN METHODS //

- (void)updateViewConstraints
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    [super updateViewConstraints];
    [self.labelPrimaryText sizeToFit];
    UILabel *labelPrimaryText = self.labelPrimaryText;
    [self.labelPrimaryText addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[%@(==%f)]", NSStringFromSelector(@selector(labelPrimaryText)), self.labelPrimaryText.frame.size.height]
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:NSDictionaryOfVariableBindings(labelPrimaryText)]];
    [self.labelSecondaryText sizeToFit];
    UILabel *labelSecondaryText = self.labelSecondaryText;
    [self.labelSecondaryText addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[%@(==%f)]", NSStringFromSelector(@selector(labelSecondaryText)), self.labelSecondaryText.frame.size.height]
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:NSDictionaryOfVariableBindings(labelSecondaryText)]];
}

#pragma mark - // PRIVATE METHODS //

- (void)setup
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    [self.view setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
    [self.view setAlpha:SYNC_VIEW_ALPHA];
    [self setSyncViewTextColor:DEFAULT_TEXT_COLOR];
    [self.buttonCancel setBackgroundColor:DEFAULT_BUTTON_COLOR];
    [self.activityIndicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.iconView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.labelPrimaryText setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.labelSecondaryText setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)teardown
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
}

- (IBAction)actionButtonCancel:(id)sender
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeAction tags:nil message:nil];
    
    if ([self.delegate respondsToSelector:@selector(syncViewCancelButtonWasTapped:)]) [self.delegate syncViewCancelButtonWasTapped:self];
}

- (void)dismissWithDelay:(NSTimeInterval)delay animated:(BOOL)animated completionBlock:(void (^)(void))completionBlock
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified tags:@[AKD_UI] message:nil];
    
    NSTimeInterval duration = 0.0;
    if (animated) duration = ANIMATION_DURATION;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:duration animations:^{
            [SystemInfo setStatusBarStyle:self.statusBarStyle];
        }];
    });
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view setAlpha:0.0];
    } completion:^(BOOL finished){
        [self.view removeFromSuperview];
        if (completionBlock) completionBlock();
    }];
}

@end
