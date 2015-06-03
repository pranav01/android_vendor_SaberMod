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
ifneq ($(filter %slimremix_hlte,$(TARGET_PRODUCT)),)
  TARGET_DEVICE := slimremix_hlte
endif

ifneq ($(filter %slimremix_hltespr,$(TARGET_PRODUCT)),)
  TARGET_DEVICE := slimremix_hltespr
endif

ifneq ($(filter %slimremix_hltetmo,$(TARGET_PRODUCT)),)
  TARGET_DEVICE := slimremix_hltetmo
endif

ifneq ($(filter %slimremix_hltevzw,$(TARGET_PRODUCT)),)
  TARGET_DEVICE := slimremix_hltevzw
endif

ifneq ($(filter %slimremix_togari,$(TARGET_PRODUCT)),)
  TARGET_DEVICE := slimremix_togari
endif

ifneq ($(filter %slimremix_trltespr,$(TARGET_PRODUCT)),)
  TARGET_DEVICE := slimremix_trltespr
endif

ifneq ($(filter %slimremix_trltetmo,$(TARGET_PRODUCT)),)
  TARGET_DEVICE := slimremix_trltetmo
endif

ifneq ($(filter %slimremix_trlteusc,$(TARGET_PRODUCT)),)
  TARGET_DEVICE := slimremix_trlteusc
endif

ifneq ($(filter %slimremix_trltexx,$(TARGET_PRODUCT)),)
  TARGET_DEVICE := slimremix_trltexx
endif
