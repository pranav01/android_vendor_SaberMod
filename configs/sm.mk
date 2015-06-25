# Copyright (C) 2014-2015 The SaberMod Project
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

# Written for SaberMod toolchains
# TARGET_SM_AND and TARGET_SM_KERNEL can be set before this file, to override the default of gcc 4.9 for ROM.
# This is to avoid hardcoding the gcc versions for the ROM and kernels.

# Inherit sabermod configs.  Default to arm if LOCAL_ARCH is not defined.

ifdef TARGET_SM_AND
export TARGET_SM_AND := $(TARGET_SM_AND)
else
  $(warning =====================================================================)
  $(warning TARGET_SM_AND not defined.)
  $(warning Defaulting to gcc 4.9 for ROM.)
  $(warning =====================================================================)
export TARGET_SM_AND := 4.9
endif

ifdef TARGET_SM_KERNEL
  export TARGET_SM_KERNEL := $(TARGET_SM_KERNEL)
else
  $(warning =====================================================================)
  $(warning TARGET_SM_KERNEL not defined.)
  $(warning Defaulting to ROM gcc version $(TARGET_SM_AND).)
  $(warning =====================================================================)
  export TARGET_SM_KERNEL := $(TARGET_SM_AND)
endif

# Set GCC colors
export GCC_COLORS := 'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Find host os
UNAME := $(shell uname -s)

ifeq ($(strip $(UNAME)),Linux)
  HOST_OS := linux
endif

ifndef LOCAL_ARCH
  $(warning =====================================================================)
  $(warning Can not determine arch type, defaulting to arm)
  $(warning  To change this set LOCAL_ARCH :=)
  $(warning =====================================================================)
  LOCAL_ARCH := arm
endif

# Enable SaberMod ARM Mode for all arm builds.
ifneq ($(filter arm arm64,$(LOCAL_ARCH)),)
  ENABLE_SABERMOD_ARM_MODE := true
endif

ifeq ($(strip $(ENABLE_SABERMOD_ARM_MODE)),true)
  OPT4 := (gcc-arm)
endif

ifeq ($(strip $(LOCAL_ARCH)),arm)

  # Strict aliasing
  ifeq ($(strip $(ENABLE_STRICT_ALIASING)),true)
    GCC_STRICT_FLAGS := -Wstrict-aliasing=3 -Werror=strict-aliasing
    CLANG_STRICT_FLAGS := -Wstrict-aliasing=2 -Werror=strict-aliasing
  endif
endif

ifeq ($(strip $(LOCAL_ARCH)),arm64)

  # Strict aliasing
  ifeq ($(strip $(ENABLE_STRICT_ALIASING)),true)
    GCC_STRICT_FLAGS := -fstrict-aliasing -Wstrict-aliasing=3 -Werror=strict-aliasing
    CLANG_STRICT_FLAGS := -fstrict-aliasing -Wstrict-aliasing=2 -Werror=strict-aliasing
  endif
endif

# Turn debugging off for all builds.
FORCE_DISABLE_DEBUGGING := true

# Only use these compilers on linux host and arm targets.

ifeq ($(strip $(HOST_OS)),linux)
  ifneq ($(filter arm arm64,$(LOCAL_ARCH)),)
    ifeq ($(strip $(LOCAL_ARCH)),arm)

