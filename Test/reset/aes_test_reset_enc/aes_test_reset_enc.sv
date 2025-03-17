class aes_test_reset_enc extends aes_base_test;
    `uvm_component_utils(aes_test_reset_enc)
    aes_multi_en aes_seq;
    //aes_reset_seq aes_rst_seq;
    function new(string name = "aes_test_reset_enc", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        aes_seq = aes_multi_en::type_id::create("aes_seq");
        
    endfunction
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Starting test", UVM_LOW)
        super.run_phase(phase);
        aes_env0.scoreboard.disable_scoreboard = 1;
        phase.raise_objection(this);
        fork
            aes_seq.start(aes_env0.sequencer);
            begin
                repeat (2) @(posedge vif.clk);
                vif.rst_n <= 0;
                repeat (2) @(posedge vif.clk);
                vif.rst_n <= 1;
            end
        join_none
        phase.drop_objection(this);
    endtask
endclass : aes_test_reset_enc
