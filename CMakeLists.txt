cmake_minimum_required(VERSION 3.4.1)

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -std=c++11 -F/Library/Frameworks -pthread")

project(monero-flutter)

#############
# monero-cpp
#############

set(MONERO_CPP "${CMAKE_SOURCE_DIR}/external/monero-cpp")
message(STATUS MONERO_CPP : ${MONERO_CPP} : ${MONERO_CPP})

set(MONERO_CPP_SRC "${MONERO_CPP}/src")
set(MONERO_PROJECT ${MONERO_CPP}/external/monero-project)
set(MONERO_PROJECT_SRC "${MONERO_PROJECT}/src")

# monero-project header includes
include_directories("${MONERO_CPP}/external/libsodium/include/sodium")
include_directories("${MONERO_CPP}/external/openssl-sdk/include")
include_directories("${MONERO_CPP_SRC}/")
include_directories("${MONERO_PROJECT}/contrib/epee/include")
include_directories("${MONERO_PROJECT}/external/")
include_directories("${MONERO_PROJECT}/external/easylogging++")
include_directories("${MONERO_PROJECT}/external/rapidjson/include")
include_directories("${MONERO_PROJECT_SRC}/")
include_directories("${MONERO_PROJECT_SRC}/crypto")
include_directories("${MONERO_PROJECT_SRC}/crypto/crypto_ops_builder/include/")
include_directories("${MONERO_PROJECT_SRC}/wallet")
include_directories("${MONERO_PROJECT_SRC}/wallet/api")

list(APPEND EXTRA_LIBRARIES "-framework Foundation -framework IOKit -framework AppKit")
message(STATUS EXTRA_LIBRARIES: ${EXTRA_LIBRARIES})

############
# Boost
############

set(Boost_NO_BOOST_CMAKE 1)
set(Boost_USE_MULTITHREADED ON)
find_package(Boost 1.58 QUIET REQUIRED COMPONENTS chrono date_time filesystem program_options regex serialization wserialization system thread)
message(STATUS "Using Boost include dir at ${Boost_INCLUDE_DIR}")
include_directories(${Boost_INCLUDE_DIR})

############
# OpenSSL
############

if (APPLE AND NOT IOS)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=x86-64 -fvisibility=default -std=c++11")
  if (NOT OPENSSL_ROOT_DIR)
      EXECUTE_PROCESS(COMMAND brew --prefix openssl
        OUTPUT_VARIABLE OPENSSL_ROOT_DIR
        OUTPUT_STRIP_TRAILING_WHITESPACE)
    message(STATUS "Using OpenSSL found at ${OPENSSL_ROOT_DIR}")
  endif()
endif()

find_package(OpenSSL REQUIRED)
message(STATUS "Using OpenSSL include dir at ${OPENSSL_INCLUDE_DIR}")
include_directories(${OPENSSL_INCLUDE_DIR})

######################
# monero-cpp
######################

add_library(monero-cpp SHARED IMPORTED)

# import shared c++ library
set_target_properties(monero-cpp PROPERTIES IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/build/libmonero-cpp.dylib)

###############################################
# Build test app
###############################################

set(
    MONERO_APP_SRC_FILES
    ${CMAKE_SOURCE_DIR}/src/monero_app.cpp
    ${CMAKE_SOURCE_DIR}/src/monero_flutter.h
    ${CMAKE_SOURCE_DIR}/src/monero_flutter.cpp
)
add_executable(monero-app  ${MONERO_APP_SRC_FILES})

target_link_libraries(monero-app PUBLIC
    monero-cpp
    ${Boost_LIBRARIES}
    ${OPENSSL_LIBRARIES}
    ${EXTRA_LIBRARIES}
)

