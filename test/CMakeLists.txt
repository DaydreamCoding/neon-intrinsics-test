
file(GLOB SAMPLESOURCES
    *.cpp
)

add_executable(test ${SAMPLESOURCES})

target_link_libraries(test
    PRIVATE
    benchmark::benchmark
)

install(TARGETS test
    RUNTIME
    DESTINATION "bin"
    BUNDLE DESTINATION "bin"
)