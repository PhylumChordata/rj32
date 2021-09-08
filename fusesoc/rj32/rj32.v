/*
 * Generated by Digital. Don't modify this file!
 * Any changes will be lost if this file is regenerated.
 */

module rj32_DIG_D_FF_AS_1bit
#(
    parameter Default = 0
)
(
   input Set,
   input D,
   input C,
   input Clr,
   output Q,
   output \~Q
);
    reg state;

    assign Q = state;
    assign \~Q  = ~state;

    always @ (posedge C or posedge Clr or posedge Set)
    begin
        if (Set)
            state <= 1'b1;
        else if (Clr)
            state <= 'h0;
        else
            state <= D;
    end

    initial begin
        state = Default;
    end
endmodule

module rj32_DIG_Counter_Nbit
#(
    parameter Bits = 2
)
(
    output [(Bits-1):0] out,
    output ovf,
    input C,
    input en,
    input clr
);
    reg [(Bits-1):0] count;

    always @ (posedge C) begin
        if (clr)
          count <= 'h0;
        else if (en)
          count <= count + 1'b1;
    end

    assign out = count;
    assign ovf = en? &count : 1'b0;

    initial begin
        count = 'h0;
    end
endmodule


module rj32_Mux_2x1
(
    input [0:0] sel,
    input in_0,
    input in_1,
    output reg out
);
    always @ (*) begin
        case (sel)
            1'h0: out = in_0;
            1'h1: out = in_1;
            default:
                out = 'h0;
        endcase
    end
endmodule

module rj32_DIG_D_FF_1bit
#(
    parameter Default = 0
)
(
   input D,
   input C,
   output Q,
   output \~Q
);
    reg state;

    assign Q = state;
    assign \~Q = ~state;

    always @ (posedge C) begin
        state <= D;
    end

    initial begin
        state = Default;
    end
endmodule


module rj32_clockctrl (
  input clock,
  input step,
  input slow,
  input fast,
  input faster,
  input efast,
  output stall
);
  wire s0;
  wire s1;
  wire s2;
  wire s3;
  wire s4;
  wire s5;
  wire [22:0] s6;
  wire s7;
  wire s8;
  wire s9;
  wire s10;
  wire s11;
  rj32_DIG_D_FF_AS_1bit #(
    .Default(0)
  )
  DIG_D_FF_AS_1bit_i0 (
    .Set( 1'b0 ),
    .D( s3 ),
    .C( clock ),
    .Clr( step ),
    .Q( s4 )
  );
  assign s3 = (s4 | slow);
  rj32_DIG_Counter_Nbit #(
    .Bits(23)
  )
  DIG_Counter_Nbit_i1 (
    .en( s4 ),
    .C( clock ),
    .clr( step ),
    .out( s6 )
  );
  assign s5 = (s7 | step);
  rj32_DIG_D_FF_AS_1bit #(
    .Default(0)
  )
  DIG_D_FF_AS_1bit_i2 (
    .Set( 1'b0 ),
    .D( s10 ),
    .C( clock ),
    .Clr( step ),
    .Q( s11 )
  );
  assign s10 = (fast | efast | s11);
  rj32_Mux_2x1 Mux_2x1_i3 (
    .sel( faster ),
    .in_0( s8 ),
    .in_1( s9 ),
    .out( s7 )
  );
  rj32_DIG_D_FF_AS_1bit #(
    .Default(0)
  )
  DIG_D_FF_AS_1bit_i4 (
    .Set( s5 ),
    .D( 1'b0 ),
    .C( clock ),
    .Clr( 1'b0 ),
    .Q( s1 )
  );
  assign s8 = s6[22];
  assign s9 = s6[8];
  rj32_DIG_D_FF_1bit #(
    .Default(0)
  )
  DIG_D_FF_1bit_i5 (
    .D( s1 ),
    .C( clock ),
    .\~Q ( s2 )
  );
  assign s0 = ((s1 & s2) | s11);
  rj32_DIG_D_FF_1bit #(
    .Default(0)
  )
  DIG_D_FF_1bit_i6 (
    .D( s0 ),
    .C( clock ),
    .\~Q ( stall )
  );
endmodule

module rj32_Mux_2x1_NBits #(
    parameter Bits = 2
)
(
    input [0:0] sel,
    input [(Bits - 1):0] in_0,
    input [(Bits - 1):0] in_1,
    output reg [(Bits - 1):0] out
);
    always @ (*) begin
        case (sel)
            1'h0: out = in_0;
            1'h1: out = in_1;
            default:
                out = 'h0;
        endcase
    end
endmodule


