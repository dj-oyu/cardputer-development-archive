/* QEMU 9.2.2 lacks S3 PIE. Source-local scalar render fallback only. */
#include "sdkconfig.h"
#undef CONFIG_IDF_TARGET_ESP32S3
