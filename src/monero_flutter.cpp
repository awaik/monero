#include "monero_flutter.h"

#include <memory>
#include <string>

#include "extended_monero_wallet.hpp"
#include "wallet_listener.hpp"

#include "utils/monero_utils.h"

#include "ffi_utils.hpp"

// TODO TEMP
#include <iostream>

#if __APPLE__
// Fix for randomx on ios
void __clear_cache(void* start, void* end) { }
#endif

#ifdef __cplusplus
extern "C"
{
#endif

static extended_monero_wallet* _wallet;
static wallet_listener* _listener;

static void set_wallet(extended_monero_wallet* wallet) {
    if (nullptr != _wallet) {
        delete _wallet;
        _wallet = nullptr;
    }
    
    _wallet = wallet;
}

// ************* Load/Save *************

bool is_wallet_exist(const char* path)
{
    bool wallet_exists = monero_wallet_full::wallet_exists(path);
    return wallet_exists;
}

bool is_wallet_loaded()
{
    return nullptr != _wallet;
}

void restore_wallet_from_seed(const char* path, const char* password, const char* seed, int32_t network_type, ErrorBox* error)
{
    auto config = std::make_shared<monero_wallet_config>();
    config->m_path = path;
    config->m_password = password;
    config->m_seed = seed;
    config->m_network_type = static_cast<monero_network_type>(network_type);
    
    extended_monero_wallet* wallet;

    try
    {
        wallet = extended_monero_wallet::create_wallet_from_seed(*config);
    }
    catch (std::exception& e)
    {
        error->message = strdup(e.what());
        return;
    }
    
    set_wallet(wallet);
}

void open_wallet_data(const char* password, int32_t network_type, const uint8_t* keys_data, const int32_t keys_data_len, const uint8_t* cache_data, const int32_t cache_data_len, ErrorBox* error)
{
    extended_monero_wallet* wallet;
    
    try
    {
        wallet = extended_monero_wallet::open_wallet_data(password, static_cast<monero_network_type>(network_type),
                                                            std::string(reinterpret_cast<const char*>(keys_data), keys_data_len),
                                                          std::string(reinterpret_cast<const char*>(cache_data), cache_data_len));
    }
    catch (std::exception& e)
    {
        error->message = strdup(e.what());
        return;
    }
    
    set_wallet(wallet);
}

void load_wallet(const char* path, const char* password, int32_t network_type, ErrorBox* error)
{
    extended_monero_wallet* wallet;
    
    try
    {
        wallet = extended_monero_wallet::open_wallet(path, password, static_cast<monero_network_type>(network_type));
    }
    catch (std::exception& e)
    {
        error->message = strdup(e.what());
        return;
    }
    
    set_wallet(wallet);
}

const ByteArray get_keys_data(const char* password, bool view_only, ErrorBox* error)
{
    ByteArray result;
    result.length = 0;
    result.bytes = nullptr;
    
    std::string buffer;
    
    try
    {
        buffer = _wallet->get_keys_file_buffer(password, view_only);
    }
    catch (std::exception& e)
    {
        error->message = strdup(e.what());
        return result;
    }
    
    result.length = (int32_t)buffer.length();
    result.bytes = duplicate_bytes(buffer);
    
    return result;
}

const ByteArray get_cache_data(ErrorBox* error)
{
    ByteArray result;
    result.length = 0;
    result.bytes = nullptr;
    
    std::string buffer;
    
    try
    {
        buffer = _wallet->get_cache_file_buffer();
    }
    catch (std::exception& e)
    {
        error->message = strdup(e.what());
        return result;
    }
    
    result.length = (int32_t)buffer.length();
    result.bytes = duplicate_bytes(buffer);
    
    return result;
}

void store(ErrorBox* error)
{
    try
    {
        _wallet->save();
    }
    catch (std::exception& e)
    {
        error->message = strdup(e.what());
        return result;
    }
}

void close_current_wallet(ErrorBox* error)
{
    try
    {
        _wallet->close();
    }
    catch (std::exception& e)
    {
        error->message = strdup(e.what());
        return result;
    }
    
    set_wallet(nullptr);
}

// ************* Multisig *************

const char* prepare_multisig(ErrorBox* error)
{
    std::string result;
    
    try
    {
        result = _wallet->prepare_multisig();
    }
    catch (std::exception& e)
    {
        error->message = strdup(e.what());
        return nullptr;
    }
    
    if (result.empty())
        return nullptr;
    
    return strdup(result.c_str());
}

const char* make_multisig(const char* const* const info, uint32_t size, uint32_t threshold, const char* password, ErrorBox* error)
{
    auto info_vector = to_vector(info, size);
    std::string result;
    
    try
    {
        result = _wallet->make_multisig(info_vector, threshold, password);
    }
    catch (std::exception& e)
    {
        error->message = strdup(e.what());
        return nullptr;
    }
    
    if (result.empty())
        return nullptr;
    
    return strdup(result.c_str());
}

const char* exchange_multisig_keys(const char* const* const info, uint32_t size, const char* password, ErrorBox* error)
{
    auto info_vector = to_vector(info, size);
    monero_multisig_init_result init_result;
    
    try
    {
        init_result = _wallet->exchange_multisig_keys(info_vector, password);
    }
    catch (std::exception& e)
    {
        error->message = strdup(e.what());
        return nullptr;
    }
    
    auto multisig_hex = init_result.m_multisig_hex;
    
    return strdup(multisig_hex->c_str());
}

bool is_multisig_import_needed(ErrorBox* error)
{
    bool result;
    
    try
    {
        result = _wallet->is_multisig_import_needed();
    }
    catch (std::exception& e)
    {
        error->message = strdup(e.what());
        return false;
    }
}

void export_multisig_images(const char** info, ErrorBox* error)
{
    std::string multisig_hex;
    
    try
    {
        multisig_hex = _wallet->export_multisig_hex();
    }
    catch (std::exception& e)
    {
        error->message = strdup(e.what());
        return;
    }
    
    if (!multisig_hex.empty())
        (*info) = strdup(multisig_hex.c_str());
}

uint32_t import_multisig_images(const char* const* const info, uint32_t size, ErrorBox* error)
{
    auto multisig_hexes = to_vector(info, size);
    uint32_t result;
    
    try
    {
        result = _wallet->import_multisig_hex(multisig_hexes);
    }
    catch (std::exception& e)
    {
        error->message = strdup(e.what());
        return -1;
    }
    
    return result;
}

// ************* Sync *************

void setup_node(const char* address, const char* login, const char* password, ErrorBox* error)
{
    bool is_connected = _wallet->is_connected_to_daemon();
    std::cout << "is_connected_to_daemon=" << is_connected << std::endl;
    
    _wallet->set_daemon_connection(address, login, password);
    
    is_connected = _wallet->is_connected_to_daemon();
    std::cout << "is_connected_to_daemon=" << is_connected << std::endl;
}

void start_refresh(ErrorBox* error)
{
    // TODO make listener global value
    _listener = new wallet_listener();
    _wallet->add_listener(*_listener);
    
    _wallet->sync();
}

uint64_t get_syncing_height(ErrorBox* error)
{
    auto restore_height = _wallet->get_restore_height();
    auto daemon_height = _wallet->get_daemon_height();
    auto height = _wallet->get_height();
    
    std::cout << "restore_height=" << restore_height << "; daemon_height" << daemon_height << "; height=" << height << std::endl;
    
    return 1;
}

uint64_t get_current_height(ErrorBox* error)
{
    return 0;
}

uint64_t get_node_height(uint64_t base_eight, ErrorBox* error)
{
    return 0;
}

const char* const* get_public_nodes(ErrorBox* error)
{
    std::vector<std::string> nodes = _wallet->get_public_nodes();
    return from_vector(nodes);
}

uint64_t get_single_block_tx_count(const char* address, uint64_t block_height, ErrorBox* error)
{
    std::string address_value = address;
    auto http_client_factory = std::unique_ptr<epee::net_utils::http::http_client_factory>(new net::http::client_factory());
    auto http_client(http_client_factory->create());
    
    boost::optional<epee::net_utils::http::login> login{};
    login.emplace("", "");
    
    auto ssl = address_value.rfind("https", 0) == 0 ?
    epee::net_utils::ssl_support_t::e_ssl_support_enabled :
    epee::net_utils::ssl_support_t::e_ssl_support_disabled;
    
    http_client->set_server(address_value, login, ssl);
    std::chrono::seconds timeout = std::chrono::minutes(3);
    
    cryptonote::COMMAND_RPC_GET_BLOCKS_BY_HEIGHT::request req;
    cryptonote::COMMAND_RPC_GET_BLOCKS_BY_HEIGHT::response res;
    
    req.heights = {block_height};
    
    bool r = epee::net_utils::invoke_http_bin("/getblocks_by_height.bin", req, res, *http_client, timeout);
    
    if (res.status != CORE_RPC_STATUS_OK)
        throw std::runtime_error(res.status);
    
    if (!r || 1 != res.blocks.size())
        return -1;
    
    return res.blocks[0].txs.size();
}

// ************* Financial *************

const char* get_address(ErrorBox* error)
{
    std::string address;
    
    try
    {
        address = _wallet->get_address(0, 0);
    }
    catch (std::exception& e)
    {
        error->message = strdup(e.what());
        return nullptr;
    }
    
    return strdup(address.c_str());
}

const char* get_receive_address(ErrorBox* error)
{
    std::string address;
    
    try
    {
        auto num_subaddresses = (uint32_t)_wallet->get_num_subaddresses(0);
        address = _wallet->get_address(0, num_subaddresses);
    }
    catch (std::exception& e)
    {
        error->message = strdup(e.what());
        return nullptr;
    }
    
    return strdup(address.c_str());
}

uint64_t get_confirmed_balance(ErrorBox* error)
{
    uint64_t result;
    
    try
    {
        result = _wallet->get_unlocked_balance();
    }
    catch (std::exception& e)
    {
        error->message = strdup(e.what());
        return -1;
    }
    
    return result;
}

const char* get_all_transactions_json(ErrorBox* error)
{
    auto txs = _wallet->get_txs();
    
    auto blocks = monero_utils::get_blocks_from_txs(txs);
    
    rapidjson::Document doc;
    doc.SetObject();
    doc.AddMember("blocks", monero_utils::to_rapidjson_val(doc.GetAllocator(), blocks), doc.GetAllocator());
    
    auto blocks_json = monero_utils::serialize(doc);
    
    monero_utils::free(blocks);
    
    return strdup(blocks_json.c_str());
}

const char* get_utxos_json(ErrorBox* error)
{
    auto tx_query = std::make_shared<monero_tx_query>();
    tx_query->m_is_locked = false;
    tx_query->m_is_confirmed = true;
    
    auto output_query = std::make_shared<monero_output_query>();
    output_query->m_is_spent = false;
    output_query->m_tx_query = tx_query;
    
    // get utxos
    auto outputs = _wallet->get_outputs(*output_query);
    
    std::vector<std::shared_ptr<monero_block>> blocks = monero_utils::get_blocks_from_outputs(outputs);
    
    rapidjson::Document doc;
    doc.SetObject();
    doc.AddMember("blocks", monero_utils::to_rapidjson_val(doc.GetAllocator(), blocks), doc.GetAllocator());
    
    auto blocks_json = monero_utils::serialize(doc);
    
    // free memory
    monero_utils::free(blocks);
    monero_utils::free(output_query->m_tx_query.get());
    
    return strdup(blocks_json.c_str());
}

void thaw(const char* key_image, ErrorBox* error)
{
    try
    {
        _wallet->thaw_output(key_image);
    }
    catch (std::exception& e)
    {
        error->message = strdup(e.what());
        return;
    }
}

void freeze(const char* key_image, ErrorBox* error)
{
    try
    {
        _wallet->freeze_output(key_image);
    }
    catch (std::exception& e)
    {
        error->message = strdup(e.what());
        return;
    }
}

const char* create_transaction(const char* tx_config_json, ErrorBox* error)
{
    auto tx_config = monero_tx_config::deserialize(tx_config_json);
    auto txs = _wallet->create_txs(*tx_config);
    
    if (txs.size() != 1) {
        // TODO
    }
    
    auto result = txs[0]->m_tx_set.get()->serialize();
    
    return strdup(result.c_str());
}

const char* describe_tx_set(const char* tx_set_json, ErrorBox* error)
{
    std::string result_json;
    
    try
    {
        auto tx_set = monero_tx_set::deserialize(tx_set_json);
        auto result = _wallet->describe_tx_set(tx_set);
        result_json = result.serialize();
    }
    catch (std::exception& e)
    {
        error->message = strdup(e.what());
        return nullptr;
    }
    
    return strdup(result_json.c_str());
}

#ifdef __cplusplus
}
#endif
