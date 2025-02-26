`include "design.sv"
`include "aes_if.sv"
`include "aes_pkg.sv"
module aes_tb;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "test_lib.sv"

    aes_if aes_if;
    AES_Cipher dut(
        .clk(aes_if.clk),
        .rst_n(aes_if.rst),
        .plain_text(aes_if.data_input),
        .cipher_key(aes_if.key),
        .cipher_text(aes_if.data_output),
        .cipher_ready(aes_if.finished)
    )

    initial begin
        uvm_config_db#(aes_if)::set(null, "*", "vif", aes_if);
        run_test("aes_test");
    end
    initial begin
        vif.sig_reset <= 1'b1;
        vif.sig_clock <= 1'b1;
        #51 vif.sig_reset = 1'b0;
      end
    
      //Generate Clock
    always
        #5 vif.sig_clock = ~vif.sig_clock;
endmodule