vsim work.testbench
run 93130 ns
mem save -dataradix dec -outfile mem.txt /testbench/dut/datamem/mem_r
exit
