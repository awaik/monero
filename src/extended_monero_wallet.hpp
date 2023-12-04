#pragma once

#include <cstdint>
#include <string>
#include <vector>

#include "wallet/monero_wallet_full.h"
#include "wallet/monero_wallet_model.h"

namespace monero
{
class extended_monero_wallet : public monero_wallet_full
{
public:
    
    static extended_monero_wallet* open_wallet(const std::string& path, const std::string& password, const monero_network_type network_type);
    
    static extended_monero_wallet* open_wallet_data(const std::string& password, const monero_network_type network_type, const std::string& keys_data, const std::string& cache_data, const monero_rpc_connection& daemon_connection = monero_rpc_connection());
    
    static extended_monero_wallet* create_wallet_from_seed(monero_wallet_config& config);
    
    size_t get_num_subaddresses(uint32_t account_index) const;
    std::vector<std::string> get_public_nodes() const;
};
}
