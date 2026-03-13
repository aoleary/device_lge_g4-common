#define LOG_TAG "sensors_shim"

#include <dlfcn.h>
#include <errno.h>
#include <cstring>

#include <hardware/hardware.h>
#include <hardware/sensors.h>
#include <log/log.h>

extern "C" __attribute__((visibility("default"))) sensors_module_t HAL_MODULE_INFO_SYM;

namespace {

#if defined(__LP64__)
static const char* kRealHalPaths[] = {
    "/system/lib64/hw/sensors.msm8992.real.so",
};
#else
static const char* kRealHalPaths[] = {
    "/system/lib/hw/sensors.msm8992.real.so",
};
#endif

static const sensors_module_t* gRealModule = nullptr;
static const sensor_t* gSensorList = nullptr;
static int gSensorCount = 0;
static float gProxMaxRange = 5.0f;
static int gProxHandle = -1;

static int load_real_module() {
    if (gRealModule != nullptr) {
        return 0;
    }

    for (const char* path : kRealHalPaths) {
        void* handle = dlopen(path, RTLD_NOW);
        if (!handle) {
            continue;
        }

        void* sym = dlsym(handle, HAL_MODULE_INFO_SYM_AS_STR);
        if (!sym) {
            dlclose(handle);
            continue;
        }

        gRealModule = reinterpret_cast<const sensors_module_t*>(sym);
        return 0;
    }

    ALOGE("failed to load real sensors HAL");
    return -ENOENT;
}

static void cache_proximity_info() {
    if (gSensorList == nullptr || gSensorCount <= 0) {
        return;
    }

    for (int i = 0; i < gSensorCount; ++i) {
        if (gSensorList[i].type != SENSOR_TYPE_PROXIMITY) {
            continue;
        }

        gProxHandle = gSensorList[i].handle;

        const float rawMax = gSensorList[i].maxRange;
        if (rawMax > 5.0f) {
            gProxMaxRange = rawMax;
        } else {
            gProxMaxRange = 5.1f;
        }

        ALOGI("proximity shim active: handle=%d far=%f",
              gProxHandle, gProxMaxRange);
			  
        return;
    }
}

static int shim_get_sensors_list(struct sensors_module_t* module,
                                 struct sensor_t const** list) {
    (void)module;

    const int ret = load_real_module();
    if (ret != 0) {
        return ret;
    }

    if (!gRealModule->get_sensors_list) {
        ALOGE("real sensors HAL missing get_sensors_list");
        return -EINVAL;
    }

    const int list_ret =
            gRealModule->get_sensors_list(const_cast<sensors_module_t*>(gRealModule), list);

    if (list_ret > 0 && list && *list) {
        gSensorList = *list;
        gSensorCount = list_ret;
        cache_proximity_info();
    }

