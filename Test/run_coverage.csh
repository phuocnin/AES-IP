#!/bin/csh

# ================================
# SETUP ENVIRONMENT
# ================================
setenv LD_LIBRARY_PATH `pwd`/../AES128-C-master:$LD_LIBRARY_PATH
setenv CDS_INST_DIR /mnt/CADENCE/xcelium_2209
set path = ($CDS_INST_DIR/bin $path)

# ================================
# COMPILE C MODEL TO SHARED OBJECT (.so)
# ================================
echo "[INFO] Compiling AES128 DPI C model..."
gcc -m32 -shared -fPIC -o ../AES128-C-master/_sv_export.so ../AES128-C-master/aes.c -I$CDS_INST_DIR/tools/xcelium/include

# Verify shared object is created
if (! -e ../AES128-C-master/_sv_export.so) then
    echo "[ERROR] Failed to create _sv_export.so"
    exit 1
endif
echo "[INFO] Successfully created _sv_export.so"

# ================================
# COMPILE SYSTEMVERILOG TESTBENCH
# ================================
echo "[INFO] Compiling SystemVerilog testbench..."
xrun -access +rwc -define CIPHER -uvm -sv +incdir+../env +incdir+../AES_CORE -coverage all -covwork cov_work -compile aes_tb.sv

# ================================
# RUN SIMULATION FOR MULTIPLE TEST CASES
# ================================
set TESTS = ( \
    aes_test_reset_enc \
    aes_test_reset_dec \
    aes_test_definetion_enc \
    aes_test_continuous_enc \
    aes_test_special_data_enc \
    aes_test_definetion_dec \
    aes_test_continuous_dec \
    aes_test_special_data_dec \
)

foreach TEST ($TESTS)
    echo "[INFO] Running simulation for $TEST..."
    xrun -access +rwc -define CIPHER -uvm -sv +incdir+../env +incdir+../AES_CORE \
         -sv_lib `pwd`/../AES128-C-master/_sv_export.so \
         -covwork cov_work -covoverwrite -R +UVM_TESTNAME=$TEST

    if ($status != 0) then
        echo "[ERROR] Test $TEST failed. Exiting..."
        exit 1
    endif
end

# ================================
# MERGE COVERAGE REPORT
# ================================
echo "[INFO] Merging coverage results..."
urg -dir cov_work -merge -report coverage_report

# ================================
# GENERATE HTML COVERAGE REPORT
# ================================
echo "[INFO] Generating HTML coverage report..."
urg -dir cov_work -format html -report coverage_html

echo "[INFO] Coverage report generated: Open coverage_html/index.html in a browser."