module rj32_DIG_CounterPreset #(
    parameter Bits = 2,
    parameter maxValue = 4
)
(
    input C,
    input en,
    input clr,
    input dir,
    input [(Bits-1):0] in,
    input ld,
    output [(Bits-1):0] out,
    output ovf
);

    reg [(Bits-1):0] count = 'h0;

    function [(Bits-1):0] maxVal (input [(Bits-1):0] maxv);
        if (maxv == 0)
            maxVal = (1 << Bits) - 1;
        else
            maxVal = maxv;
    endfunction

    assign out = count;
    assign ovf = ((count == maxVal(maxValue) & dir == 1'b0)
                  | (count == 'b0 & dir == 1'b1))? en : 1'b0;

    always @ (posedge C) begin
        if (clr == 1'b1)
            count <= 'h0;
        else if (ld == 1'b1)
            count <= in;
        else if (en == 1'b1) begin
            if (dir == 1'b0) begin
                if (count == maxVal(maxValue))
                    count <= 'h0;
                else
                    count <= count + 1'b1;
            end
            else begin
                if (count == 'h0)
                    count <= maxVal(maxValue);
                else
                    count <= count - 1;
            end
        end
    end
endmodule


module rj32_DIG_Register_BUS #(
    parameter Bits = 1
)
(
    input C,
    input en,
    input [(Bits - 1):0]D,
    output [(Bits - 1):0]Q
);

    reg [(Bits - 1):0] state = 'h0;

    assign Q = state;

    always @ (posedge C) begin
        if (en)
            state <= D;
   end
endmodule

module rj32_fetch (
  input [15:0] result,
  input [15:0] instr_i,
  input clock,
  input fetch,
  input jump,
  input en,
  output [15:0] instr_o,
  output [15:0] pc
);
  wire s0;
  wire s1;
  wire [15:0] s2;
  assign s1 = (jump & en);
  assign s0 = (fetch & s1);
  rj32_Mux_2x1_NBits #(
    .Bits(16)
  )
  Mux_2x1_NBits_i0 (
    .sel( s1 ),
    .in_0( instr_i ),
    .in_1( 16'b0 ),
    .out( s2 )
  );
  // PC
  rj32_DIG_CounterPreset #(
    .Bits(16),
    .maxValue(0)
  )
  DIG_CounterPreset_i1 (
    .en( fetch ),
    .C( clock ),
    .dir( 1'b0 ),
    .in( result ),
    .ld( s0 ),
    .clr( 1'b0 ),
    .out( pc )
  );
  // IR
  rj32_DIG_Register_BUS #(
    .Bits(16)
  )
  DIG_Register_BUS_i2 (
    .D( s2 ),
    .C( clock ),
    .en( fetch ),
    .Q( instr_o )
  );
endmodule

module rj32_DIG_Register
(
    input C,
    input en,
    input D,
    output Q
);

    reg  state = 'h0;

    assign Q = state;

    always @ (posedge C) begin
        if (en)
            state <= D;
   end
endmodule

module rj32_CompUnsigned #(
    parameter Bits = 1
)
(
    input [(Bits -1):0] a,
    input [(Bits -1):0] b,
    output \> ,
    output \= ,
    output \<
);
    assign \> = a > b;
    assign \= = a == b;
    assign \< = a < b;
endmodule


module rj32_mcsequencer (
  input [4:0] op,
  input clock,
  input en,
  input [2:0] flags,
  input [2:0] fmask,
  input [4:0] next_t,
  input [4:0] next_f,
  output [5:0] uop,
  output \~nbusy ,
  output busy
);
  wire [4:0] s0;
  wire [4:0] s1;
  wire s2;
  wire [4:0] s3;
  wire s4;
  wire \~nbusy_temp ;
  wire s5;
  wire s6;
  wire [2:0] s7;
  assign s7 = (flags & fmask);
  // true?
  rj32_CompUnsigned #(
    .Bits(3)
  )
  CompUnsigned_i0 (
    .a( s7 ),
    .b( fmask ),
    .\= ( s6 )
  );
  rj32_Mux_2x1_NBits #(
    .Bits(5)
  )
  Mux_2x1_NBits_i1 (
    .sel( s6 ),
    .in_0( next_f ),
    .in_1( next_t ),
    .out( s0 )
  );
  // step
  rj32_DIG_Register_BUS #(
    .Bits(5)
  )
  DIG_Register_BUS_i2 (
    .D( s0 ),
    .C( clock ),
    .en( en ),
    .Q( s1 )
  );
  // ~nbusy?
  rj32_CompUnsigned #(
    .Bits(5)
  )
  CompUnsigned_i3 (
    .a( s0 ),
    .b( 5'b0 ),
    .\= ( s4 )
  );
  // op?
  rj32_CompUnsigned #(
    .Bits(5)
  )
  CompUnsigned_i4 (
    .a( s1 ),
    .b( 5'b0 ),
    .\= ( s2 )
  );
  assign \~nbusy_temp  = (s4 | ~ en);
  rj32_Mux_2x1_NBits #(
    .Bits(5)
  )
  Mux_2x1_NBits_i5 (
    .sel( s2 ),
    .in_0( s1 ),
    .in_1( op ),
    .out( s3 )
  );
  assign s5 = ~ \~nbusy_temp ;
  assign uop[4:0] = s3;
  assign uop[5] = ~ s2;
  // busy?
  rj32_DIG_Register DIG_Register_i6 (
    .D( s5 ),
    .C( clock ),
    .en( en ),
    .Q( busy )
  );
  assign \~nbusy  = \~nbusy_temp ;
