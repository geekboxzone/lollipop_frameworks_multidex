# Copyright (C) 2013 The Android Open Source Project
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

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := android-support-multidex
LOCAL_SDK_VERSION := 4
LOCAL_SRC_FILES := $(call all-java-files-under, src)

ifneq "" "$(filter eng.%,$(BUILD_NUMBER))"
  ASMD_VERSION_NAME_TAG := eng.$(USER)
else
  ASMD_VERSION_NAME_TAG := $(BUILD_NUMBER)
endif

ASMD_GIT_VERSION_TAG := `cd $(LOCAL_PATH); git log --format="%H" -n 1`

ASMD_VERSION_INTERMEDIATE = $(call intermediates-dir-for,JAVA_LIBRARIES,$(LOCAL_MODULE),,COMMON)/$(LOCAL_MODULE).version.txt
$(ASMD_VERSION_INTERMEDIATE):
	$(hide) mkdir -p $(dir $@)
	$(hide) echo "build.version=$(ASMD_VERSION_NAME_TAG)" > $@
	$(hide) echo "build.id=$(BUILD_ID)" >> $@
	$(hide) echo "git.version=$(ASMD_GIT_VERSION_TAG)" >> $@

LOCAL_JAVA_RESOURCE_FILES := $(ASMD_VERSION_INTERMEDIATE)

# Use a dir because we have files in subfolders and we want to keep the path into the archive
#
# use "resources" instead of "res" because res is already used for packaging the SDK project
LOCAL_JAVA_RESOURCE_DIRS := resources

include $(BUILD_STATIC_JAVA_LIBRARY)