export TARGET_ARCH_LIB_PATH := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-linux-androideabi-$(TARGET_SM_AND)/lib

      # Path to ROM toolchain
      SM_AND_PATH := prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-linux-androideabi-$(TARGET_SM_AND)
      SM_AND := $(shell $(SM_AND_PATH)/bin/arm-linux-androideabi-gcc --version)

      # Find strings in version info
      ifneq ($(filter %sabermod,$(SM_AND)),)
        SM_AND_NAME := $(filter %sabermod,$(SM_AND))
        SM_AND_DATE := $(filter 20140% 20141% 20150% 20151%,$(SM_AND))
        SM_AND_STATUS := $(filter (release) (prerelease) (experimental),$(SM_AND))
        SM_AND_VERSION := $(SM_AND_NAME)-$(SM_AND_DATE)-$(SM_AND_STATUS)

        # Write version info to build.prop
        PRODUCT_PROPERTY_OVERRIDES += \
          ro.sm.android=$(SM_AND_VERSION)

        
        # Graphite ROM flags
        OPT1 := (graphite)

        # Some graphite flags are only available for certain gcc versions
 export GRAPHITE_UNROLL_AND_JAM_AND := $(filter 5.1% 6.0%,$(SM_AND_NAME))

        # Graphite flags and friends
        BASE_GRAPHITE_FLAGS := \
          -fgraphite \
          -fgraphite-identity \
          -floop-flatten \
          -ftree-loop-linear \
          -floop-interchange \
          -floop-strip-mine \
          -floop-block
        ifneq ($(GRAPHITE_UNROLL_AND_JAM_AND),)
          BASE_GRAPHITE_FLAGS += \
            -floop-unroll-and-jam
        endif

        # Check if there's already something set somewhere.
        ifndef GRAPHITE_FLAGS
          GRAPHITE_FLAGS := \
            $(BASE_GRAPHITE_FLAGS)
        else
          GRAPHITE_FLAGS += \
            $(BASE_GRAPHITE_FLAGS)
        endif

        # Legacy gcc doesn't understand this flag
        ifneq ($(strip $(USE_LEGACY_GCC)),true)
          GRAPHITE_FLAGS += \
            -Wno-error=maybe-uninitialized
        endif
      endif

      # Path to kernel toolchain
      SM_KERNEL_PATH := prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-eabi-$(TARGET_SM_KERNEL)
      SM_KERNEL := $(shell $(SM_KERNEL_PATH)/bin/arm-eabi-gcc --version)

      ifneq ($(filter %sabermod,$(SM_KERNEL)),)
 export SM_KERNEL_NAME := $(filter %sabermod,$(SM_KERNEL))
        SM_KERNEL_DATE := $(filter 20140% 20141% 20150% 20151%,$(SM_KERNEL))
        SM_KERNEL_STATUS := $(filter (release) (prerelease) (experimental),$(SM_KERNEL))
        SM_KERNEL_VERSION := $(SM_KERNEL_NAME)-$(SM_KERNEL_DATE)-$(SM_KERNEL_STATUS)

        # Write version info to build.prop
        PRODUCT_PROPERTY_OVERRIDES += \
          ro.sm.kernel=$(SM_KERNEL_VERSION)

        # Graphite flags for kernel

        # Some graphite flags are only available for certain gcc versions
 export GRAPHITE_UNROLL_AND_JAM_KERNEL := $(filter 5.1% 6.0%,$(SM_KERNEL_NAME))

        BASE_GRAPHITE_KERNEL_FLAGS := \
          -fgraphite \
          -fgraphite-identity \
          -floop-flatten \
          -ftree-loop-linear \
          -floop-interchange \
          -floop-strip-mine \
          -floop-block \
          -floop-nest-optimize
        ifneq ($(GRAPHITE_UNROLL_AND_JAM_KERNEL),)
          BASE_GRAPHITE_KERNEL_FLAGS += \
            -floop-unroll-and-jam
        endif

        # Check if there's already something set somewhere.
        ifndef GRAPHITE_KERNEL_FLAGS
   export GRAPHITE_KERNEL_FLAGS := \
            $(BASE_GRAPHITE_KERNEL_FLAGS)
        else
   export GRAPHITE_KERNEL_FLAGS := \
            $(BASE_GRAPHITE_KERNEL_FLAGS) \
            $(GRAPHITE_KERNEL_FLAGS)
        endif
        ifeq ($(strip $(ENABLE_STRICT_ALIASING)),true)

          # strict-aliasing kernel flags
   export KERNEL_STRICT_FLAGS := \
            -fstrict-aliasing \
            -Werror=strict-aliasing
        endif
      endif
    endif

    ifeq ($(strip $(LOCAL_ARCH)),arm64)

