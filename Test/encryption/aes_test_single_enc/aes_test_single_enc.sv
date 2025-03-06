class aes_test_basic_cipher extends aes_base_test;
    `uvm_component_utils(aes_test_basic_cipher)
    function new(string name = "aes_test_basic_cipher", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        aes_single_seq = aes_single_seq::type_id::create("aes_single_seq");
    endfunction
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Starting test", UVM_LOW)
        super.run_phase(phase);
        phase.raise_objection(this);
        aes_single_seq.start(aes_env0.sequencer);
        phase.drop_objection(this);
    endtask
endclass : aes_test_basic_cipher