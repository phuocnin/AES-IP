
virtual class aes_base_sequence extends uvm_sequence #(aes_transaction);
    function new(string name = "aes_base_sequence");
        super.new(name);
    endfunction
endclass : aes_base_sequence

// Plan test 3
class aes_single_seq extends aes_base_sequence;
        `uvm_object_utils(aes_single_seq)
        aes_transaction req;
        function new(string name = "aes_single_seq");
            super.new(name);
        endfunction
        task body();
            `uvm_info("aes_single_seq", "Starting aes_single_seq", UVM_LOW)
            repeat(2) begin
                req = aes_transaction::type_id::create("req");
                start_item(req);
              //  $srandom(int'($time)); 
                req.randomize() with {data_input == 128'h00112233445566778899aabbccddeeff ;
                key == 128'h000102030405060708090a0b0c0d0e0f;};
                //req.randomize() with {data_input == 128'h69c4e0d86a7b0430d8cdb78070b4c55a ;
                //key == 128'h000102030405060708090a0b0c0d0e0f;};
                finish_item(req);
            end
        endtask
endclass : aes_single_seq
// plan test 4
class aes_multi_seq extends aes_base_sequence;
    `uvm_object_utils(aes_multi_seq)
    aes_transaction req;
    function new(string name = "aes_multi_seq");
        super.new(name);
    endfunction
    task body();
        `uvm_info("aes_multi_seq", "Starting aes_multi_seq", UVM_LOW)
        repeat(1) begin
            `uvm_do(req);
        end
    endtask
endclass : aes_multi_seq
 // Plan test 5 
class aes_spec_case extends aes_base_sequence;
    `uvm_object_utils(aes_spec_case)
    aes_transaction req;
    function new(string name = "aes_spec_case");
        super.new(name);
    endfunction
    task body();
        `uvm_info("aes_spec_case", "Starting aes_spec_case", UVM_LOW)
        //plan 5.1 
         repeat(3) begin
                req = aes_transaction::type_id::create("req");
                start_item(req);
              //  $srandom(int'($time)); 
                void'(req.randomize() with {
                data_input dist { 128'h0 := 50, 128'hffffffffffffffffffffffffffffffff := 50 };
                key dist { 128'h0 := 50, 128'hffffffffffffffffffffffffffffffff := 50 };});
                finish_item(req);
        end
    endtask
endclass : aes_spec_case

