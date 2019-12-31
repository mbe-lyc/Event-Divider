module event_divider #(parameter N = 2) (
    input clk,
    input in,
    output out
    );
    
reg [N-1:0] shift;
reg act;

wire in_buf, in_buf2;
dff in_buff( .clk(clk), .in(in), .out(in_buf) );
dff in_buff2( .clk(clk), .in(in_buf), .out(in_buf2) );
wire in_edge;
assign in_edge = in_buf & (~in_buf2);

always @(posedge clk) begin
    if( (in_edge & act) == 1'd1 ) begin
        act <= 1'd0;
    end
    else if( shift[N-1] == 1'd0 ) begin
        act <= 1'd0;
    end
    else if( in == 1'd0 ) begin
        act <= 1'd1;
    end
end    
    
genvar i;        
generate 
    for(i = 0; i < N; i=i+1) begin: _shift
        always @(posedge clk) begin
            if( (in_edge & act) == 1'd1 ) begin
                if(i!=0) shift[i] <= 1'd0;
                else shift[i] <= 1'd1;
            end
            else if( in_edge == 1'd1) begin
                if(i!=0) shift[i] <= shift[i-1];
                else shift[i] <= 1'd1;
            end
        end
    end
endgenerate

assign out = in & act;    