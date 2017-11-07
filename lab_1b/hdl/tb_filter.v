`define NULL 0
`define NB 8
`define NT 10

module tb_filter();

// TB stuff
integer data_file;
integer scan_file;
integer file_in0;
integer file_in1;
integer file_in2;

// DUT I/O
reg [(`NT+1)*(`NB)-1:0] B;
reg [`NB-1:0] DIN0, DIN1, DIN2;
reg VIN;
reg RST_n;
reg CLK;
wire [`NB-1:0] DOUT0, DOUT1, DOUT2;
wire VOUT;
reg signed [`NB-1:0] temp_out;

filter_top DUT(
    .B(B),
    .DIN0(DIN0),
    .DIN1(DIN1),
    .DIN2(DIN2),
    .VIN(VIN),
    .CLK(CLK),
    .RST_n(RST_n),
    .DOUT0(DOUT0),
    .DOUT1(DOUT1),
    .DOUT2(DOUT2),
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

    DIN0 = 0;
    DIN1 = 0;
    DIN2 = 0;

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

    data_file = $fopen("../c/samples.txt", "r");
    if (data_file == `NULL) begin
        $display("data_file handle was NULL");
        $finish;
    end

    #23 RST_n = 1;
end

// Push data
always @(negedge CLK) begin
    if (RST_n == 1) begin
        // TODO: This is very bad
        scan_file = $fscanf(data_file, "%d\n", file_in0); 
        scan_file = $fscanf(data_file, "%d\n", file_in1); 
        scan_file = $fscanf(data_file, "%d\n", file_in2); 
        if (!$feof(data_file)) begin
            DIN0 = file_in0[7:0];
            DIN1 = file_in1[7:0];
            DIN2 = file_in2[7:0];
            VIN = 1;
        end
        else begin
            $display("Reached EOF!");
            $finish;
        end
    end
end

always @(posedge CLK) begin
    if (VOUT == 1) begin
        temp_out = DOUT0;
        $display("%d", temp_out);
        temp_out = DOUT1;
        $display("%d", temp_out);
        temp_out = DOUT2;
        $display("%d", temp_out);
    end
end

endmodule
