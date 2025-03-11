class aes_test_reset_enc extends aes_base_test;
    `uvm_component_utils(aes_test_reset_enc)
    aes_single_seq aes_seq;
    //aes_reset_seq aes_rst_seq;
    function new(string name = "aes_test_reset_enc", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        aes_seq = aes_single_seq::type_id::create("aes_seq");
      //  aes_rst_seq = aes_reset_seq::type_id::create("aes_rst_seq");
    endfunction
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Starting test", UVM_LOW)
        super.run_phase(phase);
        phase.raise_objection(this);
        fork
            //aes_rst_seq.start(aes_env0.sequencer);
            aes_seq.start(aes_env0.sequencer);
        join
        phase.drop_objection(this);
    endtask
endclass : aes_test_reset_enc
