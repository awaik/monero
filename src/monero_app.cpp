#include <iostream>
#include <unistd.h>

#include "monero_ffi.h"

int main(int argc, char** argv)
{
    const char* path = "/Users/dmytro/Documents/_WALLETS/v1/moneroWalletVer3";
    //const char* seed = "point nerves ungainly gather loudly theatrics october misery aphid website attire erected shelter ouch hesitate nouns suede omnibus folding last fruit upbeat haystack hedgehog gather";
    
    bool wallet_exists = is_wallet_exist(path);
	std::cout << "wallet_exists=" << wallet_exists << std::endl;
    
    ErrorBox error;
    
    //restore_wallet_from_seed(path, "", seed, 0, &error);
    
    load_wallet(path, "", 0, &error);
    
    auto address1 = get_address(&error);
    std::cout << "address1=" << address1 << std::endl;
    
    auto address2 = get_receive_address(&error);
    std::cout << "address2=" << address2 << std::endl;
    
    //return 0;
    
    setup_node("xmrno.de:18089", "", "", &error);
    
    start_refresh(&error);
    
    std::cout << "{";
    sleep(2 * 60);
   
    std::cout << "}\r\n";
    
    store(&error);
    
    //setup_node("xmrno.de:18089", "", "", &error);

    
//    auto public_nodes = get_public_nodes(&error);
//    std::cout << "public_node=" << public_nodes[0] << std::endl;
    
//    auto utxos_json = get_utxos_json(&error);
//    std::cout << "=== utxos ===" << std::endl;
//    std::cout << utxos_json << std::endl;
//    std::cout << "=== end ===" << std::endl;
    
    // get_all_transactions_json
//    auto transactions_json = get_all_transactions_json(&error);
//    std::cout << "=== transactions ===" << std::endl;
//    std::cout << transactions_json << std::endl;
//    std::cout << "=== end ===" << std::endl;
    
    while (true)
    {
        auto syncing_height = get_current_height(&error);
        auto end_height = get_end_height(&error);
        std::cout << "syncing_height=" << syncing_height << "; end_height=" << end_height << std::endl;
        sleep(1);
    }
    
	return 0;
}