export TARGET_ARCH_LIB_PATH := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-linux-android-$(TARGET_SM_AND)/lib

      # Path to toolchain
      SM_AND_PATH := prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-linux-android-$(TARGET_SM_AND)
      SM_AND := $(shell $(SM_AND_PATH)/bin/aarch64-linux-android-gcc --version)

      # Find strings in version info
      ifneq ($(filter %sabermod,$(SM_AND)),)
        SM_AND_NAME := $(filter %sabermod,$(SM_AND))
        SM_AND_DATE := $(filter 20140% 20141% 20150% 20151%,$(SM_AND))
        SM_AND_STATUS := $(filter (release) (prerelease) (experimental),$(SM_AND))
        SM_AND_VERSION := $(SM_AND_NAME)-$(SM_AND_DATE)-$(SM_AND_STATUS)

        # Write version info to build.prop
        PRODUCT_PROPERTY_OVERRIDES += \
          ro.sm.android=$(SM_AND_VERSION)

        # Graphite ROM flags
        OPT1 := (graphite)

        # Some graphite flags are only available for certain gcc versions
 export GRAPHITE_UNROLL_AND_JAM_AND := $(filter 5.1% 6.0%,$(SM_AND_NAME))

        # Graphite flags and friends
        BASE_GRAPHITE_FLAGS := \
          -fgraphite \
          -fgraphite-identity \
          -floop-flatten \
          -ftree-loop-linear \
          -floop-interchange \
          -floop-strip-mine \
          -floop-block
        ifneq ($(GRAPHITE_UNROLL_AND_JAM_AND),)
          BASE_GRAPHITE_FLAGS += \
            -floop-unroll-and-jam
        endif

        # Check if there's already something set somewhere.
        ifndef GRAPHITE_FLAGS
          GRAPHITE_FLAGS := \
            $(BASE_GRAPHITE_FLAGS)
        else
          GRAPHITE_FLAGS += \
            $(BASE_GRAPHITE_FLAGS)
        endif

        # Legacy gcc doesn't understand this flag
        ifneq ($(strip $(USE_LEGACY_GCC)),true)
          GRAPHITE_FLAGS += \
            -Wno-error=maybe-uninitialized
        endif
      endif
    
      # Path to kernel toolchain
      SM_KERNEL_PATH := prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-$(TARGET_SM_KERNEL)
      SM_KERNEL := $(shell $(SM_KERNEL_PATH)/bin/aarch64-gcc --version)

      ifneq ($(filter %sabermod,$(SM_KERNEL)),)
 export SM_KERNEL_NAME := $(filter %sabermod,$(SM_KERNEL))
        SM_KERNEL_DATE := $(filter 20140% 20141% 20150% 20151%,$(SM_KERNEL))
        SM_KERNEL_STATUS := $(filter (release) (prerelease) (experimental),$(SM_KERNEL))
        SM_KERNEL_VERSION := $(SM_KERNEL_NAME)-$(SM_KERNEL_DATE)-$(SM_KERNEL_STATUS)

        # Write version info to build.prop
        PRODUCT_PROPERTY_OVERRIDES += \
          ro.sm.kernel=$(SM_KERNEL_VERSION)

        # Graphite flags for kernel

        # Some graphite flags are only available for certain gcc versions
 export GRAPHITE_UNROLL_AND_JAM_KERNEL := $(filter 5.1% 6.0%,$(SM_KERNEL_NAME))

        BASE_GRAPHITE_KERNEL_FLAGS := \
          -fgraphite \
          -fgraphite-identity \
          -floop-flatten \
          -ftree-loop-linear \
          -floop-interchange \
          -floop-strip-mine \
          -floop-block \
          -floop-nest-optimize
        ifneq ($(GRAPHITE_UNROLL_AND_JAM_KERNEL),)
          BASE_GRAPHITE_KERNEL_FLAGS += \
            -floop-unroll-and-jam
        endif

        # Check if there's already something set somewhere.
        ifndef GRAPHITE_KERNEL_FLAGS
   export GRAPHITE_KERNEL_FLAGS := \
            $(BASE_GRAPHITE_KERNEL_FLAGS)
        else
   export GRAPHITE_KERNEL_FLAGS := \
            $(BASE_GRAPHITE_KERNEL_FLAGS) \
            $(GRAPHITE_KERNEL_FLAGS)
        endif

   # Floop Nest Modules flags
   LOCAL_ENABLE_NEST := \
          art \
          libsigchain \
          libart \
          libart-compiler \
          libartd \
          libartd-compiler \
          libart-disassembler \
          libartd-disassembler \
          core.art-host \
          core.art \
          cpplint-art-phony \
          libnativebridgetest \
          libarttest \
          art-run-tests \
          libart-gtest \
          libc \
          libc_bionic \
          libc_gdtoa \
          libc_netbsd \
          libc_freebsd \
          libc_dns \
          libc_openbsd \
          libc_cxa \
          libc_syscalls \
          libc_aeabi \
          libc_common \
          libc_nomalloc \
          libc_malloc \
          libc_stack_protector \
          libc_tzcode \
          libstdc++ \
          linker \
          libdl \
          libm \
          tzdata \
          bionic-benchmarks

        ifeq ($(strip $(ENABLE_STRICT_ALIASING)),true)

        # strict-aliasing kernel flags
 export KERNEL_STRICT_FLAGS := \
          -fstrict-aliasing \
          -Werror=strict-aliasing
        endif
      endif
    endif
    ifdef TARGET_ARCH_LIB_PATH

      # Add extra libs for the compilers to use
