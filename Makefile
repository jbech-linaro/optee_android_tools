DEST=$(ANDROID_PRODUCT_OUT)/kernel_obj

# It's important that this is the location where we clone the Android kernel
KERNDIR=$(ANDROID_BUILD_TOP)/device/linaro/hikey-kernel-src

# If ccache is on the system, let us it
CCACHE ?= $(shell which ccache) # Don't remove this comment (space is needed)
CROSS_COMPILE="$(CCACHE)$(ANDROID_TOOLCHAIN)/aarch64-linux-android-"

# We need to merge a local conf-file to enable OP-TEE
DEF_CFGS ?= $(KERNDIR)/arch/arm64/configs/hikey_defconfig \
				$(CURDIR)/hikey.conf

FLAGS ?= LOCALVERSION= CROSS_COMPILE=$(CROSS_COMPILE)

# This is needed by merge_config.sh
export KCONFIG_CONFIG=$(DEST)/.config

all: linux

linux-defconfig:
	mkdir -p $(DEST)
	cd $(KERNDIR) && \
		ARCH=arm64 \
		$(KERNDIR)/scripts/kconfig/merge_config.sh $(DEF_CFGS)

linux: linux-defconfig
	$(MAKE) -C $(KERNDIR) ARCH=arm64 $(FLAGS) O=$(DEST)
