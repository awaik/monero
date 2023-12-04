#pragma once

#include <string>
#include <vector>
#include <cstdint>

const std::vector<std::string> to_vector(const char* const* const array, uint32_t size);

const char* const* from_vector(const std::vector<std::string>& input);

// Work correctly with '\0' characters!
const uint8_t* duplicate_bytes(const std::string& str);
