`include "design.sv"
`include "aes_if.sv"
`include "aes_pkg.sv"
module aes_tb;
    import uvm_pkg::*;
    import aes_pkg::*;
    `include "uvm_macros.svh"
    `include "test.sv"

    aes_if aes_vif();
    AES_Cipher dut(
        .clk(aes_vif.clk),
        .rst_n(aes_vif.rst),
        .plain_text(aes_vif.data_input),
        .cipher_key(aes_vif.key),
        .cipher_text(aes_vif.data_output),
        .cipher_ready(aes_vif.finished)
    );

    initial begin
        uvm_config_db#(aes_vif)::set(null, "*", "vif", vif);
        run_test("aes_test");
    end
    initial begin
        aes_vif.sig_reset <= 1'b1;
        aes_vif.sig_clock <= 1'b1;
        #51 aes_vif.sig_reset = 1'b0;
      end
    
      //Generate Clock
    always
        #5 aes_vif.sig_clock = ~aes_vif.sig_clock;
endmodule