endmodule
module rj32_DIG_ROM_64X32_Microcode (
    input [5:0] A,
    input sel,
    output reg [31:0] D
);
    reg [31:0] my_rom [0:38];

    always @ (*) begin
        if (~sel)
            D = 32'hz;
        else if (A > 6'h26)
            D = 32'h0;
        else
            D = my_rom[A];
    end

    initial begin
        my_rom[0] = 32'h0;
        my_rom[1] = 32'h0;
        my_rom[2] = 32'h8400002;
        my_rom[3] = 32'h10800001;
        my_rom[4] = 32'h34;
        my_rom[5] = 32'h0;
        my_rom[6] = 32'h700;
        my_rom[7] = 32'h0;
        my_rom[8] = 32'h0;
        my_rom[9] = 32'h4;
        my_rom[10] = 32'h304;
        my_rom[11] = 32'h0;
        my_rom[12] = 32'h20c80040;
        my_rom[13] = 32'h314800c0;
        my_rom[14] = 32'h540;
        my_rom[15] = 32'hc0;
        my_rom[16] = 32'h100;
        my_rom[17] = 32'h108;
        my_rom[18] = 32'h100;
        my_rom[19] = 32'h108;
        my_rom[20] = 32'h128;
        my_rom[21] = 32'h130;
        my_rom[22] = 32'h138;
        my_rom[23] = 32'h118;
        my_rom[24] = 32'h110;
        my_rom[25] = 32'h120;
        my_rom[26] = 32'h808;
        my_rom[27] = 32'h1008;
        my_rom[28] = 32'h1808;
        my_rom[29] = 32'h2008;
        my_rom[30] = 32'h2808;
        my_rom[31] = 32'h3008;
        my_rom[32] = 32'h0;
        my_rom[33] = 32'h8400002;
        my_rom[34] = 32'h10800001;
        my_rom[35] = 32'h500;
        my_rom[36] = 32'h20c80040;
        my_rom[37] = 32'h0;
        my_rom[38] = 32'h314800c0;
    end
endmodule


module rj32_control (
  input [4:0] op,
  input stall,
  input clock,
  input skip_n,
  input ack,
  output [2:0] aluop,
  output [2:0] cond,
  output skip,
  output halt,
  output error,
  output en_write,
  output mem,
  output store,
  output en_fetch,
  output jump,
  output write,
  output [1:0] wrmux
);
  wire skip_temp;
  wire en_write_temp;
  wire en_skip;
  wire [5:0] s0;
  wire [31:0] s1;
  wire [2:0] s2;
  wire [4:0] s3;
  wire [4:0] s4;
  wire [2:0] flags;
  wire \~nbusy_t ;
  wire busy;
  assign flags[0] = ack;
  assign flags[1] = 1'b0;
  assign flags[2] = 1'b0;
  // skip
  rj32_DIG_Register DIG_Register_i0 (
    .D( skip_n ),
    .C( clock ),
    .en( en_skip ),
    .Q( skip_temp )
  );
  rj32_mcsequencer mcsequencer_i1 (
    .op( op ),
    .clock( clock ),
    .en( en_write_temp ),
    .flags( flags ),
    .fmask( s2 ),
    .next_t( s3 ),
    .next_f( s4 ),
    .uop( s0 ),
    .\~nbusy ( \~nbusy_t  ),
    .busy( busy )
  );
  assign en_skip = (~ stall | busy);
  assign en_write_temp = (~ skip_temp & en_skip);
  // Microcode
  rj32_DIG_ROM_64X32_Microcode DIG_ROM_64X32_Microcode_i2 (
    .A( s0 ),
    .sel( 1'b1 ),
    .D( s1 )
  );
  assign en_fetch = (en_skip & \~nbusy_t );
  assign halt = (en_write_temp & s1[0]);
  assign error = (s1[1] & en_write_temp);
  assign jump = s1[2];
  assign aluop = s1[5:3];
  assign mem = s1[6];
  assign store = s1[7];
  assign write = s1[8];
  assign wrmux = s1[10:9];
  assign cond = s1[13:11];
  assign s2 = s1[21:19];
  assign s3 = s1[26:22];
  assign s4 = s1[31:27];
  assign skip = skip_temp;
  assign en_write = en_write_temp;
endmodule

module rj32_Mux_4x1_NBits #(
    parameter Bits = 2
)
(
    input [1:0] sel,
    input [(Bits - 1):0] in_0,
    input [(Bits - 1):0] in_1,
    input [(Bits - 1):0] in_2,
    input [(Bits - 1):0] in_3,
    output reg [(Bits - 1):0] out
);
    always @ (*) begin
        case (sel)
            2'h0: out = in_0;
            2'h1: out = in_1;
            2'h2: out = in_2;
            2'h3: out = in_3;
            default:
                out = 'h0;
        endcase
    end
endmodule


module rj32_writeback (
  input [15:0] L,
  input [15:0] R,
  input [15:0] result,
  input [15:0] rdval,
  input [15:0] D,
  input [1:0] wrmux,
  output [15:0] wrval,
  output [15:0] result_out,
  output [15:0] rdval_out
);
  rj32_Mux_4x1_NBits #(
    .Bits(16)
  )
  Mux_4x1_NBits_i0 (
    .sel( wrmux ),
    .in_0( result ),
    .in_1( L ),
    .in_2( D ),
    .in_3( R ),
    .out( wrval )
  );
  assign result_out = result;
  assign rdval_out = rdval;
endmodule

module rj32_memaccess (
  input [15:0] result,
  input [15:0] rdval,
  input store,
  input en,
  output [15:0] A,
  output str,
  output [15:0] D_in
);
  assign str = (store & en);
  assign A = result;
  assign D_in = rdval;
endmodule

