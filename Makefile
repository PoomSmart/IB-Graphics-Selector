GO_EASY_ON_ME = 1

include theos/makefiles/common.mk
export ARCHS = armv7 armv7s arm64
TWEAK_NAME = IBGraphicsHack
IBGraphicsHack_FILES = IBGraphicsHack.xm

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp -R IBGraphicsHack $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)find $(THEOS_STAGING_DIR) -name .DS_Store | xargs rm -rf$(ECHO_END)