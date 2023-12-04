#include "wallet_listener.hpp"


// TODO TEMP
#include <iostream>

void wallet_listener::on_sync_progress(uint64_t height, uint64_t start_height, uint64_t end_height, double percent_done, const std::string& message)
{
    std::cout << "height=" << height << "; start_height=" << start_height << "; end_height=" << end_height << "; percent_done=" << percent_done << "; " << message << std::endl;
}
void wallet_listener::on_new_block(uint64_t height){}
void wallet_listener::on_balances_changed(uint64_t new_balance, uint64_t new_unlocked_balance) {}
void wallet_listener::on_output_received(const monero_output_wallet& output) {}
void wallet_listener::on_output_spent(const monero_output_wallet& output) {}
