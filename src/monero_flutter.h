#include <stdint.h>
#include <stdbool.h>
#include <string>

#ifdef __cplusplus
extern "C"
{
#endif

typedef struct ErrorBox
{
    int code;
    const char* message;
} ErrorBox;

typedef struct ByteArray {
    const uint8_t* bytes;
    int32_t length;
} ByteArray;

// ************* Load/Save *************

bool is_wallet_exist(const char* path);

bool is_wallet_loaded();

void restore_wallet_from_seed(const char* path, const char* password, const char* seed, int32_t network_type, ErrorBox* error);

void open_wallet_data(const char* password, int32_t network_type, const uint8_t* keys_data, const int32_t keys_data_len, const uint8_t* cache_data, const int32_t cache_data_len, ErrorBox* error);

void load_wallet(const char* path, const char* password, int32_t network_type, ErrorBox* error);

const ByteArray get_keys_data(const char* password, bool view_only, ErrorBox* error);

const ByteArray get_cache_data(ErrorBox* error);

void store(ErrorBox* error);

void close_current_wallet(ErrorBox* error);

// ************* Multisig *************

const char* prepare_multisig(ErrorBox* error);

const char* make_multisig(const char* const* const info, uint32_t size, uint32_t threshold, const char* password, ErrorBox* error);

const char* exchange_multisig_keys(const char* const* const info, uint32_t size, const char* password, ErrorBox* error);

bool is_multisig_import_needed(ErrorBox* error);

void export_multisig_images(const char** info, ErrorBox* error);

uint32_t import_multisig_images(const char* const* const info, uint32_t size, ErrorBox* error);

// ************* Sync *************

void setup_node(const char* address, const char* login, const char* password, ErrorBox* error);

void start_refresh(ErrorBox* error);

uint64_t get_syncing_height(ErrorBox* error);

uint64_t get_current_height(ErrorBox* error);

uint64_t get_node_height_or_update(uint64_t base_eight);

const char* const* get_public_nodes();

uint64_t get_single_block_tx_count(const std::string& address, uint64_t block_height);

// ************* Financial *************

const char* get_address(ErrorBox* error);

const char* get_receive_address(ErrorBox* error);

uint64_t get_confirmed_balance(ErrorBox* error);

const char* get_all_transactions_json(ErrorBox* error);

const char* get_utxos_json(ErrorBox* error);

void thaw(const char* key_image, ErrorBox* error);

void freeze(const char* key_image, ErrorBox* error);

const char* create_transaction(const char* tx_config_json, ErrorBox* error);

const char* describe_tx_set(const char* tx_set_json, ErrorBox* error);


#ifdef __cplusplus
}
#endif
