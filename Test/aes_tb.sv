`include "design.sv"
`include "aes_if.sv"
`include "aes_pkg.sv"
module aes_tb;
    import uvm_pkg::*;
    import aes_pkg::*;
    `include "uvm_macros.svh"
    `include "test.sv"

    aes_if vif();
    AES_Cipher dut(
        .clk(vif.clk),
        .rst_n(vif.rst_n),
        .plain_text(vif.data_input),
        .cipher_key(vif.key),
        .cipher_text(vif.data_output),
        .cipher_ready(vif.finished)
    );

    initial begin
        uvm_config_db#(virtual aes_if)::set(null, "*", "vif", vif);
        run_test("aes_test_basic_cipher");
    end
    initial begin
        vif.rst_n <= 1'b0;
        vif.clk <= 1'b1;
        #50 vif.rst_n = 1'b1;
      end
    
      //Generate Clock
    always
        #5 vif.clk = ~vif.clk;
endmodule