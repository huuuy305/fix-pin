THEOS_PACKAGE_SCHEME = roothide
ARCHS = arm64e
TARGET = iphone:clang:latest:15.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Pin95
Pin95_FILES = Tweak.xm
Pin95_CFLAGS = -fobjc-arc
Pin95_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
