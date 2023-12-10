if (IOS)
    INCLUDE(CmakeLists_IOS.txt)
endif()

cmake_minimum_required(VERSION 3.4.1)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -std=c++14 -F/Library/Frameworks -pthread")

project(monero-ffi)

#####################
# monero-ffi
#####################

set(MONERO_FFI_SRC "${CMAKE_SOURCE_DIR}/src")

#####################
# monero-cpp
#####################

set(MONERO_CPP "${CMAKE_SOURCE_DIR}/external/monero-cpp")
set(MONERO_CPP_SRC "${MONERO_CPP}/src")

include_directories("${MONERO_CPP_SRC}")
include_directories("${MONERO_CPP}/external/libsodium/include/sodium")

##################
# monero-project
##################

set(MONERO_PROJECT "${MONERO_CPP}/external/monero-project")
set(MONERO_PROJECT_SRC "${MONERO_PROJECT}/src")

# headers
include_directories("${MONERO_PROJECT}/contrib/epee/include")

include_directories("${MONERO_PROJECT}/external/")
include_directories("${MONERO_PROJECT}/external/easylogging++")
include_directories("${MONERO_PROJECT}/external/rapidjson/include")

include_directories("${MONERO_PROJECT_SRC}/")
include_directories("${MONERO_PROJECT_SRC}/wallet")
include_directories("${MONERO_PROJECT_SRC}/wallet/api")
include_directories("${MONERO_PROJECT_SRC}/hardforks")
include_directories("${MONERO_PROJECT_SRC}/crypto/crypto_ops_builder/include/")

####################
# Extra libraries
####################

if (APPLE)
  if (DEPENDS)
    list(APPEND EXTRA_LIBRARIES "-framework Foundation -framework IOKit -framework AppKit")
  else()
    find_library(COREFOUNDATION CoreFoundation)
    find_library(IOKIT IOKit)
    find_library(APPKIT AppKit)
    list(APPEND EXTRA_LIBRARIES ${IOKIT})
    list(APPEND EXTRA_LIBRARIES ${COREFOUNDATION})
    list(APPEND EXTRA_LIBRARIES ${APPKIT})
  endif()
endif()
if (WIN32)
  list(APPEND EXTRA_LIBRARIES setupapi)
endif()

message(STATUS EXTRA_LIBRARIES: ${EXTRA_LIBRARIES})

############
# LibUSB
############

find_library(usb_LIBRARY NAMES usb-1.0 libusb usb)
set(LibUSB_LIBRARIES ${usb_LIBRARY})

############
# Boost
############

set(Boost_NO_BOOST_CMAKE 1)
set(Boost_USE_MULTITHREADED ON)
find_package(Boost 1.72 QUIET REQUIRED COMPONENTS chrono date_time filesystem program_options regex serialization wserialization system thread)
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

if(STATIC AND NOT IOS)
  if(UNIX)
    set(OPENSSL_LIBRARIES "${OPENSSL_LIBRARIES};${CMAKE_DL_LIBS};${CMAKE_THREAD_LIBS_INIT}")
  endif()
endif()

############
# libsodium
############

find_library(SODIUM_LIBRARY sodium REQUIRED)

############
# HIDAPI
############

if(APPLE)
  include_directories(SYSTEM /usr/include/malloc)
  if(POLICY CMP0042)
    cmake_policy(SET CMP0042 NEW)
  endif()
endif()

if (HIDAPI_FOUND) 
  find_package(HIDAPI)
  message(STATUS "Using HIDAPI include dir at ${HIDAPI_INCLUDE_DIR}")
  add_definitions(-DHAVE_HIDAPI)
  include_directories(${HIDAPI_INCLUDE_DIR})
else()
  message(STATUS "Could not find HIDAPI")
endif()

#############
# Unbound
#############

find_library(UNBOUND_LIBRARY unbound)

#############
# Expat
#############

find_library(EXPAT_LIBRARY expat)

#############
# zmq
#############

find_library(ZMQ_LIBRARY zmq)

########################
# Iconv library
########################

find_library(ICONV_LIBRARY iconv)

#############
# Monero
#############

find_library(BLOCKCHAIN_DB_LIBRARY blockchain_db)
find_library(BLOCKS_LIBRARY blocks)
find_library(CHECKPOINTS_LIBRARY checkpoints)
find_library(CNCRYPTO_LIBRARY cncrypto)
find_library(COMMON_LIBRARY common)
find_library(CRYPTONOTE_BASIC_LIBRARY cryptonote_basic)
find_library(CRYPTONOTE_CORE_LIBRARY cryptonote_core)
find_library(CRYPTONOTE_FORMAT_UTILS_BASIC_LIBRARY cryptonote_format_utils_basic)
find_library(DEVICE_LIBRARY device)
find_library(DEVICE_TREZOR_LIBRARY device_trezor)
find_library(EASYLOGGING_LIBRARY easylogging)
find_library(EPEE_LIBRARY epee)
find_library(HARDFORKS_LIBRARY hardforks)
find_library(LMDB_LIBRARY lmdb)
find_library(MNEMONICS_LIBRARY mnemonics)
find_library(MULTISIG_LIBRARY multisig)
find_library(NET_LIBRARY net)
find_library(RANDOMX_LIBRARY randomx)
find_library(RINGCT_LIBRARY ringct)
find_library(RINGCT_BASIC_LIBRARY ringct_basic)
find_library(RPC_BASE_LIBRARY rpc_base)
find_library(VERSION_LIBRARY version)
find_library(WALLET_LIBRARY wallet)
find_library(WALLET_API_LIBRARY wallet_api)

########################
# monero-cpp
########################