module rj32_Decoder2 (
    output out_0,
    output out_1,
    output out_2,
    output out_3,
    input [1:0] sel
);
    assign out_0 = (sel == 2'h0)? 1'b1 : 1'b0;
    assign out_1 = (sel == 2'h1)? 1'b1 : 1'b0;
    assign out_2 = (sel == 2'h2)? 1'b1 : 1'b0;
    assign out_3 = (sel == 2'h3)? 1'b1 : 1'b0;
endmodule


module rj32_Demux1
(
    output out_0,
    output out_1,
    input [0:0] sel,
    input in
);
    assign out_0 = (sel == 1'h0)? in : 'd0;
    assign out_1 = (sel == 1'h1)? in : 'd0;
endmodule


module rj32_instdecoder (
  input [1:0] fmt,
  input [4:0] op0,
  output [4:0] op,
  output rd_valid,
  output rs_valid,
  output imm_valid,
  output mem,
  output i11
);
  wire rr;
  wire s0;
  wire mem_temp;
  wire ri6;
  wire [4:0] s1;
  wire [4:0] s2;
  wire [4:0] s3;
  wire [4:0] s4;
  wire i11_temp;
  wire s5;
  wire ri8;
  wire [4:0] s6;
  rj32_Decoder2 Decoder2_i0 (
    .sel( fmt ),
    .out_0( rr ),
    .out_1( s0 ),
    .out_2( mem_temp ),
    .out_3( ri6 )
  );
  assign s2[1:0] = op0[1:0];
  assign s2[4:2] = 3'b11;
  assign s4[0] = op0[1];
  assign s4[4:1] = 4'b11;
  assign s3[3:0] = op0[3:0];
  assign s3[4] = 1'b1;
  assign s6[1:0] = op0[2:1];
  assign s6[4:2] = 3'b10;
  assign s5 = op0[0];
  assign rs_valid = (mem_temp | rr);
  assign imm_valid = ~ (rr | mem_temp);
  rj32_Demux1 Demux1_i1 (
    .sel( s5 ),
    .in( s0 ),
    .out_0( ri8 ),
    .out_1( i11_temp )
  );
  rj32_Mux_2x1_NBits #(
    .Bits(5)
  )
  Mux_2x1_NBits_i2 (
    .sel( s5 ),
    .in_0( s4 ),
    .in_1( s6 ),
    .out( s1 )
  );
  rj32_Mux_4x1_NBits #(
    .Bits(5)
  )
  Mux_4x1_NBits_i3 (
    .sel( fmt ),
    .in_0( op0 ),
    .in_1( s1 ),
    .in_2( s2 ),
    .in_3( s3 ),
    .out( op )
  );
  assign rd_valid = ~ i11_temp;
  assign mem = mem_temp;
  assign i11 = i11_temp;
endmodule
module rj32_DIG_BitExtender #(
    parameter inputBits = 2,
    parameter outputBits = 4
)
(
    input [(inputBits-1):0] in,
    output [(outputBits - 1):0] out
);
    assign out = {{(outputBits - inputBits){in[inputBits - 1]}}, in};
endmodule




module rj32_decoder (
  input [15:0] rdval,
  input [15:0] rsval,
  input [15:0] instr,
  input [15:0] pc,
  input jump,
  output [3:0] rs,
  output [3:0] rd,
  output [15:0] L,
  output [15:0] R,
  output [4:0] op,
  output rs_valid,
  output rd_valid,
  output [15:0] imm,
  output immv
);
  wire [1:0] fmt;
  wire [4:0] op0;
  wire rd_valid_temp;
  wire rs_valid_temp;
  wire imm_valid;
  wire mem;
  wire i11;
  wire [3:0] rs_i;
  wire [3:0] rd_i;
  wire [5:0] s0;
  wire [7:0] s1;
  wire [10:0] s2;
  wire [15:0] imm11;
  wire [15:0] imm6;
  wire [15:0] imm_temp;
  wire [15:0] s3;
  wire [15:0] imm8;
  wire [15:0] off4;
  wire [15:0] s4;
  assign off4[3:0] = instr[7:4];
  assign off4[15:4] = 12'b0;
  rj32_Mux_2x1_NBits #(
    .Bits(16)
  )
  Mux_2x1_NBits_i0 (
    .sel( jump ),
    .in_0( rdval ),
    .in_1( pc ),
    .out( s3 )
  );
  assign fmt = instr[1:0];
  assign op0 = instr[6:2];
  assign rs_i = instr[11:8];
  assign rd_i = instr[15:12];
  assign s0 = instr[11:6];
  assign s1 = instr[11:4];
  assign s2 = instr[15:5];
  rj32_instdecoder instdecoder_i1 (
    .fmt( fmt ),
    .op0( op0 ),
    .op( op ),
    .rd_valid( rd_valid_temp ),
    .rs_valid( rs_valid_temp ),
    .imm_valid( imm_valid ),
    .mem( mem ),
    .i11( i11 )
  );
  rj32_DIG_BitExtender #(
    .inputBits(11),
    .outputBits(16)
  )
  DIG_BitExtender_i2 (
    .in( s2 ),
    .out( imm11 )
  );
  rj32_DIG_BitExtender #(
    .inputBits(6),
    .outputBits(16)
  )
  DIG_BitExtender_i3 (
    .in( s0 ),
    .out( imm6 )
  );
  rj32_DIG_BitExtender #(
    .inputBits(8),
    .outputBits(16)
  )
  DIG_BitExtender_i4 (
    .in( s1 ),
    .out( imm8 )
  );
  rj32_Mux_2x1_NBits #(
    .Bits(4)
  )
  Mux_2x1_NBits_i5 (
    .sel( rd_valid_temp ),
    .in_0( 4'b0 ),
    .in_1( rd_i ),
    .out( rd )
  );
  rj32_Mux_2x1_NBits #(
    .Bits(4)
  )
  Mux_2x1_NBits_i6 (
    .sel( rs_valid_temp ),
    .in_0( 4'b0 ),
    .in_1( rs_i ),
    .out( rs )
  );
  assign immv = (imm_valid | mem);
  rj32_Mux_2x1_NBits #(
    .Bits(16)
  )
  Mux_2x1_NBits_i7 (
    .sel( i11 ),
    .in_0( imm8 ),
    .in_1( imm11 ),
    .out( s4 )
  );
  rj32_Mux_4x1_NBits #(
    .Bits(16)
  )
  Mux_4x1_NBits_i8 (
    .sel( fmt ),
    .in_0( 16'b0 ),
    .in_1( s4 ),
    .in_2( off4 ),
    .in_3( imm6 ),
    .out( imm_temp )
  );
  rj32_Mux_2x1_NBits #(
    .Bits(16)
  )
  Mux_2x1_NBits_i9 (
    .sel( imm_valid ),
    .in_0( rsval ),
    .in_1( imm_temp ),
    .out( R )
  );
  rj32_Mux_2x1_NBits #(
    .Bits(16)
  )
  Mux_2x1_NBits_i10 (
    .sel( mem ),
    .in_0( s3 ),
    .in_1( imm_temp ),
    .out( L )
  );
  assign rs_valid = rs_valid_temp;
  assign rd_valid = rd_valid_temp;
  assign imm = imm_temp;
