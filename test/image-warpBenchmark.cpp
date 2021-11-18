
#include <benchmark/benchmark.h>

#include "WarpAffine.hpp"

static void BM_WarpNCNN_C4(benchmark::State& state) {

    constexpr int src_width = 1080;
    constexpr int src_height = 1440;
    constexpr int dst_width = 160;
    constexpr int dst_height = 160;
    constexpr float image_matrix[6] = {
            -0.00673565036, 0.146258384,    4.34562492,
            -0.146258384,   -0.00673565036, 162.753372,
    };

    unsigned char *src_data = new unsigned char[src_width * src_height * 4]();
    unsigned char *dst_data = new unsigned char[dst_width * dst_height * 4]();

    // Perform setup here
    for (auto _ : state) {
        WarpAffine::warpaffine_bilinear_c4(src_data, src_width, src_height, src_width * 4, dst_data, dst_width, dst_height, dst_width * 4, image_matrix);
    }

    delete [] dst_data;
    delete [] src_data;
}

BENCHMARK(BM_WarpNCNN_C4)->Unit(benchmark::kMillisecond)->Iterations(10);

// Run the benchmark
BENCHMARK_MAIN();