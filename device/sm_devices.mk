# Copyright (C) 2015 The SaberMod Project
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

ifneq ($(filter flounder,$(TARGET_DEVICE)),)
  include $(SM_VENDOR)/device/sm_flounder.mk
  LOCAL_ARCH := arm64
endif

ifneq ($(filter hammerhead,$(TARGET_DEVICE)),)
  include $(SM_VENDOR)/device/sm_hammerhead.mk
  LOCAL_ARCH := arm
endif

ifneq ($(filter mako,$(TARGET_DEVICE)),)
  include $(SM_VENDOR)/device/sm_mako.mk
  LOCAL_ARCH := arm
endif

ifneq ($(filter shamu,$(TARGET_DEVICE)),)
  include $(SM_VENDOR)/device/sm_shamu.mk
  LOCAL_ARCH := arm
endif

ifneq ($(filter %hlte,$(TARGET_DEVICE)),)
  include $(SM_VENDOR)/device/sm_hlte.mk
  LOCAL_ARCH := arm
endif

ifneq ($(filter %hltespr,$(TARGET_DEVICE)),)
  include $(SM_VENDOR)/device/sm_hltespr.mk
  LOCAL_ARCH := arm
endif

ifneq ($(filter %hltetmo,$(TARGET_DEVICE)),)
  include $(SM_VENDOR)/device/sm_hltetmo.mk
  LOCAL_ARCH := arm
endif

ifneq ($(filter %hltevzw,$(TARGET_DEVICE)),)
  include $(SM_VENDOR)/device/sm_hltevzw.mk
  LOCAL_ARCH := arm
endif

ifneq ($(filter %togari,$(TARGET_DEVICE)),)
  include $(SM_VENDOR)/device/sm_togari.mk
  LOCAL_ARCH := arm
endif

ifneq ($(filter %trltespr,$(TARGET_DEVICE)),)
  include $(SM_VENDOR)/device/sm_trltespr.mk
  LOCAL_ARCH := arm
endif

ifneq ($(filter %trltetmo,$(TARGET_DEVICE)),)
  include $(SM_VENDOR)/device/sm_trltetmo.mk
  LOCAL_ARCH := arm
endif

ifneq ($(filter %trlteusc,$(TARGET_DEVICE)),)
  include $(SM_VENDOR)/device/sm_trlteusc.mk
  LOCAL_ARCH := arm
endif

ifneq ($(filter %trltexx,$(TARGET_DEVICE)),)
  include $(SM_VENDOR)/device/sm_trltexx.mk
  LOCAL_ARCH := arm
endif

# Kernel binary prefix.  The other part of this will go in the kernel sources Makefiles.
ifeq ($(strip $(LOCAL_ARCH)),arm)
export CROSS_COMPILE_NAME := arm-linux-gnueabi-
endif

ifeq ($(strip $(LOCAL_ARCH)),arm64)
export CROSS_COMPILE_NAME := aarch64-linux-gnu-
endif

