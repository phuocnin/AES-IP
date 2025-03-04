
class aes_monitor extends uvm_monitor;
    `uvm_component_utils(aes_monitor)
 
    virtual aes_if vif;  // Interface kết nối với DUT
    uvm_analysis_port#(aes_transaction) analysis_port;  // Analysis port để gửi transaction
    uvm_analysis_port#(logic) rst_port;  // Analysis port để gửi reset signal
    int count = 0;  // count the number of clock cycles before finished is activated
    logic rst;
    aes_transaction trans;
    function new(string aes_monitor = "aes_monitor", uvm_component parent = null);
       super.new(aes_monitor, parent);
       analysis_port = new("analysis_port", this);
        rst_port = new("rst_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
       if (!uvm_config_db#(virtual aes_if)::get(this, "", "vif", vif))
          `uvm_fatal("AES_MON", "Interface not set in config DB");
    endfunction
 
    task run_phase(uvm_phase phase);
       
       fork
            detect_reset();
            colect_send_data();
            check_finish_signal();
       join
    endtask

    task detect_reset();
        forever begin
            @(posedge vif.clk);
            if(vif.rst_n == 0) begin
                `uvm_info("AES_MON", "Reset signal is asserted", UVM_LOW);
                rst_port.write(vif.rst_n);
            end
            else begin
                rst_port.write(vif.rst_n);
            end
        end
    endtask

    task colect_send_data();
        forever begin
            //@(posedge vif.clk);
            wait (this.count == 1) 
            `uvm_info("AES_MON", "Collecting data", UVM_LOW);
            trans = aes_transaction::type_id::create("trans");
            `uvm_info("AES_MON", $sformatf("Received transaction: in[%h], key[%h]",vif.data_input, vif.key), UVM_LOW);
            trans.data_input = vif.data_input;
            trans.key = vif.key;
            
            @(posedge vif.clk);
            @(posedge vif.finished);
                trans.data_output = vif.data_output;
                analysis_port.write(trans);  
        end
    endtask

    task check_finish_signal();
        forever begin
            @(posedge vif.clk);
            #1;
            if( vif.finished ==1 && vif.rst_n == 1) begin
                if(this.count != 10) begin
                    `uvm_error("AES_MON", "Signal finished is active at clock edge ");
                end 
                else begin
                    this.count = 1;
                    `uvm_info("AES_MON", "Finished signal is asserted", UVM_LOW);
                end
            end
            else if(vif.rst_n == 1)begin
                this.count++;
                `uvm_info("AES_MON", $sformatf("count: %d",this.count), UVM_LOW);
            end
            else begin
                this.count = 0;
            end
        end
    endtask
 endclass
 