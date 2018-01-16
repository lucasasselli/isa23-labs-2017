vsim work.testbench
run 83340 ns
mem save -dataradix dec -outfile mem.txt /testbench/dut/datamem/mem_r
exit
