ARCHS = arm64 arm64e
TARGET = iphone:clang:16.5:15.0
THEOS_PACKAGE_SCHEME = rootless
THEOS_PACKAGE_INSTALL_PREFIX = /var/jb
INSTALL_TARGET_PROCESSES = SpringBoard Preferences

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Atria
Atria_FILES = $(wildcard src/Hooks/*.xm) $(wildcard src/Manager/*.m) $(wildcard src/Editor/*.m) $(wildcard src/Options/*.m) $(wildcard src/UI/*.m) $(wildcard src/UI/Effect/*.m) $(wildcard src/UI/Label/*.m) $(wildcard src/UI/Splash/*.m)
Atria_CFLAGS = -fobjc-arc
Atria_FRAMEWORKS = UIKit CoreText
Atria_LIBRARIES = substrate

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += Prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
