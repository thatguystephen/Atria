//
// Created by ren7995 on 2021-04-27 18:35:28
// Copyright (c) 2021 ren7995. All rights reserved.
//

#import "Shared.h"
#import "../Manager/ARITweakManager.h"

%group DefaultIconModelStore
%hook SBDefaultIconModelStore

- (id)loadCurrentIconState:(NSError **)error {
    ARITweakManager *manager = [ARITweakManager sharedInstance];
    id lastKnownState = [manager rawValueForKey:@"_saveState"];
    if(lastKnownState) {
        return lastKnownState;
    }

    id orig = %orig;
    [manager setValue:orig forKey:@"_saveState"];
    return orig;
}

- (BOOL)saveCurrentIconState:(id)state error:(NSError **)error {
    [[ARITweakManager sharedInstance] setValue:state forKey:@"_saveState"];
    return %orig;
}

%end
%end

%group IconModelPropertyListFileStore
%hook SBIconModelPropertyListFileStore

- (id)loadCurrentIconState:(NSError **)error {
    ARITweakManager *manager = [ARITweakManager sharedInstance];
    id lastKnownState = [manager rawValueForKey:@"_saveState"];
    if(lastKnownState) {
        return lastKnownState;
    }

    id orig = %orig;
    [manager setValue:orig forKey:@"_saveState"];
    return orig;
}

- (BOOL)saveCurrentIconState:(id)state error:(NSError **)error {
    [[ARITweakManager sharedInstance] setValue:state forKey:@"_saveState"];
    return %orig;
}

%end
%end

%ctor {
    ARITweakManager *manager = [ARITweakManager sharedInstance];
    if([manager isEnabled]) {
        if([manager boolValueForKey:@"saveIconState"]) {
            NSLog(@"[Atria]: Loading hooks from %s", __FILE__);
            if(NSClassFromString(@"SBDefaultIconModelStore")) {
                %init(DefaultIconModelStore);
            } else if(NSClassFromString(@"SBIconModelPropertyListFileStore")) {
                %init(IconModelPropertyListFileStore);
            }
        } else {
            [[ARITweakManager sharedInstance] resetValueForKey:@"_saveState"];
        }
    }
}
