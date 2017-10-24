`define NULL 0
`define NB 8
`define NT 10

module tb_filter();

// TB stuff
integer data_file;
integer scan_file;
integer file_in;

// DUT I/O
reg [(`NT+1)*(`NB)-1:0] B;
reg [`NB-1:0] DIN;
reg VIN;
reg RST_n;
reg CLK;
wire [`NB-1:0] DOUT;
wire VOUT;
reg signed [`NB-1:0] temp_out;

filter_top DUT(
    .B(B),
    .DIN(DIN),
    .VIN(VIN),
    .CLK(CLK),
    .RST_n(RST_n),
    .DOUT(DOUT),
    .VOUT(VOUT)
);

// Generate clock
always
begin
    #5 CLK <= ! CLK;
end 

initial begin
    CLK = 0;
    RST_n = 0;
    VIN = 0;

    B[87:80] = -1;
    B[79:72] = -2;
    B[71:64] = -4;
    B[63:56] = 8;
    B[55:48] = 35;
    B[47:40] = 50;
    B[39:32] = 35;
    B[31:24] = 8;
    B[23:16] = -4;
    B[15:8]  = -2;
    B[7:0]   = -1;

    $read_lib_saif("../saif/NangateOpenCellLibrary.saif");
    $set_gate_level_monitoring("on");
    $set_toggle_region(DUT);
    $toggle_start;

    data_file = $fopen("samples.txt", "r");
    if (data_file == `NULL) begin
        $display("data_file handle was NULL");
        $finish;
    end

    #23 RST_n = 1;
end

// Push data
always @(negedge CLK) begin
    if (RST_n == 1) begin
        scan_file = $fscanf(data_file, "%d\n", file_in); 
        if (!$feof(data_file)) begin
            DIN = file_in[7:0];
            VIN = 1;
        end
        else begin
            $display("Reached EOF!");
	    $toggle_stop;
	    $toggle_report("../saif/filter.saif", 1.0e-9, "tb_filter.DUT");
            $finish;
        end
    end
end

always @(posedge CLK) begin
    if (VOUT == 1) begin
        temp_out = DOUT;
        $display("%d", temp_out);
    end
end

endmodule
