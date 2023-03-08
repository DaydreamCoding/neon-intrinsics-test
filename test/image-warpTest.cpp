
#include <thread>
#include <unistd.h>

int main() {

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

    return 0;
}