endmodule
module rj32_DIG_BitExtenderSingle #(
    parameter outputBits = 2
)
(
    input in,
    output [(outputBits - 1):0] out
);
    assign out = {outputBits{in}};
endmodule



module rj32_DIG_Add
#(
    parameter Bits = 1
)
(
    input [(Bits-1):0] a,
    input [(Bits-1):0] b,
    input c_i,
    output [(Bits - 1):0] s,
    output c_o
);
   wire [Bits:0] temp;

   assign temp = a + b + c_i;
   assign s = temp [(Bits-1):0];
   assign c_o = temp[Bits];
endmodule



module rj32_funnelshifter (
  input [15:0] I,
  input [3:0] amt,
  input dir,
  input arith,
  output [15:0] O
);
  wire [1:0] s0;
  wire [15:0] s1;
  wire [15:0] s2;
  wire [15:0] s3;
  wire [15:0] s4;
  wire [15:0] s5;
  wire [18:0] s6;
  wire [1:0] s7;
  wire [18:0] s8;
  wire [18:0] s9;
  wire [18:0] s10;
  wire [18:0] s11;
  wire [30:0] s12;
  wire [3:0] s13;
  wire [15:0] s14;
  wire [15:0] s15;
  wire [31:0] s16;
  wire [3:0] s17;
  wire s18;
  wire [3:0] s19;
  wire [15:0] s20;
  wire s21;
  wire [15:0] s22;
  assign s19 = ~ amt;
  assign s21 = I[15];
  rj32_Mux_2x1_NBits #(
    .Bits(4)
  )
  Mux_2x1_NBits_i0 (
    .sel( dir ),
    .in_0( amt ),
    .in_1( s19 ),
    .out( s17 )
  );
  rj32_DIG_BitExtenderSingle #(
    .outputBits(16)
  )
  DIG_BitExtenderSingle_i1 (
    .in( s21 ),
    .out( s22 )
  );
  rj32_DIG_Add #(
    .Bits(4)
  )
  DIG_Add_i2 (
    .a( 4'b0 ),
    .b( s17 ),
    .c_i( dir ),
    .s( s13 ),
    .c_o( s18 )
  );
  rj32_Mux_2x1_NBits #(
    .Bits(16)
  )
  Mux_2x1_NBits_i3 (
    .sel( arith ),
    .in_0( 16'b0 ),
    .in_1( s22 ),
    .out( s20 )
  );
  rj32_Mux_2x1_NBits #(
    .Bits(16)
  )
  Mux_2x1_NBits_i4 (
    .sel( dir ),
    .in_0( I ),
    .in_1( s20 ),
    .out( s14 )
  );
  rj32_Mux_2x1_NBits #(
    .Bits(16)
  )
  Mux_2x1_NBits_i5 (
    .sel( dir ),
    .in_0( s20 ),
    .in_1( I ),
    .out( s15 )
  );
  assign s0 = s13[1:0];
  assign s7 = s13[3:2];
  assign s16[15:0] = s14;
  assign s16[31:16] = s15;
  assign s12 = s16[30:0];
  assign s8 = s12[18:0];
  assign s9 = s12[22:4];
  assign s10 = s12[26:8];
  assign s11 = s12[30:12];
  rj32_Mux_4x1_NBits #(
    .Bits(19)
  )
  Mux_4x1_NBits_i6 (
    .sel( s7 ),
    .in_0( s8 ),
    .in_1( s9 ),
    .in_2( s10 ),
    .in_3( s11 ),
    .out( s6 )
  );
  assign s1 = s6[15:0];
  assign s2 = s6[16:1];
  assign s3 = s6[17:2];
  assign s4 = s6[18:3];
  rj32_Mux_4x1_NBits #(
    .Bits(16)
  )
  Mux_4x1_NBits_i7 (
    .sel( s0 ),
    .in_0( s1 ),
    .in_1( s2 ),
    .in_2( s3 ),
    .in_3( s4 ),
    .out( s5 )
  );
  rj32_Mux_2x1_NBits #(
    .Bits(16)
  )
  Mux_2x1_NBits_i8 (
    .sel( s18 ),
    .in_0( s5 ),
    .in_1( s15 ),
    .out( O )
  );
endmodule

module rj32_Mux_8x1_NBits #(
    parameter Bits = 2
)
(
    input [2:0] sel,
    input [(Bits - 1):0] in_0,
    input [(Bits - 1):0] in_1,
    input [(Bits - 1):0] in_2,
    input [(Bits - 1):0] in_3,
    input [(Bits - 1):0] in_4,
    input [(Bits - 1):0] in_5,
    input [(Bits - 1):0] in_6,
    input [(Bits - 1):0] in_7,
    output reg [(Bits - 1):0] out
);
    always @ (*) begin
        case (sel)
            3'h0: out = in_0;
            3'h1: out = in_1;
            3'h2: out = in_2;
            3'h3: out = in_3;
            3'h4: out = in_4;
            3'h5: out = in_5;
            3'h6: out = in_6;
            3'h7: out = in_7;
            default:
                out = 'h0;
        endcase
    end
endmodule


module rj32_Mux_8x1
(
    input [2:0] sel,
    input in_0,
    input in_1,
    input in_2,
    input in_3,
    input in_4,
    input in_5,
    input in_6,
    input in_7,
    output reg out
);
    always @ (*) begin
        case (sel)
            3'h0: out = in_0;
            3'h1: out = in_1;
            3'h2: out = in_2;
            3'h3: out = in_3;
            3'h4: out = in_4;
            3'h5: out = in_5;
            3'h6: out = in_6;
            3'h7: out = in_7;
            default:
                out = 'h0;
        endcase
    end
endmodule