export LD_LIBRARY_PATH := $(TARGET_ARCH_LIB_PATH):$(LD_LIBRARY_PATH)
export LIBRARY_PATH := $(TARGET_ARCH_LIB_PATH):$(LIBRARY_PATH)
    endif

    ifneq ($(GRAPHITE_FLAGS),)

      # Force disable some modules that are not compatible with graphite flags.
      # Add more modules if needed for devices in device/sm_device.mk or by ROM in product/rom_product.mk with
      # LOCAL_DISABLE_GRAPHITE:=

      ifneq ($(filter 4.8% 4.9%,$(SM_AND_NAME)),)
        LOCAL_BASE_DISABLE_GRAPHITE := \
          libunwind \
          libFFTEm \
          libicui18n \
          libskia \
          libvpx \
          libmedia_jni \
          libstagefright_mp3dec \
          libart \
          mdnsd \
          libwebrtc_spl \
          third_party_WebKit_Source_core_webcore_svg_gyp \
          libjni_filtershow_filters \
          libavformat \
          libavcodec \
          skia_skia_library_gyp \
          libSR_Core \
          third_party_libvpx_libvpx_gyp \
          ui_gl_gl_gyp \
          fio \
          libpdfiumcore \
        libFraunhoferAAC \
        libncurses
      endif

      ifneq ($(filter 5.1% 6.0%,$(SM_AND_NAME)),)
        LOCAL_BASE_DISABLE_GRAPHITE := \
          libjavacore \
          libc_bionic \
          libnetutils \
          libandroid_runtime \
          libpdfiumcore \
          libicui18n \
          libicuuc
      endif

      # Check if there's already something set somewhere.
      ifndef LOCAL_DISABLE_GRAPHITE
        LOCAL_DISABLE_GRAPHITE := \
          $(LOCAL_BASE_DISABLE_GRAPHITE)
      else
        LOCAL_DISABLE_GRAPHITE += \
          $(LOCAL_BASE_DISABLE_GRAPHITE)
      endif
    endif
    # GCC 5/6 variables.
    ifneq ($(filter 5.1% 6.0%,$(SM_KERNEL_NAME)),)
      WARN_NO_ERROR := \
        base_base_gyp
    endif
  endif
else
    $(warning ========================================================================)
    $(warning   Limited optimization options are available outside of linux host OS.)
    $(warning   To take advantage of all optimization options, build on linux host OS.)
    $(warning ========================================================================)
endif

# strict-aliasing

