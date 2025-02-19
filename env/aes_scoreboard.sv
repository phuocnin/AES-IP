class aes_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(aes_scoreboard)
    uvm_analysis_port#(aes_transaction) transaction_analysis_port;
    function new(string name = "aes_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    function void write_transaction(aes_transaction aes_trans);
    endfunction
    
endclass