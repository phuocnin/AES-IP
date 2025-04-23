class aes_functional_coverage extends uvm_subscriber #(aes_transaction);
    `uvm_component_utils(aes_functional_coverage)
    `ifdef CIPHER
     bit mode =1;
    `else
     bit mode =0;
    `endif
    covergroup mode_cov with function sample(bit mode);
      // Coverpoint cho mode
      MODE_COV: coverpoint mode {
        bins encrypt = {1'b1};
        bins decrypt = {1'b0};
      }
    endgroup : mode_cov

    covergroup input_key_cov with function sample(bit [127:0] data_input, bit [127:0] key);
  
      // Coverpoint cho data_input
      DATA_INPUT: coverpoint data_input {
        bins all_zeros = {128'h0};
        bins all_ones  = {128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF};
        bins pattern1  = {128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA};
        bins pattern2  = {128'h55555555555555555555555555555555};
      }
  
      // Coverpoint cho key
      KEY_COV: coverpoint key {
        bins all_zeros = {128'h0};
        bins all_ones  = {128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF};
        bins pattern1  = {128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA};
        bins pattern2  = {128'h55555555555555555555555555555555};
      }
  
      // Cross coverage
     // DATA_KEY_CROSS: cross DATA_INPUT, KEY_COV;
  
    endgroup : input_key_cov
  
    // // Coverage cho tín hiệu finished từ 0 -> 1
    // bit prev_finished;
  
    // covergroup finish_cov @(posedge clk);
    //   FINISHED_CP: coverpoint finished {
    //     bins done = (0 => 1);
    //   }
    // endgroup
  
    // Hàm constructor
    function new(string name = "aes_functional_coverage", uvm_component parent = null);
        super.new(name, parent);
        input_key_cov = new();
        mode_cov = new();
    //   finish_cov = new();
    //   prev_finished = 0;
    endfunction
  
    // Gọi khi nhận được transaction
    virtual function void write(aes_transaction t);
      // Sample input-key coverage
      input_key_cov.sample(t.data_input, t.key);
        mode_cov.sample(mode);
    //   // Nếu bạn đang truyền tín hiệu `finished` qua transaction:
    //   finish_cov.finished = t.finished;
    //   finish_cov.sample();
  
    //   // Lưu giá trị finished để check thay đổi nếu cần thêm logic
    //   prev_finished = t.finished;
    endfunction
  
  endclass : aes_functional_coverage
  