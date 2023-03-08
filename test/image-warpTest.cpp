
#include <thread>
#include <unistd.h>

#include "WarpAffine.hpp"

void WarpNCNN_C4() {

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

    WarpAffine::warpaffine_bilinear_c4(src_data, src_width, src_height, src_width * 4, dst_data, dst_width, dst_height, dst_width * 4, image_matrix);

    delete [] dst_data;
    delete [] src_data;

    /**
     * when use NDK R25c enable asan with thread, raise an error
     * Device : xiaomi 13 T, Android-13
     */
    auto fun = []() {
        printf("test thread\n");
        usleep(0.5 * 1000 * 1000);
    };
    auto thread = std::thread(fun);
    thread.join();
}

int main() {

    WarpNCNN_C4();
    return 0;
}