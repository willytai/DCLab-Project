module Seri2Para (
    iCLK,
    iRST_n,
    iSTART,
    pixel,
    oFinished,
    mFlash
);

    input                  iCLK;
    input                  iRST_n;
    input                  iSTART;
    input                  pixel;
    output                 oFinished;
//    output [307199:0]      mFlash;          //640*480pixels
   output       mFlash;          //640*5pixels

    localparam IDLE = 1'b0;
    localparam RUN = 1'b1;
    logic state_w, state_r, finished_r, finished_w;
    logic [18:0] count_w, count_r;
//    logic [307199:0] data_r, data_w;
    logic  data_r, data_w;

    assign mFlash = data_r;
    assign oFinished = finished_r;

    always_comb begin
        state_w     = state_r;
        count_w     = count_r;
        data_w      = data_r;
        finished_w  = finished_r;

        case(state_r)
            IDLE:
            begin
                finished_w = 1'b0;
                if (iSTART) begin
                    state_w = RUN;
                    count_w = '0;
                end
            end
            RUN:
            begin
//            if (count_r < 307200) begin
            if (count_r < 1) begin
                count_w = count_r + 19'b1;
                data_w  = data_r << 1;
                data_w = pixel;
            end

 //           if (count_r==307200) begin
            if (count_r==1) begin
                count_w = 0;
                state_w = IDLE;
                finished_w = 1'b1;
            end
            end
        endcase
    end

    always_ff @(posedge iCLK or negedge iRST_n) begin
        if (!iRST_n) begin
            count_r <= 0;
            finished_r  <= 0;
            data_r	<= 0;
            state_r     <= IDLE;
        end
        else begin
            count_r     <= count_w;
            finished_r  <= finished_w;
            data_r      <= data_w;
            state_r     <= state_w;
        end
    end
endmodule