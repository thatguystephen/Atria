ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0
SDKVERSION = 16.5
THEOS_PACKAGE_SCHEME = rootless
THEOS_PACKAGE_INSTALL_PREFIX = /var/jb

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = AtriaPrefs
AtriaPrefs_FILES = $(wildcard src/*.m) ../src/UI/Splash/ARISplashViewController.m
AtriaPrefs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
AtriaPrefs_FRAMEWORKS = UIKit
AtriaPrefs_PRIVATE_FRAMEWORKS = Preferences
AtriaPrefs_INSTALL_PATH = /Library/PreferenceBundles
AtriaPrefs_RESOURCE_DIRS = Resources

include $(THEOS_MAKE_PATH)/bundle.mk
