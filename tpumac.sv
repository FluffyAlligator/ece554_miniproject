
// Spec v1.1
module tpumac
 #(parameter BITS_AB=8,
   parameter BITS_C=16)
  (
   input clk, rst_n, WrEn, en,
   input signed [BITS_AB-1:0] Ain,
   input signed [BITS_AB-1:0] Bin,
   input signed [BITS_C-1:0] Cin,
   output reg signed [BITS_AB-1:0] Aout,
   output reg signed [BITS_AB-1:0] Bout,
   output reg signed [BITS_C-1:0] Cout
  );
// NOTE: added register enable in v1.1
// Also, Modelsim prefers "reg signed" over "signed reg"

reg signed [BITS_C-1:0] Multout, Addout, cxxin;


//8b regs for Aout and Bout
always_ff @(posedge clk, negedge rst_n)
  begin
  if(!rst_n) begin
    Aout <= 0;
    Bout <= 0;
  end else begin
  if(en)
    begin
      Aout <= Ain;
      Bout <= Bin;
    end
  else
    begin
      Aout <= Aout;
      Bout<= Bout;
    end
  end
end

always_ff @(posedge clk, negedge rst_n)
  begin
  if(!rst_n) begin
    Cout <= 0;
  end else begin
  if(en)
    begin
      Cout <= cxxin;
    end
  else
    begin
      Cout <= Cout;
    end
  end
end

//multiplier
assign Multout = Ain * Bin;

//adder
assign Addout = Multout + Cout;

//mux
assign cxxin = (WrEn) ? Cin : Addout;



endmodule