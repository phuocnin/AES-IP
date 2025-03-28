#set library path for DPI shared object
setenv LD_LIBRARY_PATH `pwd`/../AES128-C-master:$LD_LIBRARY_PATH
setenv CDS_INST_DIR /mnt/CADENCE/xcelium_2209
set path = ($CDS_INST_DIR/bin $path)

# Compile C model to shared object (.so)
gcc -m32 -shared -fPIC -o ../AES128-C-master/_sv_export.so ../AES128-C-master/aes.c -I$CDS_INST_DIR/tools/xcelium/include

# Verify shared object is created
 if (! -e ../AES128-C-master/_sv_export.so) then
     echo "Error: Failed to create _sv_export.so"
         exit 1
         endif
set test = "aes_test_reset_enc"
# set test = "aes_test_reset_dec"
# set test = "aes_test_definetion_enc"
# set test = "aes_test_continuous_enc"
# set test = "aes_test_special_data_enc"
# Compile SystemVerilog testbench
  xrun -access +rwc -define CIPHER -coverage B:E:F -uvm -sv +incdir+../env +incdir+../AES_CORE -compile aes_tb.sv
#  xrun -access +rwc -define CIPHER -uvm -sv +incdir+../env +incdir+../AES_CORE -compile aes_tb.sv

#Run simulation with DPI and waveform logging
  xrun -access +rwc  -define CIPHER  -covtest $test -coverage B:E:F -uvm -sv +incdir+../env +incdir+../AES_CORE \
       -sv_lib `pwd`/../AES128-C-master/_sv_export.so aes_tb.sv +UVM_TESTNAME=$test -input run_wave.tcl

