//
// Created by ren7995 on 2021-04-25 15:48:29
// Copyright (c) 2021 ren7995. All rights reserved.
//

#import "Shared.h"
#import "../Manager/ARITweakManager.h"
#import "../Manager/ARIEditManager.h"
#import "../UI/Splash/ARISplashViewController.h"
#import "../UI/Label/ARILabelView.h"

%hook SBIconController

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    [[ARIEditManager sharedInstance] toggleEditView:NO withTargetLocation:nil];

    ARITweakManager *manager = [ARITweakManager sharedInstance];
    if(![manager boolValueForKey:ARIDidSplashPreferenceKey]) {
        ARISplashViewController *splash = [[ARISplashViewController alloc] initWithSubtitle:@"Getting started"];
        [splash addEntry:@"3D touch an icon or triple tap your wallpaper to edit layout" image:[UIImage systemImageNamed:@"square.grid.3x3.fill.square"]];
        [splash addEntry:@"Drag the slider on the editor to see changes in real-time" image:[UIImage systemImageNamed:@"slider.horizontal.3"]];
        [splash addEntry:@"Tap the label underneath the slider and type in a value for precise control" image:[UIImage systemImageNamed:@"wand.and.rays"]];
        [splash addEntry:@"Tap this icon on the editor to edit layout for the current page only" image:[UIImage systemImageNamed:@"doc"]];
        [splash addEntry:@"See the preference pane in the Settings app for even more options" image:[UIImage systemImageNamed:@"gearshape"]];
        [splash addEntry:@"If you encounter a bug, don't hesitate to report it! Please include your device and iOS version." image:[UIImage systemImageNamed:@"ladybug"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            UIViewController *host = [[objc_getClass("SBIconController") sharedInstance] rootViewController];
            if(!host) return;
            [host presentViewController:splash animated:YES completion:nil];
        });
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    %orig;
    [[ARIEditManager sharedInstance] toggleEditView:NO withTargetLocation:nil];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    %orig;
    [[ARIEditManager sharedInstance] toggleEditView:NO withTargetLocation:nil];
}

%end

%hook SBMainSwitcherWindow

- (void)setHidden:(BOOL)arg {
    %orig;
    [[ARIEditManager sharedInstance] toggleEditView:NO withTargetLocation:nil];
}

%end

%hook SBIconScrollView

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated {
}

%end

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1 {
    %orig;
    [[ARITweakManager sharedInstance] onSpringboardLaunched];
}

%end

%group TodayViewFixiPad
%hook SBTodayViewController

- (void)viewWillAppear:(BOOL)arg1 {
    %orig;
    [[NSNotificationCenter defaultCenter]
            postNotificationName:ARIUpdateLabelVisibilityNotification
                          object:nil
                        userInfo:@{@"alpha" : @(0.0F), @"animationDuration" : @(0.3F)}];
}

- (void)viewDidDisappear:(BOOL)arg1 {
    %orig;
    [[NSNotificationCenter defaultCenter]
            postNotificationName:ARIUpdateLabelVisibilityNotification
                          object:nil
                        userInfo:@{@"alpha" : @(1.0F), @"animationDuration" : @(0.3F)}];
}

%end
%end

%ctor {
    ARITweakManager *manager = [ARITweakManager sharedInstance];
    if([manager isEnabled]) {
        NSLog(@"[Atria]: Loading hooks from %s", __FILE__);
        %init();

        if([manager isDeviceIPad]) {
            %init(TodayViewFixiPad);
        }
    }
}
