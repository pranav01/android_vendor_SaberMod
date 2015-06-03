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

# Filter device
ifneq ($(filter %flounder,$(TARGET_PRODUCT)),)
  TARGET_DEVICE := flounder
endif

ifneq ($(filter %hammerhead,$(TARGET_PRODUCT)),)
  TARGET_DEVICE := hammerhead
endif

ifneq ($(filter %mako,$(TARGET_PRODUCT)),)
  TARGET_DEVICE := mako
endif

ifneq ($(filter %shamu,$(TARGET_PRODUCT)),)
  TARGET_DEVICE := shamu
endif

# Filter ROM base
ifneq ($(filter aosp% boostpop% pa% twisted% benzo%,$(TARGET_PRODUCT)),)
  TARGET_BASE_ROM := aosp
  include $(SM_VENDOR)/product/aosp_product.mk
endif

ifneq ($(filter slim% aicp% cm%,$(TARGET_PRODUCT)),)
  TARGET_BASE_ROM := cm
  include $(SM_VENDOR)/product/cm_product.mk
endif

ifneq ($(filter slimremix%,$(TARGET_PRODUCT)),)
  TARGET_BASE_ROM := slimremix
  include $(SM_VENDOR)/product/slimremix_product.mk
endif

ifneq ($(filter cmremix%,$(TARGET_PRODUCT)),)
  TARGET_BASE_ROM := cmremix
  include $(SM_VENDOR)/product/cmremix_product.mk
endif

# General ROM strings

# -O3 disabled by default.  To enable it change here to := true,
# or enable in vendor/sm/device/sm_device.mk
export LOCAL_O3 := true
