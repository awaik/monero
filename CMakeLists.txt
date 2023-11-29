if (IOS)
    INCLUDE(CmakeLists_IOS.txt)
endif()

cmake_minimum_required(VERSION 3.4.1)

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -std=c++14 -pthread")

project(MoneroCppLibrary)

#####################
# all
#####################

include_directories( "${CMAKE_SOURCE_DIR}/build/include")
file(GLOB_RECURSE EXTERNAL_LIB_FILES "${CMAKE_SOURCE_DIR}/build/lib/*.a")

# Boost
############

#set(Boost_NO_SYSTEM_PATHS TRUE)
#set(Boost_NO_BOOST_CMAKE 1)
#set(Boost_USE_MULTITHREADED ON)
#set(BOOST_ROOT "${CMAKE_SOURCE_DIR}/build/boost")
#
#find_package(Boost QUIET REQUIRED COMPONENTS random regex graph random chrono thread filesystem system date_time locale serialization program_options)
#
#message(STATUS "Using Boost include dir at ${Boost_INCLUDE_DIR}, lib dir at ${Boost_LIBRARIES}")
#include_directories(${Boost_INCLUDE_DIRS})

#####################
# monero-cpp
#####################

set(MONERO_CPP_SRC "${CMAKE_SOURCE_DIR}/src")

# headers
include_directories("${MONERO_CPP_SRC}")

##################
# monero-project
##################

set(MONERO_PROJECT "${CMAKE_SOURCE_DIR}/external/monero-project")
set(MONERO_PROJECT_SRC "${MONERO_PROJECT}/src")

# headers
include_directories("${MONERO_PROJECT_SRC}/")
include_directories("${MONERO_PROJECT_SRC}/checkpoints")
include_directories("${MONERO_PROJECT_SRC}/common")
include_directories("${MONERO_PROJECT_SRC}/cryptonote_basic")

include_directories("${MONERO_PROJECT}/external/")
include_directories("${MONERO_PROJECT}/external/easylogging++")
include_directories("${MONERO_PROJECT}/external/rapidjson/include")
include_directories("${MONERO_PROJECT}/external/unbound/libunbound")
include_directories("${MONERO_PROJECT}/external/db_drivers/liblmdb")

include_directories("${MONERO_PROJECT}/contrib/epee/include")
include_directories("${MONERO_PROJECT}/contrib/epee/include/net")

include_directories("${MONERO_PROJECT}/build/release/translations")
include_directories("${MONERO_PROJECT}/build/release/generated_include")
    
########################
# iconv library
########################

find_library(ICONV_LIB iconv)


set(
    LIBRARY_SRC_FILES
    ${MONERO_CPP_SRC}/utils/gen_utils.cpp
    ${MONERO_CPP_SRC}/utils/monero_utils.cpp
    ${MONERO_CPP_SRC}/daemon/monero_daemon_model.cpp
    ${MONERO_CPP_SRC}/daemon/monero_daemon.cpp
    ${MONERO_CPP_SRC}/wallet/monero_wallet_model.cpp
    ${MONERO_CPP_SRC}/wallet/monero_wallet_keys.cpp
    ${MONERO_CPP_SRC}/wallet/monero_wallet_full.cpp
)

add_library(monerocpp SHARED ${LIBRARY_SRC_FILES})

target_link_libraries(monerocpp
	${EXTERNAL_LIB_FILES}
	${ICONV_LIB}
#	${Boost_LIBRARIES}
)