SIGNJAR := out/host/linux-x86/framework/signapk.jar

PKGDIR=$(PRODUCT_OUT)/updatepackage

UBOOT := bootloader/uboot/sd_fuse
KERNEL :=$(PRODUCT_OUT)/obj/KERNEL_OBJ
DTB := $(KERNEL)/arch/arm64/boot/dts/amlogic/s922d_odroidn2_android.dtb

$(PRODUCT_OUT)/updatepackage.zip: \
	build_bootloader bootimage \
	systemimage vendorimage \
	recoveryimage productimage
	rm -rf $@
	rm -rf $(PKGDIR)
	mkdir -p $(PKGDIR)/META-INF/com/google/android
	cp -a $(UBOOT)/u-boot.bin $(PKGDIR)
	cp -a $(PRODUCT_OUT)/boot.img $(PKGDIR)
	cp -a $(DTB) $(PKGDIR)
	cp -ad $(PRODUCT_OUT)/vendor $(PKGDIR)
	find $(PKGDIR)/vendor -type l | xargs rm -rf
	cp -ad $(PRODUCT_OUT)/system $(PKGDIR)
	find $(PKGDIR)/system -type l | xargs rm -rf
	cp -ad $(PRODUCT_OUT)/product $(PKGDIR)
	find $(PKGDIR)/product -type l | xargs rm -rf
	cp -a $(INSTALLED_RECOVERYIMAGE_TARGET) $(PKGDIR)
	cp -a $(PRODUCT_OUT)/system/bin/updater \
		$(PKGDIR)/META-INF/com/google/android/update-binary
	cp -a $(TARGET_DEVICE_DIR)/recovery/updater-script.updatepackage \
		$(PKGDIR)/META-INF/com/google/android/updater-script
	( pushd $(PKGDIR); \
		zip --symlinks -r $(CURDIR)/$@ * ; \
	)

$(PRODUCT_OUT)/updatepackage-$(TARGET_DEVICE)-signed.zip: \
	$(PRODUCT_OUT)/updatepackage.zip
	java \
		-Djava.library.path=out/host/linux-x86/lib64 \
		-jar $(SIGNJAR) \
		-w $(DEFAULT_KEY_CERT_PAIR).x509.pem \
		$(DEFAULT_KEY_CERT_PAIR).pk8 $< $@

.PHONY: updatepackage
updatepackage: $(PRODUCT_OUT)/updatepackage-$(TARGET_DEVICE)-signed.zip
