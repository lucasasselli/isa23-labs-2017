module tb_booth_mult;

reg [7:0] MC, MP;
reg [15:0] ref_out;
reg error;
integer	Tot_errors;
integer J,K;  
wire [15:0] test_out;

initial begin
    Tot_errors = 0;
    for (K=127; K>=-128; K=K-1) begin
        for (J=127;J>=-128; J=J-1) begin
            MC = K;
            MP = J;
            ref_out = K*J;

            # 10
            if (ref_out == test_out)
                error = 0;
            else
                error = 1;

            Tot_errors = Tot_errors + error;
            $display ("Time = %5d, MC = %h, MP = %h, test_out = %h, ref_out = %h, Error = %h, T_Errors = %0d", $time, MC, MP, test_out, ref_out, error, Tot_errors);
        end
    end 
    $finish;
end

// Module instances
booth_mult booth_mult_i(
    .A(MP),
    .B(MC),
    .P(test_out)
);

endmodule
