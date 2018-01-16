vsim work.testbench
run 6180 ns
mem save -dataradix dec -outfile mem.txt /testbench/dut/datamem/mem_r
exit
