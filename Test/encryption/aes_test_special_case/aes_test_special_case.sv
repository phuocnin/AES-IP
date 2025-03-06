class aes_test_special_case extends aes_base_test;
    `uvm_component_utils(aes_test_special_case)
    aes_spec_case aes_spec;
    function new(string name = "aes_test_special_case", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    aes_spec = aes_spec_case::type_id::create("aes_spec");
    endfunction
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Starting test", UVM_LOW)
        super.run_phase(phase);
        phase.raise_objection(this);
        aes_spec.start(aes_env0.sequencer);
        phase.drop_objection(this);
    endtask
endclass : aes_test_special_case