#
# Copyright (C) 2013 The Android Open-Source Project
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

PRODUCT_COPY_FILES += \
    device/hardkernel/$(PRODUCT_DIR)/init.$(TARGET_PRODUCT).system.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.$(TARGET_PRODUCT).rc \
    device/hardkernel/$(PRODUCT_DIR)/init.$(TARGET_PRODUCT).usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.odroid.usb.rc \
    device/hardkernel/$(PRODUCT_DIR)/init.$(TARGET_PRODUCT).board.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.odroid.board.rc

ifneq ($(BOARD_USES_RECOVERY_AS_BOOT), true)
PRODUCT_COPY_FILES += \
    device/hardkernel/common/products/mbox/ueventd.odroid.rc:root/ueventd.odroidn2.rc
else
PRODUCT_COPY_FILES += \
    device/hardkernel/common/products/mbox/ueventd.odroid.rc:recovery/root/ueventd.odroidn2.rc
endif

# DRM HAL
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl:32 \
    android.hardware.drm@1.0-service \
    android.hardware.drm@1.1-service.widevine \
    android.hardware.drm@1.1-service.clearkey \
    move_widevine_data.sh

PRODUCT_COPY_FILES += \
    device/hardkernel/$(PRODUCT_DIR)/files/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles.xml \
    device/hardkernel/$(PRODUCT_DIR)/files/media_profiles_V1_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml \
    device/hardkernel/$(PRODUCT_DIR)/files/audio_effects.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.conf \
    device/hardkernel/$(PRODUCT_DIR)/files/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    device/hardkernel/$(PRODUCT_DIR)/files/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml \
    device/hardkernel/$(PRODUCT_DIR)/files/mesondisplay.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/mesondisplay.cfg \
    device/hardkernel/$(PRODUCT_DIR)/files/remote.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/remote.cfg \
    device/hardkernel/$(PRODUCT_DIR)/files/remote.tab1:$(TARGET_COPY_OUT_VENDOR)/etc/remote.tab1 \
    device/hardkernel/$(PRODUCT_DIR)/files/remote.tab2:$(TARGET_COPY_OUT_VENDOR)/etc/remote.tab2 \
    device/hardkernel/$(PRODUCT_DIR)/files/remote.tab3:$(TARGET_COPY_OUT_VENDOR)/etc/remote.tab3 \
    device/hardkernel/$(PRODUCT_DIR)/files/PQ/pq.db:$(TARGET_COPY_OUT_VENDOR)/etc/tvconfig/pq/pq.db \
    device/hardkernel/$(PRODUCT_DIR)/files/PQ/pq_default.ini:$(TARGET_COPY_OUT_VENDOR)/etc/tvconfig/pq/pq_default.ini

ifeq ($(BOARD_COMPILE_ATV),true)
PRODUCT_COPY_FILES += \
    device/hardkernel/$(PRODUCT_DIR)/files/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml
else
PRODUCT_COPY_FILES += \
    device/hardkernel/$(PRODUCT_DIR)/aosp/files/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml
endif

ifeq ($(USE_XML_AUDIO_POLICY_CONF), 1)
PRODUCT_COPY_FILES += \
    device/hardkernel/$(PRODUCT_DIR)/files/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    device/hardkernel/$(PRODUCT_DIR)/files/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml
else
PRODUCT_COPY_FILES += \
    device/hardkernel/$(PRODUCT_DIR)/files/audio_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy.conf
endif

ifeq ($(TARGET_WITH_MEDIA_EXT), true)
PRODUCT_COPY_FILES += \
    device/hardkernel/$(PRODUCT_DIR)/files/media_codecs_ext.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_ext.xml
endif

PRODUCT_COPY_FILES += \
    device/hardkernel/$(PRODUCT_DIR)/recovery/init.recovery.odroidn2.rc:root/init.recovery.odroidn2.rc \
    device/hardkernel/$(PRODUCT_DIR)/recovery/recovery.kl:recovery/root/etc/recovery.kl \
    device/hardkernel/$(PRODUCT_DIR)/files/mesondisplay.cfg:recovery/root/etc/mesondisplay.cfg \
    device/hardkernel/$(PRODUCT_DIR)/recovery/remotecfg:recovery/root/sbin/remotecfg \
    device/hardkernel/$(PRODUCT_DIR)/files/remote.cfg:recovery/root/etc/remote.cfg \
    device/hardkernel/$(PRODUCT_DIR)/files/remote.tab1:recovery/root/etc/remote.tab1 \
    device/hardkernel/$(PRODUCT_DIR)/files/remote.tab2:recovery/root/etc/remote.tab2 \
    device/hardkernel/$(PRODUCT_DIR)/files/remote.tab3:recovery/root/etc/remote.tab3 \
    device/hardkernel/$(PRODUCT_DIR)/recovery/sh:recovery/root/sbin/sh

# Copy Static Busybox
PRODUCT_COPY_FILES += \
    device/hardkernel/$(PRODUCT_DIR)/files/busybox:recovery/root/sbin/busybox

# remote IME config file
PRODUCT_COPY_FILES += \
    device/hardkernel/common/products/mbox/Vendor_0001_Product_0001.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_0001_Product_0001.kl \
    device/hardkernel/common/products/mbox/Vendor_1915_Product_0001.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_1915_Product_0001.kl

ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
PRODUCT_COPY_FILES += \
    device/hardkernel/$(PRODUCT_DIR)/files/Generic.kl:/$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Generic.kl
else
PRODUCT_COPY_FILES += \
    device/hardkernel/common/Generic.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Generic.kl
endif

PRODUCT_AAPT_CONFIG := xlarge hdpi xhdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi

PRODUCT_CHARACTERISTICS := tablet

ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
DEVICE_PACKAGE_OVERLAYS := \
    device/hardkernel/$(PRODUCT_DIR)/overlay
endif
PRODUCT_TAGS += dalvik.gc.type-precise


# setup dalvik vm configs.
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

#To remove healthd from the build
PRODUCT_PACKAGES += android.hardware.health@2.0-service.override
DEVICE_FRAMEWORK_MANIFEST_FILE += \
	system/libhidl/vintfdata/manifest_healthd_exclude.xml

#To keep healthd in the build
PRODUCT_PACKAGES += android.hardware.health@2.0-service

PRODUCT_COPY_FILES += \
    device/hardkernel/odroidn2/files/boot.ini.template:vendor/etc/boot.ini.template \
    device/hardkernel/odroidn2/files/hardkernel-720.bmp.gz:vendor/etc/hardkernel-720.bmp.gz \
    device/hardkernel/odroidn2/files/makebootini:vendor/bin/makebootini \
    device/hardkernel/odroidn2/files/default.prop.template:vendor/etc/default.prop.template \
    device/hardkernel/odroidn2/files/makedefaultprop:vendor/bin/makedefaultprop
