#include "wallet_listener.hpp"

void wallet_listener::on_sync_progress(uint64_t height, uint64_t start_height, uint64_t end_height, double percent_done, const std::string& message)
{
    m_height = height;
    m_start_height = start_height;
    m_end_height = end_height;
    m_message = message;
}

void wallet_listener::on_new_block(uint64_t height) {}
void wallet_listener::on_balances_changed(uint64_t new_balance, uint64_t new_unlocked_balance) {}
void wallet_listener::on_output_received(const monero_output_wallet& output) {}
void wallet_listener::on_output_spent(const monero_output_wallet& output) {}

uint64_t wallet_listener::get_height() const { return m_height; }
uint64_t wallet_listener::get_start_height() const { return m_start_height; }
uint64_t wallet_listener::get_end_height() const { return m_end_height; }
double wallet_listener::get_percent_done() const { return m_percent_done; }
std::string wallet_listener::get_message() const { return m_message; }
