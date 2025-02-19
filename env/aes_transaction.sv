typedef enum { cipher, decipher
    } aes_mode;

class aes_transaction extends uvm_sequence_item;
  `uvm_object_utils(name)
    
    rand bit [127:0] data_input;
    rand bit [127:0] key;
    //rand int unsigned size
    rand aes_mode mode;
    logic [127:0] data_output;
    logic finished;

    // constraint c_size {
    //   size inside {[1:10]};
    // }
 
    // constraint c_data_wait_size {
    //     data_input.size() == size;
    // }

    function new(string name = "aes_transaction");
      super.new(name);
    endfunction
    
endclass : aes_transaction