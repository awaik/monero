#include "extended_monero_wallet.hpp"

#include <memory>

#include "mnemonics/electrum-words.h"

namespace monero
{

struct wallet2_listener : public tools::i_wallet2_callback
{
public:
    wallet2_listener(monero_wallet_full& wallet, tools::wallet2& wallet2);
    ~wallet2_listener();
};

extended_monero_wallet* extended_monero_wallet::open_wallet(const std::string& path, const std::string& password, const monero_network_type network_type)
{
    MTRACE("open_wallet(" << path << ", ***, " << network_type << ")");
    
    extended_monero_wallet* wallet = new extended_monero_wallet();
    wallet->m_w2 = std::unique_ptr<tools::wallet2>(new tools::wallet2(static_cast<cryptonote::network_type>(network_type), 1, true));
    wallet->m_w2->load(path, password);
    wallet->m_w2->init("");
    wallet->init_common();
    
    return wallet;
}

extended_monero_wallet* extended_monero_wallet::open_wallet_data(const std::string& password, const monero_network_type network_type, const std::string& keys_data, const std::string& cache_data, const monero_rpc_connection& daemon_connection)
{
    MTRACE("open_wallet_data(...)");
    extended_monero_wallet* wallet = new extended_monero_wallet();
    
    wallet->m_w2 = std::unique_ptr<tools::wallet2>(new tools::wallet2(static_cast<cryptonote::network_type>(network_type), 1, true));
    wallet->m_w2->load("", password, keys_data, cache_data);
    wallet->m_w2->init("");
    wallet->set_daemon_connection(daemon_connection);
    wallet->init_common();
    return wallet;
}


extended_monero_wallet* extended_monero_wallet::create_wallet_from_seed(monero_wallet_config& config)
{
    MTRACE("create_wallet_from_seed(...)");
    
    // normalize config
    if (config.m_restore_height == boost::none)
        config.m_restore_height = 0;
    
    // validate mnemonic and get recovery key and language if not multisig
    crypto::secret_key recovery_key;
    std::string language = config.m_language.get();
    
    if (!config.m_is_multisig.get())
    {
        bool is_valid = crypto::ElectrumWords::words_to_bytes(config.m_seed.get(), recovery_key, language);
        if (!is_valid)
            throw std::runtime_error("Invalid mnemonic");
        
        if (language == crypto::ElectrumWords::old_language_name)
            language = config.m_language.get();
    }
    
    // validate language
    if (!crypto::ElectrumWords::is_valid_language(language))
        throw std::runtime_error("Invalid language: " + language);
    
    // apply offset if given
    if (!config.m_seed_offset.get().empty())
        recovery_key = cryptonote::decrypt_key(recovery_key, config.m_seed_offset.get());
    
    // initialize wallet
    extended_monero_wallet* wallet = new extended_monero_wallet();
    
    wallet->m_w2 = std::unique_ptr<tools::wallet2>(new tools::wallet2(static_cast<cryptonote::network_type>(config.m_network_type.get()), 1, true));
    
    wallet->set_daemon_connection(config.m_server);
    wallet->m_w2->set_seed_language(language);
    
    if (config.m_account_lookahead != boost::none) wallet->m_w2->set_subaddress_lookahead(config.m_account_lookahead.get(), config.m_subaddress_lookahead.get());
    
    // generate wallet
    if (config.m_is_multisig.get())
    {
        // parse multisig data
        epee::wipeable_string multisig_data;
        multisig_data.resize(config.m_seed.get().size() / 2);
        if (!epee::from_hex::to_buffer(epee::to_mut_byte_span(multisig_data), config.m_seed.get())) throw std::runtime_error("Multisig seed not represented as hexadecimal string");
        
        // generate multisig wallet
        wallet->m_w2->generate(config.m_path.get(), config.m_password.get(), multisig_data, false);
        wallet->m_w2->enable_multisig(true);
    }
    else
    {
        // generate normal wallet
        crypto::secret_key recovery_val = wallet->m_w2->generate(config.m_path.get(), config.m_password.get(), recovery_key, true, false);
        
        // validate mnemonic
        epee::wipeable_string electrum_words;
        
        if (!crypto::ElectrumWords::bytes_to_words(recovery_val, electrum_words, language))
            throw std::runtime_error("Failed to encode seed");
    }
    
    wallet->m_w2->set_refresh_from_block_height(config.m_restore_height.get());
    wallet->init_common();
    
    return wallet;
}

size_t extended_monero_wallet::get_num_subaddresses(uint32_t account_index) const
{
    return m_w2->get_num_subaddresses(account_index);
}

std::vector<std::string> extended_monero_wallet::get_public_nodes() const
{
    auto source = m_w2->get_public_nodes();
    
    std::vector<std::string> target;
    target.resize(source.size());
    
    std::transform(source.begin(), source.end(), target.begin(), [](const cryptonote::public_node& src_item) {
        return src_item.host + ":" + std::to_string(src_item.rpc_port);
    });
    
    return target;
}
}
