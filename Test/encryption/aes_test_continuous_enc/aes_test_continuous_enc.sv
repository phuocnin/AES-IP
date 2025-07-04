class aes_test_continuous_enc extends aes_base_test;
    `uvm_component_utils(aes_test_continuous_enc)
    aes_multi_en aes_mul_seq;
    function new(string name = "aes_test_continuous_enc", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    aes_mul_seq = aes_multi_en::type_id::create("aes_mul_seq");
    endfunction
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Starting test", UVM_LOW)
        super.run_phase(phase);
        phase.raise_objection(this);
        aes_mul_seq.start(aes_env0.sequencer);
        @(posedge vif.clk);
        phase.drop_objection(this);
    endtask
endclass : aes_test_continuous_enc
