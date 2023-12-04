#include "ffi_utils.hpp"

const std::vector<std::string> to_vector(const char* const* const array, uint32_t size)
{
    std::vector<std::string> result;
    
    for (uint32_t i = 0; i < size; i++)
    {
        std::string item = std::string(array[i]);
        result.push_back(item);
    }
    
    return result;
}

const char* const* from_vector(const std::vector<std::string>& input)
{
    if (input.size() <= 0)
        return nullptr;
    
    // deallocate memory in the calling code!
    char** result = (char**)calloc(input.size() + 1, sizeof(char**));
    
    char** rp = result;
    
    for (auto const& s : input)
    {
        char* item = (char*)calloc(s.size() + 1, sizeof(char*));
        *rp++ = std::strcpy(item, s.c_str());
    }
    
    (*rp) = nullptr;
    
    return result;
}

// Work correctly with '\0' characters!
const uint8_t* duplicate_bytes(const std::string& str)
{
    std::size_t length = str.length();
    
    // deallocate memory in the calling code!
    uint8_t* bytes = (uint8_t*)calloc(length, sizeof(uint8_t));
    std::memcpy(bytes, str.c_str(), length);
    
    return bytes;
}
