//testbench for tpumac module

module tpumac_tb();

	logic clk, rst_n, WrEn, en, failed;
        logic signed [7:0] Ain, Bin,  Aout, Bout;
        logic signed [15:0] Cin, Cout;

tpumac DUT(.clk(clk), .rst_n(rst_n), .WrEn(WrEn), .en(en),
           .Ain(Ain), .Bin(Bin), .Cin(Cin), .Aout(Aout), .Bout(Bout),
           .Cout(Cout));


initial begin

  // initialize values
  clk = 1'b0;
  rst_n = 1'b0;
  Cin = 16'h0000;
  Ain = 8'h00;
  Bin = 8'h00;
  WrEn = 1'b0;
  en = 1'b0;
  failed = 1'b0;

  @(posedge clk)
  
  rst_n = 1'b1;

  @(posedge clk)

  // write 4321 to C
  WrEn = 1'b1;
  en = 1'b1;
  Cin = 16'h4321;

  @(posedge clk);
  @(negedge clk);

  // check 4321 was written to C
  if(Cout != 16'h4321) begin
    $display("Failed to write initial value");
    failed = 1'b1;
    end
  
  // try to write to Cout Aout and Bout  but with enable low so it should not work
  en = 1'b0;
  WrEn = 1'b0;
  Cin = 16'hFFFF;
  Ain = 8'hC6;
  Bin = 8'h2F;

  @(posedge clk);


  // confirm that registers were not written too (should be low from rst)
  if(Cout != 16'h4321) begin
    failed = 1'b1;
    $display("Cout updated with en low");
    end

    if(Aout != 8'h00) begin
    failed = 1'b1;
    $display("A reg updated with en low");
    end

    if(Bout != 8'h00) begin
    failed = 1'b1;
    $display("B reg updated with en low");
    end

  // set enable high and change Cin to old value
  Cin = 16'h4321;
  en = 1'b1;
  @(posedge clk);
  @(negedge clk);

  // now that en is high the registers should be updated also confirming correct calculation for Cout
  if(Cout != 16'h387B) begin
    failed = 1'b1;
    $display("Calculation incorrect");
    end
 
    if(Aout != 8'hC6) begin
    failed = 1'b1;
    $display("A reg not updated en high");
    end

    if(Bout != 8'h2F) begin
    failed = 1'b1;
    $display("B reg not updated  en high");
    end


  // new value for Cin
  WrEn = 1'b1;
  Cin = 16'hF7C2;
  @(posedge clk);

  WrEn = 1'b0;
  Ain = 8'hDD;
  Bin = 8'hF7;

  @(posedge clk);
  @(negedge clk);
  
  // check calculation with new Cin value
  if(Cout != 16'hF8FD) begin
    failed = 1'b1;
    $display("Calculation incorrect");
    end


  if(!failed) begin
    $display("YAHOO!!! All tests passed.");
    end

  $stop;
 
end

always #5 clk = ~clk; 

endmodule
