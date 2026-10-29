module Lab1 (
    input  wire i_sw1,
    input  wire i_sw2,
    input  wire i_sw3,

    output wire o_led1,
    output wire o_led2,
    output wire o_led3
);
    assign o_led1 = i_sw1;
    assign o_led2 = i_sw2;
    assign o_led3 = i_sw3;
endmodule