ifeq ($(strip $(ENABLE_STRICT_ALIASING)),true)
  LOCAL_BASE_DISABLE_STRICT_ALIASING := \
    libpdfiumcore \
    libpdfium \
    libc_bionic \
    libc_dns \
    libc_gdtoa \
    libc_openbsd \
    libfs_mgr \
    libcutils \
    liblog \
    libc \
    adbd \
    libunwind \
    libziparchive \
    libsync \
    libnetutils \
    libRS \
    libbcinfo \
    libbccCore \
    libbccSupport \
    libstagefright_foundation \
    libusbhost \
    bluetooth.default \
    libbt-brcm_bta \
    libnetd_client \
    libbt-brcm_stack \
    bcc \
    debuggerd \
    toolbox \
    clatd \
    ip \
    libnetlink \
    libc_nomalloc \
    linker \
    libstagefright_avc_common \
    logd \
    libstagefright_webm \
    libstagefright_httplive \
    libstagefright_rtsp \
    sdcard \
    netd \
    libdiskconfig \
    audio.a2dp.default \
    libjavacore \
    libstagefright_avcenc \
    libRSDriver \
    libminivold \
    libsdcard \
    libvold \
    gatt_testtool \
    su \
    libqsap_sdk \
    libc_malloc \
    libRSSupport \
    libstlport \
    libstlport_static \
    libcrypto_static \
    dnsmasq \
    libmedia \
    ping \
    libaudioflinger \
    libmediaplayerservice \
    libstagefright \
    libssh \
    libvariablespeed \
    libsurfaceflinger \
    libstagefright_amrnbdec \
    librtp_jni \
    libOmxVenc \
    libwilhelm \
    libldnhncr \
    libdownmix \
    libqcomvisualizer \
    libvisualizer \
    lsof \
    libcrypto \
    ping6 \
    ssh \
    tcpdump \
    libfuse \
    libbusybox \
    libziparchive-host \
    mdnsd \
    libuclibcrpc \
    busybox \
    libfdlibm

  # Check if there's already something somewhere.
  ifndef LOCAL_DISABLE_STRICT_ALIASING
    LOCAL_DISABLE_STRICT_ALIASING := \
      $(LOCAL_BASE_DISABLE_STRICT_ALIASING)
  else
    LOCAL_DISABLE_STRICT_ALIASING += \
      $(LOCAL_BASE_DISABLE_STRICT_ALIASING)
  endif
  OPT5 := (strict)
else
  OPT5 :=
endif

# General flags for gcc 4.9 to allow compilation to complete.
# Commented out for now since there's no common (non-device specific) modules to list here.
# Add more modules if needed for devices in device/sm_device.mk or by ROM in product/rom_product.mk with
# MAYBE_UNINITIALIZED :=

# Check if there's already something set somewhere.
ifndef MAYBE_UNINITIALIZED
  MAYBE_UNINITIALIZED := \
    fastboot
else
  MAYBE_UNINITIALIZED += \
    fastboot
endif

# Bluetooth modules
LOCAL_BLUETOOTH_BLUEDROID := \
  bluetooth.default \
  libbt-brcm_stack \
  audio.a2dp.default \
  libbt-brcm_gki \
  libbt-utils \
  libbt-qcom_sbc_decoder \
  libbt-brcm_bta \
  bdt \
  bdtest \
  libbt-hci \
  libosi \
  ositests \
  libbt-vendor \
  libbluetooth_jni

# O3 optimizations
ifeq ($(strip $(LOCAL_O3)),true)

  # If -O3 is enabled, force disable on thumb flags.
  # loop optmizations are not really usefull in thumb mode.
  LOCAL_DISABLE_O3_THUMB := true
  OPT2 := (O3)

  # Disable some modules that break with -O3
  # Add more modules if needed for devices in device/sm_device.mk or by ROM in product/rom_product.mk with
  # LOCAL_DISABLE_O3 :=

  # Check if there's already something set somewhere.
  ifndef LOCAL_DISABLE_O3
    LOCAL_DISABLE_O3 := \
      libaudioflinger \
      skia_skia_library_gyp \
      $(LOCAL_BLUETOOTH_BLUEDROID)
  else
    LOCAL_DISABLE_O3 += \
      libaudioflinger \
      skia_skia_library_gyp \
      $(LOCAL_BLUETOOTH_BLUEDROID)
  endif

  # -O3 flags and friends
  O3_FLAGS := \
    -O3 \
    -Wno-error=array-bounds \
    -Wno-error=strict-overflow
else
    OPT2:=
endif

# Extra SaberMod GCC loop flags.
export EXTRA_SABERMOD_GCC := \
         -ftree-loop-distribution \
         -ftree-loop-if-convert \
         -ftree-loop-im \
         -ftree-loop-ivcanon

