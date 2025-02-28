class aes_driver extends uvm_driver #(aes_transaction);

    `uvm_component_utils(aes_driver)
    virtual aes_if vif;
    aes_transaction aes_trans;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
            if(!uvm_config_db #(virtual aes_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name()})
    endfunction

    virtual task run_phase(uvm_phase phase);
        fork
            drive_transaction(aes_trans);
            reset_signal();
        join
    endtask

    task drive_transaction(aes_transaction aes_trans);
        forever begin
            @(posedge vif.clk);
            seq_item_port.get_next_item(aes_trans);
            `uvm_info("aes_driver", $sformatf("Received transaction: in[%h], key[%h]",aes_trans.data_input, aes_trans.key), UVM_LOW);
            
            if(vif.rst == 1) begin
                repeat(10) begin
                @(posedge vif.clk);
                vif.data_input <= aes_trans.data_input;
                vif.key <= aes_trans.key;
            end
            seq_item_port.item_done();
        end
    endtask
    
    virtual task reset_signal();
        forever begin
            @(posedge vif.clk);
            if(vif.rst == 0) begin
                vif.data_input <= 128'h0;
                vif.key <= 128'h0;
                vif.finished <= 0;
            end
        end
    endtask
endclass