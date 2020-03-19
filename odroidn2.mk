# Copyright (C) 2018 HardKernel Co., Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# This file is the build configuration for a full Android
# build for Meson reference board.
#

PRODUCT_DIR := odroidn2

# Dynamic enable start/stop zygote_secondary in 64bits
# and 32bit system, default closed
#
#ANDROID_BUILD_TYPE := 64
#TARGET_DYNAMIC_ZYGOTE_SECONDARY_ENABLE := true

# Inherit from those products. Most specific first.
ifeq ($(ANDROID_BUILD_TYPE), 64)
ifeq ($(TARGET_DYNAMIC_ZYGOTE_SECONDARY_ENABLE), true)
$(call inherit-product, device/hardkernel/common/dynamic_zygote_seondary/dynamic_zygote_64_bit.mk)
else
$(call inherit-product, build/target/product/core_64_bit.mk)
endif
endif

BOARD_INSTALL_VULKAN := true

$(call inherit-product, device/hardkernel/$(PRODUCT_DIR)/vendor_prop.mk)
$(call inherit-product, device/hardkernel/common/products/mbox/product_mbox.mk)
$(call inherit-product, device/hardkernel/$(PRODUCT_DIR)/device.mk)
$(call inherit-product-if-exists, vendor/google/products/gms.mk)
#########################################################################
#
#                                               Media extension
#
#########################################################################
TARGET_WITH_MEDIA_EXT_LEVEL := 4
#########################################################################
#
#                     media ext
#
#########################################################################
ifeq ($(TARGET_WITH_MEDIA_EXT_LEVEL), 1)
    TARGET_WITH_MEDIA_EXT :=true
    TARGET_WITH_SWCODEC_EXT :=true
else
ifeq ($(TARGET_WITH_MEDIA_EXT_LEVEL), 2)
    TARGET_WITH_MEDIA_EXT :=true
    TARGET_WITH_CODEC_EXT := true
else
ifeq ($(TARGET_WITH_MEDIA_EXT_LEVEL), 3)
    TARGET_WITH_MEDIA_EXT :=true
    TARGET_WITH_SWCODEC_EXT := true
    TARGET_WITH_CODEC_EXT := true
else
ifeq ($(TARGET_WITH_MEDIA_EXT_LEVEL), 4)
    TARGET_WITH_MEDIA_EXT :=true
    TARGET_WITH_SWCODEC_EXT := true
    TARGET_WITH_CODEC_EXT := true
    TARGET_WITH_PLAYERS_EXT := true
endif
endif
endif
endif
# odroidn2:
PRODUCT_PROPERTY_OVERRIDES += \
        ro.hdmi.device_type=4 \
        persist.sys.hdmi.keep_awake=false

PRODUCT_NAME := odroidn2
PRODUCT_DEVICE := odroidn2
PRODUCT_BRAND := ODROID
PRODUCT_MODEL := ODROID-N2
PRODUCT_MANUFACTURER := HardKernel Co., Ltd.

TARGET_KERNEL_BUILT_FROM_SOURCE := true

PRODUCT_TYPE := mbox

BOARD_AML_TDK_KEY_PATH := device/hardkernel/common/tdk_keys/
WITH_LIBPLAYER_MODULE := false

OTA_UP_PART_NUM_CHANGED := false

BOARD_AML_VENDOR_PATH := vendor/amlogic/common/

BOARD_WIDEVINE_TA_PATH := vendor/amlogic/

#AB_OTA_UPDATER :=true
BUILD_WITH_AVB := false

ifeq ($(BUILD_WITH_AVB),true)
#BOARD_AVB_ENABLE := true
BOARD_BUILD_DISABLED_VBMETAIMAGE := true
BOARD_AVB_ALGORITHM := SHA256_RSA2048
BOARD_AVB_KEY_PATH := device/hardkernel/common/security/testkey_rsa2048.pem
BOARD_AVB_ROLLBACK_INDEX := 0
endif

ifeq ($(AB_OTA_UPDATER),true)
AB_OTA_PARTITIONS := \
    boot \
    system \
    vendor \
    odm \
    product

TARGET_BOOTLOADER_CONTROL_BLOCK := true
ifneq ($(BUILD_WITH_AVB),true)
TARGET_PARTITION_DTSI := partition_mbox_ab.dtsi
else
TARGET_PARTITION_DTSI := partition_mbox_ab_avb.dtsi
endif
else
TARGET_NO_RECOVERY := false

#BOARD_BUILD_SYSTEM_ROOT_IMAGE := true

BOARD_USES_SYSTEM_OTHER_ODEX := true

