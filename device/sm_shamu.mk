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

# Find host os
UNAME := $(shell uname -s)

ifeq ($(strip $(UNAME)),Linux)
  HOST_OS := linux
endif

# Only use these compilers on linux host.
ifeq ($(strip $(HOST_OS)),linux)

  # Sabermod configs
  TARGET_SM_KERNEL := 6.0
  SHAMU_THREADS := 4
  PRODUCT_THREADS := $(SHAMU_THREADS)
  ENABLE_STRICT_ALIASING := false
export LOCAL_O3 := true

GRAPHITE_KERNEL_FLAGS := \
    -floop-parallelize-all \
    -ftree-parallelize-loops=$(PRODUCT_THREADS) \
    -fopenmp
endif

# Extra SaberMod GCC C flags for arch target and Kernel
export EXTRA_SABERMOD_GCC_VECTORIZE := \
         -ftree-vectorize \
         -mvectorize-with-neon-quad

ifeq ($(strip $(ENABLE_STRICT_ALIASING)),true)

  # Check if something is already set in product/sm_products.mk
  ifndef LOCAL_DISABLE_STRICT_ALIASING
    LOCAL_DISABLE_STRICT_ALIASING := \
      libmmcamera_interface\
      camera.msm8084
  else
    LOCAL_DISABLE_STRICT_ALIASING += \
      libmmcamera_interface\
      camera.msm8084
  endif
endif

