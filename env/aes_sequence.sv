
virtual class aes_base_sequence extends uvm_sequence #(aes_transaction);
    function new(string name = "aes_base_sequence");
        super.new(name);
    endfunction
endclass : aes_base_sequence


class aes_single_seq extends aes_base_sequence;
        `uvm_object_utils(aes_single_seq)
        aes_transaction req;
        function new(string name = "aes_single_seq");
            super.new(name);
        endfunction
        task body();
            `uvm_info("aes_single_seq", "Starting aes_single_seq", UVM_LOW)
            repeat(1) begin
                req = aes_transaction::type_id::create("req");
                start_item(req);
                $srandom(int'($time)); 
                req.randomize();
                finish_item(req);
            end
        endtask
endclass : aes_single_seq

class aes_multi_seq extends aes_base_sequence;
    `uvm_object_utils(aes_multi_seq)
    aes_transaction req;
    function new(string name = "aes_multi_seq");
        super.new(name);
    endfunction
    task body();
        `uvm_info("aes_multi_seq", "Starting aes_multi_seq", UVM_LOW)
        repeat(1000) begin
            `uvm_do(req);
        end
    endtask
endclass : aes_multi_seq