ifeq ($(ANDROID_BUILD_TYPE), 64)
TARGET_PARTITION_DTSI := partition_mbox_normal_P_64.dtsi
else
TARGET_PARTITION_DTSI := partition_mbox_normal_P_32.dtsi
endif

ifneq ($(BUILD_WITH_AVB),true)
TARGET_FIRMWARE_DTSI := firmware_normal.dtsi
else
ifeq ($(BOARD_BUILD_SYSTEM_ROOT_IMAGE), true)
ifeq ($(BOARD_BUILD_DISABLED_VBMETAIMAGE), true)
TARGET_FIRMWARE_DTSI := firmware_system.dtsi
else
TARGET_FIRMWARE_DTSI := firmware_avb_system.dtsi
endif
else
ifeq ($(BOARD_BUILD_DISABLED_VBMETAIMAGE), true)
TARGET_FIRMWARE_DTSI := firmware_normal.dtsi
else
TARGET_FIRMWARE_DTSI := firmware_avb.dtsi
endif
endif
endif

BOARD_CACHEIMAGE_PARTITION_SIZE := 1073741824
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 25165824
endif

########################################################################
#
#                           Kernel Arch
#
#
#########################################################################
#ifndef KERNEL_A32_SUPPORT
#KERNEL_A32_SUPPORT := true
#endif

########################################################################
#
#                           ATV
#
########################################################################
ifeq ($(BOARD_COMPILE_ATV),true)
BOARD_COMPILE_CTS := true
TARGET_BUILD_GOOGLE_ATV:= false
DONT_DEXPREOPT_PREBUILTS:= true
endif
########################################################################

########################################################################
#
#                           CTS
#
########################################################################
ifeq ($(BOARD_COMPILE_CTS),true)
BOARD_WIDEVINE_OEMCRYPTO_LEVEL := 1
BOARD_PLAYREADY_LEVEL := 1
TARGET_BUILD_CTS:= true
TARGET_BUILD_NETFLIX:= true
TARGET_BUILD_NETFLIX_MGKID := true
endif
########################################################################

#########################################################################
#
#                                                Dm-Verity
#
#########################################################################
#TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL := true
ifeq ($(TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL), true)
BUILD_WITH_DM_VERITY := true
endif # ifeq ($(TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL), true)
ifeq ($(BUILD_WITH_DM_VERITY), true)
PRODUCT_PACKAGES += \
	libfs_mgr \
	fs_mgr \
	slideshow
endif

PRODUCT_COPY_FILES += \
    device/hardkernel/$(PRODUCT_DIR)/fstab.system.odroidn2:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.odroidn2

#########################################################################
#
#                                                WiFi
#
#########################################################################
#USE_AML_WIFI := ture
WIFI_MODULE := multiwifi
ifeq ($(USE_AML_WIFI), true)
include hardware/amlogic/wifi/configs/wifi.mk
else
include device/hardkernel/common/wifi.mk
endif

# Change this to match target country
# 11 North America; 14 Japan; 13 rest of world
PRODUCT_DEFAULT_WIFI_CHANNELS := 11


#########################################################################
#
#                                                Bluetooth
#
#########################################################################

BOARD_HAVE_BLUETOOTH := true
#BOARD_HAVE_BLUETOOTH_BCM := true
include device/hardkernel/common/bluetooth.mk

#########################################################################
#
#                                                ConsumerIr
#
#########################################################################

#PRODUCT_PACKAGES += \
#    consumerir.amlogic \
#    SmartRemote
#PRODUCT_COPY_FILES += \
#    frameworks/native/data/etc/android.hardware.consumerir.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.consumerir.xml

ifeq ($(SUPPORT_HDMIIN),true)
PRODUCT_PACKAGES += \
    libhdmiin \
    HdmiIn
endif

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml

# Audio
#
BOARD_ALSA_AUDIO=tiny
include device/hardkernel/common/audio.mk

#########################################################################
#
#                                                Camera
#
#########################################################################

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.external.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.external.xml \



#########################################################################
#
#                                                PlayReady DRM
#
#########################################################################
#export BOARD_PLAYREADY_LEVEL=3 for PlayReady+NOTVP
#export BOARD_PLAYREADY_LEVEL=1 for PlayReady+OPTEE+TVP
#########################################################################
#
#                                                Verimatrix DRM
##########################################################################
#verimatrix web
BUILD_WITH_VIEWRIGHT_WEB := false
#verimatrix stb
BUILD_WITH_VIEWRIGHT_STB := false
#########################################################################