module rj32_execute (
  input [15:0] L,
  input [15:0] R,
  input [2:0] op,
  input [2:0] cond,
  output [15:0] L_out,
  output [15:0] R_out,
  output [15:0] result,
  output skip_n
);
  wire [15:0] s0;
  wire [15:0] s1;
  wire [15:0] \xor ;
  wire [15:0] s2;
  wire [15:0] s3;
  wire s4;
  wire [15:0] s5;
  wire [15:0] s6;
  wire s7;
  wire s8;
  wire hs;
  wire ne;
  wire eq;
  wire ge;
  wire lt;
  wire [3:0] s9;
  assign s5 = ~ R;
  assign \xor  = (L ^ R);
  assign s2 = (L & R);
  assign s3 = (L | R);
  assign s4 = op[0];
  assign s7 = op[2];
  assign s9 = R[3:0];
  rj32_Mux_2x1_NBits #(
    .Bits(16)
  )
  Mux_2x1_NBits_i0 (
    .sel( s4 ),
    .in_0( R ),
    .in_1( s5 ),
    .out( s6 )
  );
  // eq
  rj32_CompUnsigned #(
    .Bits(16)
  )
  CompUnsigned_i1 (
    .a( \xor  ),
    .b( 16'b0 ),
    .\= ( ne )
  );
  rj32_funnelshifter funnelshifter_i2 (
    .I( L ),
    .amt( s9 ),
    .dir( s4 ),
    .arith( s7 ),
    .O( s1 )
  );
  assign eq = ~ ne;
  rj32_DIG_Add #(
    .Bits(16)
  )
  DIG_Add_i3 (
    .a( L ),
    .b( s6 ),
    .c_i( s4 ),
    .s( s0 ),
    .c_o( s8 )
  );
  rj32_Mux_8x1_NBits #(
    .Bits(16)
  )
  Mux_8x1_NBits_i4 (
    .sel( op ),
    .in_0( s0 ),
    .in_1( s0 ),
    .in_2( s1 ),
    .in_3( s1 ),
    .in_4( s1 ),
    .in_5( \xor  ),
    .in_6( s2 ),
    .in_7( s3 ),
    .out( result )
  );
  assign hs = ~ s8;
  assign ge = (s0[15] ^ ((L[15] & s6[15] & ~ s0[15]) | (~ L[15] & ~ s6[15] & s0[15])));
  assign lt = ~ ge;
  rj32_Mux_8x1 Mux_8x1_i5 (
    .sel( cond ),
    .in_0( 1'b0 ),
    .in_1( eq ),
    .in_2( ne ),
    .in_3( lt ),
    .in_4( ge ),
    .in_5( s8 ),
    .in_6( hs ),
    .in_7( 1'b0 ),
    .out( skip_n )
  );
  assign L_out = L;
  assign R_out = R;
endmodule
module rj32_DIG_RegisterFile
#(
    parameter Bits = 8,
    parameter AddrBits = 4
)
(
    input [(Bits-1):0] Din,
    input we,
    input [(AddrBits-1):0] Rw,
    input C,
    input [(AddrBits-1):0] Ra,
    input [(AddrBits-1):0] Rb,
    output [(Bits-1):0] Da,
    output [(Bits-1):0] Db
);

    reg [(Bits-1):0] memory[0:((1 << AddrBits)-1)];

    assign Da = memory[Ra];
    assign Db = memory[Rb];

    always @ (posedge C) begin
        if (we)
            memory[Rw] <= Din;
    end
endmodule


module rj32_regfile (
  input [3:0] rs,
  input [3:0] rd,
  input [15:0] wrval,
  input clock,
  input en,
  input wr,
  output [15:0] rdval,
  output [15:0] rsval
);
  wire s0;
  assign s0 = (en & wr);
  rj32_DIG_RegisterFile #(
    .Bits(16),
    .AddrBits(4)
  )
  DIG_RegisterFile_i0 (
    .Din( wrval ),
    .we( s0 ),
    .Rw( rd ),
    .C( clock ),
    .Ra( rd ),
    .Rb( rs ),
    .Da( rdval ),
    .Db( rsval )
  );
endmodule
module rj32_DIG_RAMDualAccess
#(
    parameter Bits = 8,
    parameter AddrBits = 4
)
(
    input C, // Clock signal
    input ld,
    input [(AddrBits-1):0] \1A ,
    input [(AddrBits-1):0] \2A ,
    input [(Bits-1):0] \1Din ,
    input str,
    output [(Bits-1):0] \1D ,
    output [(Bits-1):0] \2D
);
    // CAUTION: uses distributed RAM
    reg [(Bits-1):0] memory [0:((1 << AddrBits)-1)];

    assign \1D = ld? memory[\1A ] : 'hz;
    assign \2D = memory[\2A ];

    always @ (posedge C) begin
        if (str)
            memory[\1A ] <= \1Din ;
    end

endmodule



module rj32_debugregs (
  input [15:0] data_in,
  input valid_in,
  input [7:0] addr_in,
  input ready_in,
  input write,
  input en,
  input clock,
  input [3:0] rd,
  input [15:0] wrval,
  input [7:0] sel,
  output [15:0] data_out,
  output valid_out,
  output [7:0] addr_out,
  output ready_out
);
  wire s0;
  wire [3:0] s1;
  wire [15:0] s2;
  wire [3:0] s3;
  wire [3:0] s4;
  wire s5;
  assign s0 = (en & write);
  assign s1 = addr_in[3:0];
  assign s3 = addr_in[7:4];
  assign s4 = sel[7:4];
  rj32_DIG_RAMDualAccess #(
    .Bits(16),
    .AddrBits(4)
  )
  DIG_RAMDualAccess_i0 (
    .str( s0 ),
    .C( clock ),
    .ld( 1'b0 ),
    .\1A ( rd ),
    .\1Din ( wrval ),
    .\2A ( s1 ),
    .\2D ( s2 )
  );
  // active?
  rj32_CompUnsigned #(
    .Bits(4)
  )
  CompUnsigned_i1 (
    .a( s3 ),
    .b( s4 ),
    .\= ( s5 )
  );
  rj32_Mux_2x1_NBits #(
    .Bits(16)
  )
  Mux_2x1_NBits_i2 (
    .sel( s5 ),
    .in_0( data_in ),
    .in_1( s2 ),
    .out( data_out )
  );
  assign valid_out = (s5 | valid_in);
  assign addr_out = addr_in;
  assign ready_out = ready_in;
