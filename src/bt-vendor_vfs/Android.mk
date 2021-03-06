 #
# Copyright (C) 2011 Dynastream Innovations
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
ifneq ($(call is-qcom-hardware),)

include $(CLEAR_VARS)

LOCAL_CFLAGS := -g -c -W -Wall -O2

# needed to pull in the header file for libbt-vendor.so
BDROID_DIR:= system/bt
ifneq ($(BOARD_USES_QCOM_HARDWARE),true)
ifneq ($(filter msm8960 msm8909 msm8992 msm8994 msm8996 msm8998 sdm845,$(TARGET_BOARD_PLATFORM)),)
QCOM_DIR := hardware/qcom/bt/$(TARGET_BOARD_PLATFORM)/libbt-vendor
else
QCOM_DIR := hardware/qcom/bt-caf/libbt-vendor
endif
else
QCOM_DIR := hardware/qcom/bt-caf/libbt-vendor
endif

# Added hci/include to give access to the header for the libbt-vendorso interface.
LOCAL_C_INCLUDES := \
   $(LOCAL_PATH)/src/common/inc \
   $(LOCAL_PATH)/$(ANT_DIR)/inc \
   $(BDROID_DIR)/hci/include \
   $(QCOM_DIR)/include


ifeq ($(BOARD_ANT_WIRELESS_DEVICE),"qualcomm-uart")
LOCAL_C_INCLUDES += \
   $(LOCAL_PATH)/$(ANT_DIR)/qualcomm/uart

endif # BOARD_ANT_WIRELESS_DEVICE = "qualcomm-uart"

LOCAL_SRC_FILES := \
   $(COMMON_DIR)/ant_utils.c \
   $(ANT_DIR)/ant_native_chardev.c \
   $(ANT_DIR)/ant_rx_chardev.c

LOCAL_SRC_FILES += $(COMMON_DIR)/JAntNative.cpp


# JNI
LOCAL_C_INCLUDE += $(JNI_H_INCLUDE)

LOCAL_SHARED_LIBRARIES += \
   libnativehelper

# logging and dll loading
LOCAL_SHARED_LIBRARIES += \
   libcutils \
   libdl \
   liblog

LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libantradio

include $(BUILD_SHARED_LIBRARY)

endif
