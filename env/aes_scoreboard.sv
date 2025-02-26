
`uvm_analysis_imp_decl(_frm_Monitor)
`uvm_analysis_imp_decl(_rst)

import "DPI-C" function void aes_encrypt_dpi(input  bit[127:0] dataIn,
input  bit[127:0] key,
output bit[127:0] dataOut);

import "DPI-C" function void aes_decrypt_dpi(input  bit[127:0] dataIn,
input  bit[127:0] key,
output bit[127:0] dataOut);


class aes_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(aes_scoreboard)
    
    uvm_analysis_imp_frm_Monitor#(aes_transaction) transaction_analysis_port;
    uvm_analysis_imp_rst#(logic) rst_analysis_port;
    logic rst_flag;
    int         error_cnt;
    function new(string name = "aes_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        if (!uvm_config_db#(uvm_analysis_port#(aes_transaction))::get(this, "", "transaction_analysis_port", transaction_analysis_port))
            `uvm_fatal("AES_SCOREBOARD", "Transaction analysis port not set in config DB");
        if (!uvm_config_db#(uvm_analysis_port#(logic))::get(this, "", "rst_analysis_port", rst_analysis_port))
            `uvm_fatal("AES_SCOREBOARD", "Reset analysis port not set in config DB");
    endfunction
    
    function void check_reset(logic rst);
        forever begin
            if (rst) begin
                rst_flag = 0;
                `uvm_info("AES_SCOREBOARD", "Reset signal is asserted", UVM_LOW);
            end
            else begin
                rst_flag = 1;
            end
        end
    endfunction

    function void compare_data(aes_transaction trans);
        `uvm_info("AES_SCOREBOARD", $sformatf("Received transaction: in[%2h], key[%2h], out[%2h] ", trans.data_input,trans.key, trans.data_output), UVM_LOW);
        bit [127:0] ref_ciphertext;
        aes_encrypt_dpi( trans.data_input,trans.key, ref_ciphertext);

        if (ref_ciphertext == trans.data_output) begin
        `uvm_info("AES_SCOREBOARD", "AES Encryption match", UVM_MEDIUM)
        end else begin
        `uvm_error("AES_SCOREBOARD", $sformatf("Mismatch: DUT=%h, REF=%h", trans.data_input, ref_ciphertext))
        end
    endfunction
        
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_type_name(),$sformatf("***** ERROR_NUM = %0d *****", error_cnt), UVM_LOW)
        if(error_cnt != 0) 
            simulation_top.test_fail();
        else 
            simulation_top.test_pass();
    endfunction: report_phase
    
        
    
endclass