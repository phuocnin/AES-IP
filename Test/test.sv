`include "aes_sequence.sv"
class aes_base_test extends uvm_test;
    `uvm_component_utils(aes_base_test)
    virtual aes_if vif;
    aes_sequence aes_seq;
    aes_env aes_env0;
    uvm_table_printer printer;

    
    function new(string name = "aes_base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        if (!uvm_config_db#(virtual aes_if)::get(this, "", "vif", vif))
            `uvm_fatal("AES_TEST", "Interface not set in config DB");
        //aes_seq = aes_sequence::type_id::create("aes_seq");
        aes_env0 = aes_env::type_id::create("aes_env0", this);
        printer = new();
        printer.knobs.depth = 3;
    endfunction
    function void end_of_elaboration_phase(uvm_phase phase);
        // // Set verbosity for the bus monitor for this demo
        //  if(env.bus_monitor != null)
        //    env.bus_monitor.set_report_verbosity_level(UVM_FULL);
        `uvm_info(get_type_name(),
          $sformatf("Printing the test topology :\n%s", this.sprint(printer)), UVM_LOW)
      endfunction : end_of_elaboration_phase
endclass : aes_base_test

class aes_test_basic_cipher extends aes_base_test;
    `uvm_component_utils(aes_test_basic_cipher)
    function new(string name = "aes_test_basic_cipher", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        aes_seq = aes_sequence::type_id::create("aes_seq");
    endfunction
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Starting test", UVM_LOW)
        super.run_phase(phase);
        phase.raise_objection(this);
        aes_seq.start(aes_env0.sequencer);
        phase.drop_objection(this);
    endtask
endclass : aes_test_basic_cipher
