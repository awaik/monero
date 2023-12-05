if (IOS)
    INCLUDE(CmakeLists_IOS.txt)
endif()

cmake_minimum_required(VERSION 3.4.1)

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -std=c++14 -F/Library/Frameworks -pthread")

project(MoneroFfiLibrary)

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

if(STATIC AND NOT IOS)
  if(UNIX)
    set(OPENSSL_LIBRARIES "${OPENSSL_LIBRARIES};${CMAKE_DL_LIBS};${CMAKE_THREAD_LIBS_INIT}")
  endif()
endif()

############
# libsodium
############

find_library(SODIUM_LIBRARY sodium REQUIRED)
message(STATUS "Using libsodium library at ${SODIUM_LIBRARY}")

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

find_library(UNBOUND_LIB unbound)

########################
# Iconv library
########################

find_library(ICONV_LIB iconv)

#############
# Monero
#############

add_library(wallet STATIC IMPORTED)
#add_library(wallet_crypto_lib STATIC IMPORTED)
add_library(lmdb STATIC IMPORTED)
add_library(epee STATIC IMPORTED)
add_library(rpc_base STATIC IMPORTED)
add_library(net STATIC IMPORTED)
add_library(hardforks STATIC IMPORTED)
add_library(easylogging STATIC IMPORTED)
add_library(cryptonote_core STATIC IMPORTED)
add_library(cryptonote_protocol STATIC IMPORTED)
add_library(cryptonote_basic STATIC IMPORTED)
add_library(cryptonote_format_utils_basic STATIC IMPORTED)
add_library(mnemonics STATIC IMPORTED)
add_library(common STATIC IMPORTED)
add_library(cncrypto STATIC IMPORTED)
add_library(ringct STATIC IMPORTED)
add_library(ringct_basic STATIC IMPORTED)
add_library(blockchain_db STATIC IMPORTED)
add_library(blocks STATIC IMPORTED)
add_library(checkpoints STATIC IMPORTED)
add_library(device STATIC IMPORTED)
add_library(device_trezor STATIC IMPORTED)
add_library(multisig STATIC IMPORTED)
add_library(version STATIC IMPORTED)
add_library(randomx STATIC IMPORTED)

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

target_link_libraries(monero-cpp
  wallet
  rpc_base
  net
  lmdb
  unbound
  easylogging
  cryptonote_core
  cryptonote_protocol
  cryptonote_basic
  cryptonote_format_utils_basic
  mnemonics
  ringct
  ringct_basic
  common
  cncrypto
  blockchain_db
  blocks
  checkpoints
  device
  device_trezor
  multisig
  version
  randomx
  epee
  hardforks
  cncrypto
  
  ${UNBOUND_LIB}
  ${Boost_LIBRARIES}
  ${Protobuf_LIBRARY}
  ${LibUSB_LIBRARIES}
  ${OPENSSL_LIBRARIES}
  ${SODIUM_LIBRARY}
  ${HIDAPI_LIBRARIES}
  ${EXTRA_LIBRARIES}
	
  ${ICONV_LIB}
)

set(
    MONEROFFI_SRC_FILES
    ${MONERO_FFI_SRC}/ffi_utils.cpp
    ${MONERO_FFI_SRC}/wallet_listener.cpp
    ${MONERO_FFI_SRC}/extended_monero_wallet.cpp
    ${MONERO_FFI_SRC}/monero_ffi.cpp
)

add_library(monero-ffi SHARED ${MONEROFFI_SRC_FILES})

target_link_libraries(monero-ffi
  monero-cpp
)