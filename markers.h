#pragma once

#ifdef __cplusplus
#include <chrono>
#include <string>
#include <unordered_map>
#include <iostream>

namespace Razix {
namespace Time {

// Map to store timing results for debug/visualization
inline std::unordered_map<std::string, double> gTimings;

#define RAZIX_TIME_STAMP_BEGIN(name)                             \
    const std::string __key__ = name;                            \
    auto __start__ = std::chrono::high_resolution_clock::now();

#define RAZIX_TIME_STAMP_END()                                                   \
    do {                                                                         \
        auto __stop__ = std::chrono::high_resolution_clock::now();               \
        std::chrono::duration<double, std::milli> __ms__ = (__stop__ - __start__); \
        Razix::Time::gTimings[__key__] = __ms__.count();                        \
        std::cout << __key__ << ": " << __ms__.count() << " ms\n";               \
    } while(0)

} // namespace Time
} // namespace Razix

#else // C fallback

#include <time.h>
#include <stdio.h>

#define RAZIX_TIME_STAMP_BEGIN(name) \
    clock_t __start__ = clock();

#define RAZIX_TIME_STAMP_END()                                                   \
    do {                                                                         \
        clock_t __stop__ = clock();                                              \
        double __ms__ = ((double)(__stop__ - __start__) / CLOCKS_PER_SEC) * 1000; \
        printf("Timing: %.3f ms\n", __ms__);                                     \
    } while(0)

#endif