endmodule

module rj32_debugmux (
  input [15:0] data_in,
  input valid_in,
  input [7:0] addr_in,
  input ready_in,
  input [7:0] sel,
  input [15:0] in_0,
  input [15:0] in_1,
  input [15:0] in_2,
  input [15:0] in_3,
  input [15:0] in_4,
  input [15:0] in_5,
  input [15:0] in_6,
  input [15:0] in_7,
  output [15:0] data_out,
  output valid_out,
  output [7:0] addr_out,
  output ready_out
);
  wire [4:0] s0;
  wire [4:0] s1;
  wire s2;
  wire [2:0] s3;
  wire [15:0] s4;
  assign s3 = addr_in[2:0];
  assign s0 = addr_in[7:3];
  assign s1 = sel[7:3];
  // active?
  rj32_CompUnsigned #(
    .Bits(5)
  )
  CompUnsigned_i0 (
    .a( s0 ),
    .b( s1 ),
    .\= ( s2 )
  );
  rj32_Mux_8x1_NBits #(
    .Bits(16)
  )
  Mux_8x1_NBits_i1 (
    .sel( s3 ),
    .in_0( in_0 ),
    .in_1( in_1 ),
    .in_2( in_2 ),
    .in_3( in_3 ),
    .in_4( in_4 ),
    .in_5( in_5 ),
    .in_6( in_6 ),
    .in_7( in_7 ),
    .out( s4 )
  );
  rj32_Mux_2x1_NBits #(
    .Bits(16)
  )
  Mux_2x1_NBits_i2 (
    .sel( s2 ),
    .in_0( data_in ),
    .in_1( s4 ),
    .out( data_out )
  );
  assign valid_out = (s2 | valid_in);
  assign addr_out = addr_in;
  assign ready_out = ready_in;
endmodule

