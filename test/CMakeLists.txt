
file(GLOB SAMPLESOURCES
    *.cpp
)

add_executable(test ${SAMPLESOURCES})

install(TARGETS test
    RUNTIME
    DESTINATION "bin"
    BUNDLE DESTINATION "bin"
)