#DRM Widevine
ifeq ($(BOARD_WIDEVINE_OEMCRYPTO_LEVEL),)
BOARD_WIDEVINE_OEMCRYPTO_LEVEL := 3
endif

ifeq ($(BOARD_WIDEVINE_OEMCRYPTO_LEVEL), 1)
TARGET_USE_OPTEEOS := true
TARGET_ENABLE_TA_SIGN := true
TARGET_USE_HW_KEYMASTER := true
endif

$(call inherit-product, device/hardkernel/common/media.mk)

#########################################################################
#
#                                                Languages
#
#########################################################################

# For all locales, $(call inherit-product, build/target/product/languages_full.mk)
PRODUCT_LOCALES := en_US en_AU en_IN fr_FR it_IT es_ES et_EE de_DE nl_NL cs_CZ pl_PL ja_JP \
  zh_TW zh_CN zh_HK ru_RU ko_KR nb_NO es_US da_DK el_GR tr_TR pt_PT pt_BR rm_CH sv_SE bg_BG \
  ca_ES en_GB fi_FI hi_IN hr_HR hu_HU in_ID iw_IL lt_LT lv_LV ro_RO sk_SK sl_SI sr_RS uk_UA \
  vi_VN tl_PH ar_EG fa_IR th_TH sw_TZ ms_MY af_ZA zu_ZA am_ET hi_IN en_XA ar_XB fr_CA km_KH \
  lo_LA ne_NP si_LK mn_MN hy_AM az_AZ ka_GE my_MM mr_IN ml_IN is_IS mk_MK ky_KG eu_ES gl_ES \
  bn_BD ta_IN kn_IN te_IN uz_UZ ur_PK kk_KZ

#################################################################################
#
#                                                PPPOE
#
#################################################################################
#ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
#BUILD_WITH_PPPOE := false
#endif

ifeq ($(BUILD_WITH_PPPOE),true)
PRODUCT_PACKAGES += \
    PPPoE \
    libpppoejni \
    libpppoe \
    pppoe_wrapper \
    pppoe \
    droidlogic.frameworks.pppoe \
    droidlogic.external.pppoe \
    droidlogic.software.pppoe.xml
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.has.pppoe=true
endif

#################################################################################
#
#                                                DEFAULT LOWMEMORYKILLER CONFIG
#
#################################################################################
BUILD_WITH_LOWMEM_COMMON_CONFIG := true

BOARD_USES_USB_PM := true


include device/hardkernel/common/software.mk
ifeq ($(TARGET_BUILD_GOOGLE_ATV),true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=320
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=240
endif


#########################################################################
#
#                                     A/B update
#
#########################################################################
ifeq ($(BUILD_WITH_AVB),true)
PRODUCT_PACKAGES += \
	bootctrl.avb \
	libavb_user
endif

ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_PACKAGES += \
    bootctrl.$(TARGET_PRODUCT) \
    bootctl

PRODUCT_PACKAGES += \
    update_engine \
    update_engine_client \
    update_verifier \
    delta_generator \
    brillo_update_payload \
    android.hardware.boot@1.0 \
    android.hardware.boot@1.0-impl \
    android.hardware.boot@1.0-service
endif

# Superuser
PRODUCT_PACKAGES += su

# GPS
PRODUCT_PACKAGES += gps.$(PRODUCT_DEVICE)

# VU backlights
PRODUCT_PACKAGES += lights.$(PRODUCT_DEVICE)

# U-Boot Env Tools
PRODUCT_PACKAGES += \
    fw_printenv \
    fw_setenv

include device/hardkernel/common/gpu/gondul-user-arm64.mk

PRODUCT_PACKAGES += \
    static_busybox

# Prebuilt app
PRODUCT_PACKAGES += \
    CMFileManager \
    LightningBrowser \
    AndroidTerm

# Updater
PRODUCT_PACKAGES += updater

PRODUCT_PACKAGES += \
     com.android.future.usb.accessory

ifneq ($(TARGET_BUILD_LIVETV),true)
TARGET_BUILD_LIVETV := false
endif

ifneq ($(TARGET_BUILD_GOOGLE_ATV),true)
TARGET_BUILD_GOOGLE_ATV := false
endif

ifeq ($(HAVE_WRITED_SHELL_FILE),yes)
$(warning $(shell ($(AUTO_PATCH_SHELL_FILE) $(TARGET_BUILD_LIVETV) $(TARGET_BUILD_GOOGLE_ATV))))
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/files/hardkernel-720.bmp.gz:$(PRODUCT_OUT)/hardkernel-720.bmp.gz

$(call inherit-product, device/hardkernel/proprietary/proprietary.mk)