module rj32_debugbus (
  input db_ready,
  input clock,
  input [15:0] ctrl,
  input [15:0] wrval,
  input [15:0] result,
  input [15:0] L,
  input [15:0] R,
  input [15:0] imm,
  input [15:0] pc,
  input [15:0] fullop,
  input [15:0] rdf,
  input [15:0] rsf,
  output [25:0] db
);
  wire [7:0] s0;
  wire s1;
  wire s2;
  wire [3:0] s3;
  wire [15:0] s4;
  wire s5;
  wire [7:0] s6;
  wire s7;
  wire [15:0] s8;
  wire s9;
  wire [7:0] s10;
  wire s11;
  wire s12;
  wire s13;
  wire [15:0] s14;
  wire [7:0] s15;
  assign s1 = ctrl[10];
  assign s2 = ctrl[12];
  assign s3 = rdf[3:0];
  rj32_debugregs debugregs_i0 (
    .data_in( 16'b0 ),
    .valid_in( 1'b0 ),
    .addr_in( s0 ),
    .ready_in( db_ready ),
    .write( s1 ),
    .en( s2 ),
    .clock( clock ),
    .rd( s3 ),
    .wrval( wrval ),
    .sel( 8'b0 ),
    .data_out( s4 ),
    .valid_out( s5 ),
    .addr_out( s6 ),
    .ready_out( s7 )
  );
  rj32_debugmux debugmux_i1 (
    .data_in( s4 ),
    .valid_in( s5 ),
    .addr_in( s6 ),
    .ready_in( s7 ),
    .sel( 8'b10000 ),
    .in_0( fullop ),
    .in_1( ctrl ),
    .in_2( L ),
    .in_3( R ),
    .in_4( result ),
    .in_5( wrval ),
    .in_6( imm ),
    .in_7( pc ),
    .data_out( s8 ),
    .valid_out( s9 ),
    .addr_out( s10 ),
    .ready_out( s11 )
  );
  // Addr Enumerator
  rj32_DIG_Counter_Nbit #(
    .Bits(8)
  )
  DIG_Counter_Nbit_i2 (
    .en( db_ready ),
    .C( clock ),
    .clr( s13 ),
    .out( s0 )
  );
  rj32_debugmux debugmux_i3 (
    .data_in( s8 ),
    .valid_in( s9 ),
    .addr_in( s10 ),
    .ready_in( s11 ),
    .sel( 8'b11000 ),
    .in_0( rdf ),
    .in_1( rsf ),
    .in_2( 16'b0 ),
    .in_3( 16'b0 ),
    .in_4( 16'b0 ),
    .in_5( 16'b0 ),
    .in_6( 16'b0 ),
    .in_7( 16'b0 ),
    .data_out( s14 ),
    .valid_out( s12 ),
    .addr_out( s15 )
  );
  assign s13 = ~ s12;
  assign db[15:0] = s14;
  assign db[16] = s12;
  assign db[24:17] = s15;
  assign db[25] = clock;
endmodule

module rj32 (
  input clock,
  input step,
  input run_slow,
  input [15:0] D_prog,
  input [15:0] D_in,
  input run_fast,
  input run_faster,
  input erun,
  input ack,
  output halt,
  output error,
  output skip,
  output stall,
  output [7:0] A_prog,
  output clock_m,
  output [15:0] A_data,
  output [15:0] D_out,
  output w_en,
  output [25:0] db,
  output req
);
  wire [15:0] s0;
  wire [15:0] s1;
  wire [15:0] s2;
  wire [15:0] s3;
  wire jump_t;
  wire [3:0] rs_t;
  wire [3:0] rd_t;
  wire [15:0] L_t;
  wire [15:0] R_t;
  wire [4:0] op_t;
  wire rsvalid_t;
  wire rdvalid_t;
  wire [15:0] imm_t;
  wire immv_t;
  wire [2:0] aluop_t;
  wire [2:0] cond_t;
  wire [15:0] s4;
  wire [15:0] s5;
  wire [15:0] result_t;
  wire skip_n;
  wire [15:0] wrval_t;
  wire en;
  wire write_t;
  wire en_fetch;
  wire halt_temp;
  wire error_temp;
  wire stall_temp;
  wire skip_temp;
  wire req_temp;
  wire store_t;
  wire [1:0] wrmux_t;
  wire [15:0] s6;
  wire [15:0] s7;
  wire [15:0] ctrl_t;
  wire [15:0] fullop_t;
  wire [15:0] rdf_t;
  wire [15:0] rsf_t;
  rj32_clockctrl clockctrl_i0 (
    .clock( clock ),
    .step( step ),
    .slow( run_slow ),
    .fast( run_fast ),
    .faster( run_faster ),
    .efast( erun ),
    .stall( stall_temp )
  );
  assign clock_m = ~ clock;
  rj32_fetch fetch_i1 (
    .result( result_t ),
    .instr_i( D_prog ),
    .clock( clock ),
    .fetch( en_fetch ),
    .jump( jump_t ),
    .en( en ),
    .instr_o( s2 ),
    .pc( s3 )
  );
  rj32_control control_i2 (
    .op( op_t ),
    .stall( stall_temp ),
    .clock( clock ),
    .skip_n( skip_n ),
    .ack( ack ),
    .aluop( aluop_t ),
    .cond( cond_t ),
    .skip( skip_temp ),
    .halt( halt_temp ),
    .error( error_temp ),
    .en_write( en ),
    .mem( req_temp ),
    .store( store_t ),
    .en_fetch( en_fetch ),
    .jump( jump_t ),
    .write( write_t ),
    .wrmux( wrmux_t )
  );
  assign ctrl_t[0] = stall_temp;
  assign ctrl_t[1] = skip_temp;
  assign ctrl_t[2] = halt_temp;
  assign ctrl_t[3] = error_temp;
  assign ctrl_t[4] = jump_t;
  assign ctrl_t[7:5] = aluop_t;
  assign ctrl_t[8] = req_temp;
  assign ctrl_t[9] = store_t;
  assign ctrl_t[10] = write_t;
  assign ctrl_t[11] = en_fetch;
  assign ctrl_t[12] = en;
  assign ctrl_t[14:13] = wrmux_t;
  assign ctrl_t[15] = immv_t;
  rj32_writeback writeback_i3 (
    .L( s4 ),
    .R( s5 ),
    .result( result_t ),
    .rdval( s0 ),
    .D( D_in ),
    .wrmux( wrmux_t ),
    .wrval( wrval_t ),
    .result_out( s6 ),
    .rdval_out( s7 )
  );
  rj32_memaccess memaccess_i4 (
    .result( s6 ),
    .rdval( s7 ),
    .store( store_t ),
    .en( en ),
    .A( A_data ),
    .str( w_en ),
    .D_in( D_out )
  );
  assign A_prog = s3[7:0];
  rj32_decoder decoder_i5 (
    .rdval( s0 ),
    .rsval( s1 ),
    .instr( s2 ),
    .pc( s3 ),
    .jump( jump_t ),
    .rs( rs_t ),
    .rd( rd_t ),
    .L( L_t ),
    .R( R_t ),
    .op( op_t ),
    .rs_valid( rsvalid_t ),
    .rd_valid( rdvalid_t ),
    .imm( imm_t ),
    .immv( immv_t )
  );
  rj32_execute execute_i6 (
    .L( L_t ),
    .R( R_t ),
    .op( aluop_t ),
    .cond( cond_t ),
    .L_out( s4 ),
    .R_out( s5 ),
    .result( result_t ),
    .skip_n( skip_n )
  );
  rj32_regfile regfile_i7 (
    .rs( rs_t ),
    .rd( rd_t ),
    .wrval( wrval_t ),
    .clock( clock ),
    .en( en ),
    .wr( write_t ),
    .rdval( s0 ),
    .rsval( s1 )
  );
  rj32_debugbus debugbus_i8 (
    .db_ready( 1'b1 ),
    .clock( clock ),
    .ctrl( ctrl_t ),
    .wrval( wrval_t ),
    .result( result_t ),
    .L( L_t ),
    .R( R_t ),
    .imm( imm_t ),
    .pc( s3 ),
    .fullop( fullop_t ),
    .rdf( rdf_t ),
    .rsf( rsf_t ),
    .db( db )
  );
  assign fullop_t[4:0] = op_t;
  assign fullop_t[7:5] = cond_t;
  assign fullop_t[15:8] = 8'b0;
  assign rdf_t[3:0] = rd_t;
  assign rdf_t[4] = jump_t;
  assign rdf_t[5] = rdvalid_t;
  assign rdf_t[15:6] = 10'b0;
  assign rsf_t[3:0] = rs_t;
  assign rsf_t[4] = 1'b0;
  assign rsf_t[5] = rsvalid_t;
  assign rsf_t[15:6] = 10'b0;
  assign halt = halt_temp;
  assign error = error_temp;
  assign skip = skip_temp;
  assign stall = stall_temp;
  assign req = req_temp;
endmodule