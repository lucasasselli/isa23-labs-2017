vsim work.testbench
run 70010 ns
mem save -dataradix dec -outfile mem.txt /testbench/dut/datamem/mem_r
exit