set(
    MONEROCPP_SRC_FILES
    ${MONERO_CPP_SRC}/utils/gen_utils.cpp
    ${MONERO_CPP_SRC}/utils/monero_utils.cpp
    ${MONERO_CPP_SRC}/daemon/monero_daemon_model.cpp
    ${MONERO_CPP_SRC}/daemon/monero_daemon.cpp
    ${MONERO_CPP_SRC}/wallet/monero_wallet_model.cpp
    ${MONERO_CPP_SRC}/wallet/monero_wallet_keys.cpp
    ${MONERO_CPP_SRC}/wallet/monero_wallet_full.cpp
)

add_library(monero-cpp ${MONEROCPP_SRC_FILES})

if (APPLE AND IOS)
  target_link_libraries(monero-cpp
    PUBLIC
    ${Boost_LIBRARIES}
    ${OPENSSL_LIBRARIES}
    
    ${SODIUM_LIBRARY}
    ${UNBOUND_LIBRARY}
    ${EXPAT_LIBRARY}
    ${ZMQ_LIBRARY}
    ${ICONV_LIBRARY}
    
    ${BLOCKCHAIN_DB_LIBRARY}
    ${BLOCKS_LIBRARY}
    ${CHECKPOINTS_LIBRARY}
    ${CNCRYPTO_LIBRARY}
    ${COMMON_LIBRARY}
    ${CRYPTONOTE_BASIC_LIBRARY}
    ${CRYPTONOTE_CORE_LIBRARY}
    ${CRYPTONOTE_FORMAT_UTILS_BASIC_LIBRARY}
    ${DEVICE_LIBRARY}
    ${DEVICE_TREZOR_LIBRARY}
    ${EASYLOGGING_LIBRARY}
    ${EPEE_LIBRARY}
    ${HARDFORKS_LIBRARY}
    ${LMDB_LIBRARY}
    ${MNEMONICS_LIBRARY}
    ${MULTISIG_LIBRARY}
    ${NET_LIBRARY}
    ${RANDOMX_LIBRARY}
    ${RINGCT_LIBRARY}
    ${RINGCT_BASIC_LIBRARY}
    ${RPC_BASE_LIBRARY}
    ${VERSION_LIBRARY}
    ${WALLET_LIBRARY}
    ${WALLET_API_LIBRARY}
  )
else()
  target_link_libraries(monero-cpp
    PUBLIC
    ${Boost_LIBRARIES}
    ${OPENSSL_LIBRARIES}
    
    ${SODIUM_LIBRARY}
    ${UNBOUND_LIBRARY}
    ${EXPAT_LIBRARY}
    ${ZMQ_LIBRARY}
    ${ICONV_LIBRARY}
    
    ${BLOCKCHAIN_DB_LIBRARY}
    ${BLOCKS_LIBRARY}
    ${CHECKPOINTS_LIBRARY}
    ${CNCRYPTO_LIBRARY}
    ${COMMON_LIBRARY}
    ${CRYPTONOTE_BASIC_LIBRARY}
    ${CRYPTONOTE_CORE_LIBRARY}
    ${CRYPTONOTE_FORMAT_UTILS_BASIC_LIBRARY}
    ${DEVICE_LIBRARY}
    ${DEVICE_TREZOR_LIBRARY}
    ${EASYLOGGING_LIBRARY}
    ${EPEE_LIBRARY}
    ${HARDFORKS_LIBRARY}
    ${LMDB_LIBRARY}
    ${MNEMONICS_LIBRARY}
    ${MULTISIG_LIBRARY}
    ${NET_LIBRARY}
    ${RANDOMX_LIBRARY}
    ${RINGCT_LIBRARY}
    ${RINGCT_BASIC_LIBRARY}
    ${RPC_BASE_LIBRARY}
    ${VERSION_LIBRARY}
    ${WALLET_LIBRARY}
    ${WALLET_API_LIBRARY}
  )
endif()

set(
    MONEROFFI_SRC_FILES
    ${MONERO_FFI_SRC}/ffi_utils.cpp
    ${MONERO_FFI_SRC}/wallet_listener.cpp
    ${MONERO_FFI_SRC}/extended_monero_wallet.cpp
    ${MONERO_FFI_SRC}/monero_ffi.cpp
)

add_library(monero-ffi SHARED ${MONEROFFI_SRC_FILES})

target_link_libraries(monero-ffi
  PUBLIC
  monero-cpp
    
  ${Boost_LIBRARIES}
  ${OPENSSL_LIBRARIES}
  
  ${SODIUM_LIBRARY}
  ${UNBOUND_LIBRARY}
  ${EXPAT_LIBRARY}
  ${ZMQ_LIBRARY}
  ${ICONV_LIBRARY}
  
  ${BLOCKCHAIN_DB_LIBRARY}
  ${BLOCKS_LIBRARY}
  ${CHECKPOINTS_LIBRARY}
  ${CNCRYPTO_LIBRARY}
  ${COMMON_LIBRARY}
  ${CRYPTONOTE_BASIC_LIBRARY}
  ${CRYPTONOTE_CORE_LIBRARY}
  ${CRYPTONOTE_FORMAT_UTILS_BASIC_LIBRARY}
  ${DEVICE_LIBRARY}
  ${DEVICE_TREZOR_LIBRARY}
  ${EASYLOGGING_LIBRARY}
  ${EPEE_LIBRARY}
  ${HARDFORKS_LIBRARY}
  ${LMDB_LIBRARY}
  ${MNEMONICS_LIBRARY}
  ${MULTISIG_LIBRARY}
  ${NET_LIBRARY}
  ${RANDOMX_LIBRARY}
  ${RINGCT_LIBRARY}
  ${RINGCT_BASIC_LIBRARY}
  ${RPC_BASE_LIBRARY}
  ${VERSION_LIBRARY}
  ${WALLET_LIBRARY}
  ${WALLET_API_LIBRARY}
)