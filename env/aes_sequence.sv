virtual class aes_base_sequence extends uvm_sequence #(aes_transaction);
    `uvm_object_utils(aes_base_sequence)

    function new(string name = "aes_base_sequence");
        super.new(name);
        
    endfunction
    endclass : aes_base_sequence


class aes_sequence extends aes_base_sequence;
        `uvm_object_utils(aes_sequence)
        function new(string name = "aes_sequence");
            super.new(name);
        endfunction
        task body();
            `uvm_info("aes_sequence", "Starting aes_sequence", UVM_LOW)
            repeat(1) begin
                `uvm_do_with(aes_trans)
            end
        endtask
endclass : aes_sequence