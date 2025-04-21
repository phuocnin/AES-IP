class all_test extends aes_base_test;
    `uvm_component_utils(all_test)
    aes_single_en aes_seq;
    aes_multi_en aes_mul_seq;
    aes_spec_case_en aes_spec;

    function new(string name = "all_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        aes_seq = aes_single_en::type_id::create("aes_seq");
        aes_mul_seq = aes_multi_en::type_id::create("aes_mul_seq");
        aes_spec = aes_spec_case_en::type_id::create("aes_spec");
    endfunction
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Starting test", UVM_LOW)
        super.run_phase(phase);
        phase.raise_objection(this);
        fork
            aes_seq.start(aes_env0.sequencer);
            begin
                `uvm_info(get_type_name(), "Resetting DUT", UVM_LOW)
                repeat (14) @(posedge vif.clk);
                vif.rst_n <= 0;
                `uvm_info(get_type_name(), "Releasing reset", UVM_LOW)
                repeat (8) @(posedge vif.clk);
                vif.rst_n <= 1;
                `uvm_info(get_type_name(), "Resetting DUT", UVM_LOW)
                repeat (14) @(posedge vif.clk);
                vif.rst_n <= 0;
                `uvm_info(get_type_name(), "Releasing reset", UVM_LOW)
                repeat (8) @(posedge vif.clk);
                vif.rst_n <= 1;
            end
        join
        aes_mul_seq.start(aes_env0.sequencer);
        @(posedge vif.clk);
        aes_seq.start(aes_env0.sequencer);
        @(posedge vif.clk);
        aes_spec.start(aes_env0.sequencer);
        phase.drop_objection(this);

    endtask
endclass : all_test
