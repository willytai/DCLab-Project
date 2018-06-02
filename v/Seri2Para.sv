module Seri2Para (
    iCLK,
    iRST_n,
    iSTART,
    pixel,
    oFinished,
    mFlash
);

    input		    iCLK;
    input		    iRST_n;
    input		    iSTART;
    input		    pixel;
    output		    oFinished;
//    output [479:0] [639:0] mFlash;
    output [639:0]	    mFlash [0:479];
//    output [639:0]         mFlash;
    localparam IDLE = 1'b0;
    localparam RUN = 1'b1;
    logic state_w, state_r, finished_r, finished_w;
    logic [9:0] count_col_w, count_col_r; // 640 columns
    logic [9:0] count_row_w, count_row_r; // 480 rows
//    logic [479:0] [639:0] data_r, data_w;
    logic [639:0] data_r [0:479];
    logic [639:0] data_w [0:479];
//    logic [639:0]         data_r, data_w;

    assign mFlash = data_r;
    assign oFinished = finished_r;

    always_comb begin
        state_w     = state_r;
        count_col_w = count_col_r;
        count_row_w = count_row_r;
        data_w      = data_r;
        finished_w  = finished_r;

        case(state_r)
            IDLE:
            begin
                finished_w = 1'b0;
                if (iSTART) begin
                    state_w = RUN;
                    count_col_w = 0;
                    count_row_w = 0;
                end
            end
            RUN:
            begin
                data_w[count_row_r]    = data_r[count_row_r] << 1;
                data_w[count_row_r][0] = pixel;
//                data_w    = data_r << 1;
//                data_w[0] = pixel;
                count_col_w = count_col_r + 10'b1;

                if (count_col_r == 639) begin
                    count_col_w = 0;
                    count_row_w = count_row_r + 10'b1;
		    if (count_row_r == 479) begin
			count_row_w = 0;
			state_w = IDLE;
			finished_w = 1'b1;
		    end
                end
            end
        endcase
    end

    always_ff @(posedge iCLK or posedge iRST_n) begin
        if (iRST_n) begin
            count_col_r <= 0;
            count_row_r <= 0;
            finished_r  <= 0;
            data_r	<= {640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0, 640'b0};
            state_r     <= IDLE;
        end
        else begin
            count_col_r <= count_col_w;
            count_row_r <= count_row_w;
            finished_r  <= finished_w;
            data_r      <= data_w;
            state_r     <= state_w;
        end
    end

endmodule
