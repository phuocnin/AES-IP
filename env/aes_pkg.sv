package aes_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    typedef uvm_config_db#( virtual aes_if ) aes_if_db;
    typedef virtual aes_if aes_vif;

    `include "aes_transaction.sv"
    `include "aes_monitor.sv"
    `include "aes_driver.sv"
    `include "aes_sequencer.sv"
    `include "aes_scoreboard.sv"
    `include "aes_env.sv"
    `include "../Test/test.sv"
    `include "../Test/encryption/aes_test_single_enc/aes_test_single_enc.sv"
    `include "../Test/encryption/aes_test_continuous_enc/aes_test_continuous_enc.sv"
endpackage: aes_pkg