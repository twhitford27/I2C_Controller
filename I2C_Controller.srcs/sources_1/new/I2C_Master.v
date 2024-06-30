`timescale 1ns / 1ps

module I2C_Master #(parameter main_clock=25_000_000, freq=100_000, addr_bytes_in=2)  (
        input wire clk,
        input wire rst,
        input wire[7:0] data_in,
        input [6:0] addr_in,
        input send,
        input read_write,

        output reg [1:0] ack,
        output SDA_PIN,
        output SCL_PIN,
        output [3:0] done_state
        
    );


    localparam full= (main_clock)/(2*freq);
    localparam half= full/2;
    localparam counter_width=log2(full);


    function integer log2(input integer n); //automatically determines the width needed by counter
    integer i;
     begin
        log2=1;
        for(i=0;2**i<n;i=i+1)
            log2=i+1;
     end
    endfunction
    //states 

    localparam IDLE = 3'b000;
    localparam START = 3'b001;
    localparam PACKET = 3'b010;
    localparam DATA_BIT = 3'b011;
    localparam STOP = 3'b100;
    localparam WAIT_FOR_ACK = 3'b101;
    localparam CLEAN_UP =3'b111;

    reg [2:0] state = 3'b000;
    reg [2:0] _state = 3'b000;
    reg op = 0;
    reg _op;

    reg [3:0] adr_idx = 4'd6;
    reg [3:0] _adr_idx;
    reg [3:0] idx = 4'd7;
    reg [3:0] _idx;

    reg [7:0] wr_data = 0;
    reg [7:0] _wr_data;

    reg scl = 1;
    reg _scl;
    reg sda = 1;
    reg _sda;

    reg[counter_width -1 :0] counter = 0;
    reg[counter_width -1: 0] _counter;
    reg [1:0] addr_btyes = 0;
    reg [1:0] _addr_bytes;

    wire scl_lo, scl_hi;
    wire sda_in;

    always @(posedge clk) begin
        state <= _state;
        op <= _op;
        adr_idx <= _adr_idx;
        data_idx <= _data_idx;
        wr_data <= _wr_data;
        scl <= _scl;
        sda <= _sda;
        counter <= _counter;
        addr_btyes <= _addr_bytes;
    end

    always @(*) begin
        _counter = counter + 1;
        _scl = scl;
        if(state == IDLE || state == START)begin
            _scl = 1'b1;
        end else begin
            _counter = 0;
            _scl = (scl == 0)?1'b1:1'b0;
        end
    end

    //start FSM logic

    always @(*) begin
        
        _state = state;
        _op = op;
        _adr_idx = adr_idx;
        _idx = idx;
        _wr_data = wr_data;
        _addr_bytes = addr_btyes;
        _sda = sda;
        ack = 0;

        case(state)
            IDLE:begin
                _sda = 1'b1;
                _addr_bytes = addr_bytes_in;
                if (send == 1'b1)begin
                    _wr_data = {wr_data,1'b1};
                    _op = (wr_data[0])?1:0;
                    _idx = 8;
                    _state = START;
                end
            end

            START:begin
                if(scl_hi)begin
                    _sda = 0;
                    _state = PACKET;
                end
            end

            PACKET:begin
                if(scl_lo)begin
                    _sda = (wr_data[idx]==0)?0:1'b1;
                    _idx = idx - 1;
                    if (idx == 0)begin
                        _state = WAIT_FOR_ACK;
                        _idx = 0;
                    end
                end
            end

            WAIT_FOR_ACK:begin
                if(scl_hi)begin
                    ack[1] = 1;
                    ack[0] = !sda_in;
                    _wr_data={wr_data,1'b1};
                    _addr_bytes = addr_btyes - 1;
                    if()
                end
            end

        endcase
    end


assign SCL_PIN = scl;
assign SDA_PIN = sda;
assign sda_in = SDA_PIN;

assign scl_hi = scl==1'b1 && counter==half && scl==1'b1;
assign scl_lo = scl_q == 1'b0 && counter==half;


assign done_state = state;

endmodule
