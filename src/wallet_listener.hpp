#pragma once

#include <cstdint>
#include <string>

#include "wallet/monero_wallet.h"

using namespace monero;

struct wallet_listener : public monero_wallet_listener
{
    void on_sync_progress(uint64_t height, uint64_t start_height, uint64_t end_height, double percent_done, const std::string& message) override;
    void on_new_block(uint64_t height) override;
    void on_balances_changed(uint64_t new_balance, uint64_t new_unlocked_balance) override;
    void on_output_received(const monero_output_wallet& output) override;
    void on_output_spent(const monero_output_wallet& output) override;
};
