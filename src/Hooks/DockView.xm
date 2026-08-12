//
// Created by ren7995 on 2021-04-25 12:49:45
// Copyright (c) 2021 ren7995. All rights reserved.
//

#import "Shared.h"
#import "../Manager/ARITweakManager.h"

@interface SBFloatingDockPlatterView : UIView
@property (nonatomic, strong) UIView *backgroundView;
@end

static SBFloatingDockController *fdController;

%hook SBDockView

%new
- (void)_atriaUpdateDockForSettingsChanged {
    ARITweakManager *manager = [ARITweakManager sharedInstance];
    [self setBackgroundAlpha:[manager floatValueForKey:@"dock_bg"]];
}

- (CGFloat)dockHeight {
    if([[ARITweakManager sharedInstance] boolValueForKey:@"disableDock"])
        return 0;
    return %orig;
}

- (void)setBackgroundAlpha:(CGFloat)alpha {
    if([[ARITweakManager sharedInstance] boolValueForKey:@"disableDock"]) {
        %orig(0);
        return;
    }
    %orig([[ARITweakManager sharedInstance] floatValueForKey:@"dock_bg"]);
}

- (void)traitCollectionDidChange:(UITraitCollection *)old {
    %orig(old);
    [self performSelector:@selector(setBackgroundAlpha:) withObject:@(1.0f) afterDelay:0.0];
}

%end

%hook SBFloatingDockController

- (id)initWithWindowScene:(id)arg1 iconController:(id)arg2 {
    id orig = %orig;
    fdController = orig;
    return orig;
}

- (BOOL)isGesturePossible {
    if([[ARITweakManager sharedInstance] boolValueForKey:@"disableFloatingDockGestures"]) return NO;
    return %orig;
}

%new
+ (SBFloatingDockController *)_atriaSharedInstance {
    return fdController;
}

+ (BOOL)isFloatingDockSupported {
    ARITweakManager *manager = [ARITweakManager sharedInstance];
    return ([manager boolValueForKey:@"forceFloatingDock"] && ![manager boolValueForKey:@"disableDock"]) || %orig;
}

%end

%hook SBFloatingDockSuggestionsModel

- (id)initWithMaximumNumberOfSuggestions:(unsigned long long)arg1
                          iconController:(id)arg2
                       recentsController:(id)arg3
                        recentsDataStore:(id)arg4
                         recentsDefaults:(id)arg5
                    floatingDockDefaults:(id)arg6
                    appSuggestionManager:(id)arg7
                   applicationController:(id)arg8 {
    NSUInteger maxRecents = [[ARITweakManager sharedInstance] intValueForKey:@"maxFloatingDockRecents"];
    return %orig(maxRecents, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
}

%end

%hook SBFloatingDockView

%new
- (void)_atriaUpdateDockForSettingsChanged {
    self.backgroundView.layer.opacity = [[ARITweakManager sharedInstance] floatValueForKey:@"dock_bg"];
}

- (void)didMoveToSuperview {
    %orig;
    [self _atriaUpdateDockForSettingsChanged];
}

- (void)traitCollectionDidChange:(UITraitCollection *)old {
    %orig(old);
    [self performSelector:@selector(_atriaUpdateDockForSettingsChanged) withObject:nil afterDelay:0.0];
}

%end

%hook SBFloatingDockPlatterView

- (void)setBackgroundView:(UIView *)arg1 {
    arg1.layer.opacity = [[ARITweakManager sharedInstance] floatValueForKey:@"dock_bg"];
    %orig(arg1);
}

%end

%ctor {
    if([[ARITweakManager sharedInstance] isEnabled]) {
        NSLog(@"[Atria]: Loading hooks from %s", __FILE__);
        %init();
    }
}
