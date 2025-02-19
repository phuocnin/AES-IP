
class aes_monitor extends uvm_monitor;
    `uvm_component_utils(aes_monitor)
 
    virtual aes_if vif;  // Interface kết nối với DUT
    uvm_analysis_port#aes_transaction analysis_port;  // Analysis port để gửi transaction
 
    function new(string name = "aes_monitor", uvm_component parent = null);
       super.new(name, parent);
       analysis_port = new("analysis_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
       if (!uvm_config_db#(virtual aes_if)::get(this, "", "vif", vif))
          `uvm_fatal("AES_MON", "Interface not set in config DB");
    endfunction
 
    task run_phase(uvm_phase phase);
       aes_transaction trans;
       fork
            colect_data();

       join
    endtask

    task colect_data();
        forever begin
            @(posedge vif.clk);
            if(vif.finished == 1) begin
                trans = aes_transaction::type_id::create("trans");
                trans.data_output = vif.data_output;
                trans.key  = vif.key;
                analysis_port.write(trans);  
            end
        end
    endtask
 endclass
 