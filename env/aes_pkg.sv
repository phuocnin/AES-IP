package aes_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    typedef uvm_config_db#( virtual aes_if ) aes_if_db;
    typedef virtual aes_if aes_vif;

    `include "aes_transaction.sv"
    `include "aes_monitor.sv"
    `include "aes_driver.sv"
endpackage