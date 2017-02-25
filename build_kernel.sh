#! /bin/bash

die() {
   echo "Error: $@"
   exit 1
}

if [ -z "$ANDROID_BUILD_TOP" ]; then
   echo "Error: Before running this script, setup for Android build"
   echo ""
   echo "  $ source build/envsetup.sh"
   echo "  $ lunch <target>"
fi

CCACHE="`which ccache` "

DEST="${ANDROID_PRODUCT_OUT}/kernel_obj"

CROSS="${CCACHE} $ANDROID_BUILD_TOP/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-"

KERNDIR="$ANDROID_BUILD_TOP/device/linaro/hikey-kernel-src"

CPU_CORES=$(nproc)

flags="ARCH=arm64 -j${CPU_CORES} O=${DEST}"

make -C $KERNDIR ${flags} hikey_defconfig || die "Unable to configure kernel"
make -C $KERNDIR CROSS_COMPILE="$CROSS" $flags || die "Unable to build kernel"