    return list_ret;
}

static int shim_set_operation_mode(unsigned int mode) {
    const int ret = load_real_module();
    if (ret != 0) {
        return ret;
    }

    if (!gRealModule->set_operation_mode) {
        return 0;
    }

    return gRealModule->set_operation_mode(mode);
}

struct sensors_poll_context_t {
    sensors_poll_device_1_t shim_dev;
    sensors_poll_device_1_t* real_dev;
    float prox_max_range;
    int prox_handle;
};

static sensors_poll_context_t* get_ctx_from_poll_dev(sensors_poll_device_t* dev) {
    return reinterpret_cast<sensors_poll_context_t*>(dev);
}

static sensors_poll_context_t* get_ctx_from_poll_dev1(sensors_poll_device_1_t* dev) {
    return reinterpret_cast<sensors_poll_context_t*>(dev);
}

static int shim_activate(struct sensors_poll_device_t* dev, int handle, int enabled) {
    auto* ctx = get_ctx_from_poll_dev(dev);
    if (!ctx || !ctx->real_dev || !ctx->real_dev->activate) {
        ALOGE("activate invalid ctx/dev");
        return -EINVAL;
    }

    return ctx->real_dev->activate(
            reinterpret_cast<sensors_poll_device_t*>(ctx->real_dev), handle, enabled);
}

static int shim_set_delay(struct sensors_poll_device_t* dev, int handle, int64_t ns) {
    auto* ctx = get_ctx_from_poll_dev(dev);
    if (!ctx || !ctx->real_dev || !ctx->real_dev->setDelay) {
        ALOGE("setDelay invalid ctx/dev");
        return -EINVAL;
    }

    return ctx->real_dev->setDelay(
            reinterpret_cast<sensors_poll_device_t*>(ctx->real_dev), handle, ns);
}

static int shim_batch(sensors_poll_device_1_t* dev,
                      int handle, int flags, int64_t period_ns, int64_t timeout_ns) {
    auto* ctx = get_ctx_from_poll_dev1(dev);
    if (!ctx || !ctx->real_dev || !ctx->real_dev->batch) {
        ALOGE("batch invalid ctx/dev");
        return -EINVAL;
    }

    return ctx->real_dev->batch(ctx->real_dev, handle, flags, period_ns, timeout_ns);
}

static int shim_flush(sensors_poll_device_1_t* dev, int handle) {
    auto* ctx = get_ctx_from_poll_dev1(dev);
    if (!ctx || !ctx->real_dev || !ctx->real_dev->flush) {
        ALOGE("flush invalid ctx/dev");
        return -EINVAL;
    }

    return ctx->real_dev->flush(ctx->real_dev, handle);
}

static int shim_poll(struct sensors_poll_device_t* dev, sensors_event_t* data, int count) {
    auto* ctx = get_ctx_from_poll_dev(dev);
    if (!ctx || !ctx->real_dev || !ctx->real_dev->poll) {
        ALOGE("shim_poll invalid ctx/dev");
        return -EINVAL;
    }

    if (ctx->prox_handle < 0 && gProxHandle >= 0) {
        ctx->prox_handle = gProxHandle;
        ctx->prox_max_range = gProxMaxRange;
    }

    const int ret = ctx->real_dev->poll(
            reinterpret_cast<sensors_poll_device_t*>(ctx->real_dev), data, count);

    if (ret <= 0 || data == nullptr) {
        return ret;
    }

    const float prox_max =
            (ctx->prox_max_range > 0.0f) ? ctx->prox_max_range :
            ((gProxMaxRange > 0.0f) ? gProxMaxRange : 5.1f);

    for (int i = 0; i < ret; ++i) {
        const bool is_prox =
                (data[i].type == SENSOR_TYPE_PROXIMITY) ||
                (ctx->prox_handle >= 0 && data[i].sensor == ctx->prox_handle) ||
                (gProxHandle >= 0 && data[i].sensor == gProxHandle);

        if (!is_prox) {
            continue;
        }

        const float raw = data[i].distance;
        float rewritten = raw;

#if FORCE_PROX_NEAR_TEST
        rewritten = 0.0f;
#else
        if (raw <= 0.0f) {
            rewritten = 0.0f;
        } else {
            rewritten = prox_max;
        }
#endif

        if (rewritten != raw) {
            data[i].distance = rewritten;
            data[i].data[0] = rewritten;
            data[i].data[1] = 0.0f;
            data[i].data[2] = 0.0f;
        }
    }

    return ret;
}

static int shim_close(hw_device_t* device) {
    if (!device) {
        return -EINVAL;
    }

    auto* ctx = reinterpret_cast<sensors_poll_context_t*>(device);
    int ret = 0;

    if (ctx->real_dev && ctx->real_dev->common.close) {
        ret = ctx->real_dev->common.close(reinterpret_cast<hw_device_t*>(ctx->real_dev));
    }

    delete ctx;
    return ret;
}

static int shim_open(const struct hw_module_t* module,
                     const char* id,
                     struct hw_device_t** device) {
    (void)module;

    if (!device) {
        return -EINVAL;
    }

    int ret = load_real_module();
    if (ret != 0) {
        return ret;
    }

    if (!gRealModule->common.methods || !gRealModule->common.methods->open) {
        ALOGE("real sensors HAL has no open method");
        return -EINVAL;
    }

    hw_device_t* real_hw_dev = nullptr;
    ret = gRealModule->common.methods->open(&gRealModule->common, id, &real_hw_dev);
    if (ret != 0 || !real_hw_dev) {
        ALOGE("real sensors HAL open failed");
        return ret != 0 ? ret : -EINVAL;
    }

    auto* real_dev = reinterpret_cast<sensors_poll_device_1_t*>(real_hw_dev);
    auto* ctx = new sensors_poll_context_t();
    std::memset(ctx, 0, sizeof(*ctx));

    ctx->real_dev = real_dev;
    ctx->prox_handle = gProxHandle;
    ctx->prox_max_range = gProxMaxRange;

    ctx->shim_dev.common.tag = real_dev->common.tag;
    ctx->shim_dev.common.version = real_dev->common.version;
    ctx->shim_dev.common.module = &HAL_MODULE_INFO_SYM.common;
    ctx->shim_dev.common.close = shim_close;

    ctx->shim_dev.activate = shim_activate;
    ctx->shim_dev.setDelay = shim_set_delay;
    ctx->shim_dev.poll = shim_poll;
    ctx->shim_dev.batch = shim_batch;
    ctx->shim_dev.flush = shim_flush;

    *device = reinterpret_cast<hw_device_t*>(&ctx->shim_dev);
    return 0;
}

static hw_module_methods_t gShimMethods = {
    .open = shim_open,
};

}  // namespace

extern "C" __attribute__((visibility("default")))
sensors_module_t HAL_MODULE_INFO_SYM = {
    .common = {
        .tag = HARDWARE_MODULE_TAG,
        .module_api_version = SENSORS_MODULE_API_VERSION_0_1,
        .hal_api_version = HARDWARE_HAL_API_VERSION,
        .id = SENSORS_HARDWARE_MODULE_ID,
        .name = "LG G4 Sensors HAL Forwarder Shim",
        .author = "OpenAI",
        .methods = &gShimMethods,
        .dso = nullptr,
        .reserved = {0},
    },
    .get_sensors_list = shim_get_sensors_list,
    .set_operation_mode = shim_set_operation_mode,
};