EXTRA_SABERMOD_HOST_GCC := \
  -ftree-loop-distribution \
  -ftree-loop-if-convert \
  -ftree-loop-im \
  -ftree-loop-ivcanon

NO_OPTIMIZATIONS := $(LOCAL_BLUETOOTH_BLUEDROID)

ifeq ($(strip $(ENABLE_SABERMOD_ARM_MODE)),true)
  # SABERMOD_ARM_MODE
  # The LOCAL_COMPILERS_WHITELIST will allow modules that absolutely have to be complied with thumb instructions,
  # or the clang compiler, to skip replacing the default overrides.

  LOCAL_ARM_COMPILERS_WHITELIST_BASE := \
    libmincrypt \
    libc++abi \
    libjni_latinime_common_static \
    libcompiler_rt \
    libnativebridge \
    libc++ \
    libRSSupport \
    netd \
    libscrypt_static \
    libRSCpuRef \
    libRSDriver \
    $(LOCAL_BLUETOOTH_BLUEDROID)

  LOCAL_ARM64_COMPILERS_WHITELIST_BASE := \
    libc++abi \
    libcompiler_rt \
    libnativebridge \
    libjni_latinime_common_static \
    libRSSupport \
    libc++ \
    libRSCpuRef \
    netd \
    libRSDriver \
    libjpeg \
    $(LOCAL_BLUETOOTH_BLUEDROID)

  # Check if there's already something set somewhere.
  ifndef LOCAL_ARM_COMPILERS_WHITELIST
    LOCAL_ARM_COMPILERS_WHITELIST := \
      $(LOCAL_ARM_COMPILERS_WHITELIST_BASE)
  else
    LOCAL_ARM_COMPILERS_WHITELIST += \
      $(LOCAL_ARM_COMPILERS_WHITELIST_BASE)
  endif
  ifndef LOCAL_ARM64_COMPILERS_WHITELIST
    LOCAL_ARM64_COMPILERS_WHITELIST := \
      $(LOCAL_ARM64_COMPILERS_WHITELIST_BASE)
  else
    LOCAL_ARM64_COMPILERS_WHITELIST += \
      $(LOCAL_ARM64_COMPILERS_WHITELIST_BASE)
  endif
endif

# Enable some basic host gcc optimizations
# None that are cpu specific but arch is ok. It's already known that we are on linux-x86.
EXTRA_SABERMOD_HOST_GCC := \
  -march=x86-64 \
  -ftree-vectorize

# Extra SaberMod CLANG C flags
EXTRA_SABERMOD_CLANG := \
  -ftree-vectorize

# Check if there's already something set somewhere.
ifndef LOCAL_DISABLE_SABERMOD_GCC_VECTORIZE
  LOCAL_DISABLE_SABERMOD_GCC_VECTORIZE := $(LOCAL_BLUETOOTH_BLUEDROID)
else
  LOCAL_DISABLE_SABERMOD_GCC_VECTORIZE += $(LOCAL_BLUETOOTH_BLUEDROID)
endif

# Check if there's already something set somewhere.
ifndef LOCAL_DISABLE_SABERMOD_CLANG_VECTORIZE
  LOCAL_DISABLE_SABERMOD_CLANG_VECTORIZE := $(LOCAL_BLUETOOTH_BLUEDROID)
else
  LOCAL_DISABLE_SABERMOD_CLANG_VECTORIZE += $(LOCAL_BLUETOOTH_BLUEDROID)
endif

# Some flags are only available for certain gcc versions
export DISABLE_SANITIZE_LEAK := $(filter 4.8%,$(SM_AND))

OPT3 := (extra)
OPT6 := (memory-sanitizer)
OPT7 := (OpenMP)
OPT8 := (lto)
OPT9 := (floop-nest)

GCC_OPTIMIZATION_LEVELS := $(OPT1)$(OPT2)$(OPT3)$(OPT4)$(OPT5)$(OPT6)$(OPT7)$(OPT8)$(OPT9)
ifneq ($(GCC_OPTIMIZATION_LEVELS),)
  PRODUCT_PROPERTY_OVERRIDES += \
    ro.sm.flags=$(GCC_OPTIMIZATION_LEVELS)
endif
