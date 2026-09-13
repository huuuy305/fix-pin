THEOS_PACKAGE_SCHEME = roothide
ARCHS = arm64e
TARGET = iphone:clang:latest:15.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = replaced
replaced_FILES = Tweak.xm
replaced_CFLAGS = -fobjc-arc
replaced_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
