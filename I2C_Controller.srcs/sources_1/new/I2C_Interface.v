`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2024 21:45:43
// Design Name: 
// Module Name: I2C_Interface
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module I2C_Interface(
        input clk,
        input rst,
        input [7:0] data_byte,
        input [6:0] address_in,
        input read_write,
        input go,

        inout SDA_PIN,
        inout SCL_PIN,

        output done
    );



    localparam IDLE = 3'b000;
    localparam START = 3'b001;
    localparam ADDRESS = 3'b010;
    localparam DATA_BIT = 3'b011;
    localparam STOP = 3'b100;
    localparam WAIT_FOR_ACK = 3'b101;
    localparam READWRITE_STATE = 3'b110;
    localparam CLEAN_UP =3'b111;

    reg [3:0] state = 0, _state;

    reg serial_data_out = 1 , _serial_data_out;
    reg serial_clock_out = 1, _serial_clock_out;
    reg serial_clock_enable, _serial_clock_enable;
    reg serial_data_enable, _serial_data_enable;

    reg [3:0] idx = 0, _idx;

    reg [2:0] process_state = 0, _process_state; 
    reg div_clk = 0;
    wire scl_lo, scl_hi;
    reg ack;

    reg [9:0] div_count = 0;
    localparam  maxCount = 1000;
    always @(posedge clk) begin
        if ( div_count < maxCount -1)begin
            div_count <= div_count + 1;
        end else begin
            div_count <= 0;
            div_clk <= ~div_clk;
        end
        
    end
    always @(posedge div_clk) begin
        state <= _state;
        serial_data_out <= _serial_data_out;
        serial_clock_out <= _serial_clock_out;
        idx <= _idx;
        process_state <= _process_state;
        serial_data_enable <= _serial_data_enable;
        serial_clock_enable <= _serial_clock_enable;
    end

    always @(posedge div_clk or posedge rst) begin
        if (rst == 1'b1)begin
            
        end
    end

    always @(*) begin
        

        case(state)
            IDLE:begin
                _serial_data_out = 1'b1;
                _serial_clock_out = 1'b1;
                if (go == 1'b1)begin
                    _state = START;
                end else begin
                    _state <= IDLE;
                end
                
            end
            
            START:begin
                case(process_state)
                    0:begin
                        _process_state = 1;
                    end
                    1:begin
                        _serial_data_out = 1'b0;
                        _serial_clock_out = 1'b1;
                        _process_state = 2;
                    end
                    2:begin
                        _process_state = 3;
                    end
                    3:begin
                        _serial_clock_out = 1'b0;
                        _state = ADDRESS;
                        _idx = 6;
                        _process_state = 0;
                    end
                    default: process_state <= 0;
                endcase

            end

            ADDRESS:begin
                case(process_state)
                    0:begin
                        _process_state = 1;
                        _serial_data_out = (address_in[idx] == 0)?1'b0:1'b1;

                    end
                    1:begin
                        
                        _serial_clock_out = 1'b1;
                        _process_state = 2;
                    end
                    2:begin
                        
                        _process_state = 3;
                    end
                    3:begin
                        _serial_clock_out = 1'b0;
                        _idx = idx - 1;
                        _process_state = 0;
                        if(idx == 0)begin
                            _idx = 0;
                            _state = READWRITE_STATE;
                        end else begin
                            _state = ADDRESS;
                        end
                        
                        
                    end
                    default: process_state <= 0;
            
                endcase
            end

            READWRITE_STATE:begin
                case(process_state)
                    0:begin
                        _process_state = 1;
                        _serial_data_out = (read_write == 0)? 1'b0:1'b1
                    end
                    1:begin
                        _process_state = 2;
                        _serial_clock_out = 1'b1;
                    end
                    2:begin
                        _process_state = 3;
                       
                    end
                    3:begin
                        _serial_clock_out = 1'b0;
                        _process_state = 0;
                        _state = WAIT_FOR_ACK;
                    end

                

                    default: process_state <= 0;
                endcase
            end 

            WAIT_FOR_ACK:begin
                case(process_state)
                    0:begin
                        _serial_data_out = 1'bz;
                        _process_state = 1;
                    end
                    1:begin
                        _process_state = 2;
                        _serial_clock_out = 1'b1;
                    end
                    2:begin
                        ack = serial_data_out; 
                        _process_state = 3;
                    end
                    3:begin
                        _seiral_clock_out = 1'b0;
                        _process_state = 0;
                        if (ack == 1'b1)begin //ack
                            _idx = 7;
                            _state = DATA_BIT;
                        end else begin //nack
                            _state = STOP;
                        end
                    end

                    default: process_state <= 0;
                endcase
            end

            DATA_BIT:begin
                case(process_state)
                    0:begin
                        _serial_data_out = (data_byte[idx]==0)? 1'b0:1'b1;
                        _process_state = 1;
                    end
                    1:begin
                        _serial_clock_out = 1;
                        _process_state = 2
                    end
                    2:begin
                        _process_state = 3;
                    end
                    3:begin
                        _process_state =0;
                        _idx = idx - 1;
                        if (idx == 0)begin
                            _idx = 0;
                            _state <= WAIT_FOR_ACK;
                        end else begin
                            _state <= DATA_BIT;
                        end
                    end
                    
                    default: process_state <= 0;
                endcase
            end

            STOP:begin
                
            end
        endcase


    end

endmodule
