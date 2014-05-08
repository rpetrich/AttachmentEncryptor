TWEAK_NAME = AttachmentEncryptor
AttachmentEncryptor_FILES = Tweak.x

TOOL_NAME = postinst
postinst_FILES = postinst.m
#postinst_IPHONE_ARCHS = armv7
postinst_INSTALL_PATH = /DEBIAN

IPHONE_ARCHS = armv7 arm64
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 7.0

include framework/makefiles/common.mk
include framework/makefiles/tweak.mk
include framework/makefiles/tool.mk
