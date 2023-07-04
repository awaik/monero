set(utils_sources
  gen_utils.cpp
  monero_utils.cpp
  )

set(utils_headers)

monero_find_all_headers(utils_private_headers "${CMAKE_CURRENT_SOURCE_DIR}")

monero_private_headers(utils
  ${crypto_private_headers})

monero_add_library(utils
  ${utils_sources}
  ${utils_headers}
  ${utils_private_headers})

target_link_libraries(utils
  PUBLIC
    # epee
    # common
    # rpc
    # cryptonote_basic
    # mnemonics
    # wallet
    # serialization
    # ${Boost_SYSTEM_LIBRARY}
  PRIVATE
    ${EXTRA_LIBRARIES})
