module register
  (
   input        debug,
   input        rst,
   input        data_load,
   input        data_send,
   input [7:0]  bus,
   output [7:0] bus_out,
   output [7:0] unbuffered_out
   );

   reg [7:0]   data;

   assign bus_out = data_send ? data : 8'bzzzzzzzz;
   assign unbuffered_out = data;

   always @(bus or posedge data_load) begin
      if(data_load) begin
        if(debug) $display("Register loaded: %b", bus);
        data <= bus;
      end
   end

   always @(posedge rst) begin
      data <= 8'bzzzzzzzz;
   end


endmodule
