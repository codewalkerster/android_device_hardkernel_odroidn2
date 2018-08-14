#
# Copyright (C) 2018 Hardkernel Co,. Ltd.
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

SIGNJAR := out/host/linux-x86/framework/signapk.jar

BOOTLOADER := u-boot.bin

BOOT_IMG := $(PRODUCT_OUT)/boot.img
DTBS := s922d_odroidn2_android.dtb

VENDOR := vendor.img

SELFINSTALL_DIR := $(PRODUCT_OUT)/selfinstall
SELFINSTALL_SIGNED_UPDATEPACKAGE := $(SELFINSTALL_DIR)/cache/update.zip
BOOTLOADER_MESSAGE := $(SELFINSTALL_DIR)/BOOTLOADER_MESSAGE
SELFINSTALL_CACHE_IMAGE := $(SELFINSTALL_DIR)/cache.ext4

#
# Update image : update.zip
#
UPDATE_PACKAGE_PATH := $(SELFINSTALL_DIR)/otapackages

$(SELFINSTALL_DIR)/update.unsigned.zip: bootimage cacheimage systemimage vendorimage recoveryimage productimage
	rm -rf $@
	rm -rf $(UPDATE_PACKAGE_PATH)
	mkdir -p $(UPDATE_PACKAGE_PATH)/META-INF/com/google/android
	cp -af $(PRODUCT_OUT)/system.img $(UPDATE_PACKAGE_PATH)
	cp -af $(PRODUCT_OUT)/vendor.img $(UPDATE_PACKAGE_PATH)
	cp -af $(PRODUCT_OUT)/product.img $(UPDATE_PACKAGE_PATH)
	cp -af $(INSTALLED_CACHEIMAGE_TARGET) $(UPDATE_PACKAGE_PATH)
	cp -af $(PRODUCT_OUT)/system/bin/updater \
		$(UPDATE_PACKAGE_PATH)/META-INF/com/google/android/update-binary
	cp -af $(TARGET_DEVICE_DIR)/recovery/updater-script \
		$(UPDATE_PACKAGE_PATH)/META-INF/com/google/android/updater-script
	( pushd $(UPDATE_PACKAGE_PATH); \
		zip -r $(CURDIR)/$@ * ; \
	)

$(SELFINSTALL_SIGNED_UPDATEPACKAGE): $(SELFINSTALL_DIR)/update.unsigned.zip
	mkdir -p $(dir $@)
	java \
		-Djava.library.path=out/host/linux-x86/lib64 \
		-jar $(SIGNJAR) \
		-w $(DEFAULT_KEY_CERT_PAIR).x509.pem \
		$(DEFAULT_KEY_CERT_PAIR).pk8 $< $@

$(BOOTLOADER_MESSAGE):
	mkdir -p $(dir $@)
	dd if=/dev/zero of=$@ bs=16 count=4	# 64 Bytes
	echo "recovery" >> $@
	echo "--locale=en_US" >> $@
	echo "--update_package=/cache/update.zip" >> $@

.PHONY: $(SELFINSTALL_DIR)/cache
$(SELFINSTALL_DIR)/cache: $(SELFINSTALL_SIGNED_UPDATEPACKAGE) $(BOOTLOADER_MESSAGE)
	cp -af $(PRODUCT_OUT)/cache/ $(SELFINSTALL_DIR)/

$(SELFINSTALL_DIR)/cache.img: $(SELFINSTALL_DIR)/cache
	$(MAKE_EXT4FS) -s -L cache -a cache \
		-l $(BOARD_CACHEIMAGE_PARTITION_SIZE) $@ $<

$(SELFINSTALL_CACHE_IMAGE): $(SELFINSTALL_DIR)/cache.img
	simg2img $(SELFINSTALL_DIR)/cache.img $@

#
# Android Self-Installation
#
$(PRODUCT_OUT)/selfinstall-$(TARGET_DEVICE).bin: \
	$(BOOTLOADER_MESSAGE) \
	$(INSTALLED_RECOVERYIMAGE_TARGET) \
	$(UBOOT_IMAGE) \
	$(BOOT_IMG) \
	$(SELFINSTALL_CACHE_IMAGE)
	@echo "Creating installable single image file..."
	dd if=$(PRODUCT_OUT)/u-boot.bin of=$@ conv=fsync bs=512 seek=1
	dd if=$(PRODUCT_OUT)/obj/KERNEL_OBJ/arch/arm64/boot/dts/amlogic/$(DTBS) of=$@ conv=fsync bs=512 seek=12288
	dd if=$(BOOT_IMG) of=$@ conv=fsync bs=512 seek=12544
	dd if=$(BOOTLOADER_MESSAGE) of=$@ conv=fsync bs=512 seek=61696
	dd if=$(INSTALLED_RECOVERYIMAGE_TARGET) of=$@ conv=fsync bs=512 seek=78080
	dd if=$(SELFINSTALL_CACHE_IMAGE) of=$@ bs=512 seek=110848
	sync
	@echo "Done."

.PHONY: selfinstall
selfinstall: $(PRODUCT_OUT)/selfinstall-$(TARGET_DEVICE).bin
