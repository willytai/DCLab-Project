module Para2Seri (
    iCLK,
    iRST_n,
    iSTART,
    mFlash,
    pixel,
	 oFinished
);

    input                iCLK;
    input                iRST_n;
    input                iSTART;
    input [479:0][0:639] mFlash;
    output               pixel;
	 output	        	 oFinished;
	
    localparam IDLE = 1'b0;
    localparam RUN = 1'b1;
    logic state_w, state_r, finished_r, finished_w;
    logic [9:0] count_col_w, count_col_r; // 640 columns
    logic [8:0] count_row_w, count_row_r; // 480 rows
    logic [479:0] [0:639] data_r, data_w;

    assign pixel = data_r[count_row_r][639];
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
                    state_w     = RUN;
                    count_col_w = 0;
                    count_row_w = 0;
                    data_w      = mFlash;
                end
            end
            RUN:
            begin
                data_w[count_row_r] = data_r[count_row_r] << 1;
                count_col_w = count_col_r + 1;

                if (count_col_r == 639) begin       
                    count_col_w = 0;
                    count_row_w = count_row_r + 1;
                end
                if (count_row_r == 479) begin
                    count_col_w = 0;
                    count_row_w = 0;
                    state_w = IDLE;
                    finished_w = 1'b1;
                end
            end
        endcase
    end

    always_ff @(posedge iCLK or posedge iRST_n) begin
        if (iRST_n) begin
            count_col_r <= 0;
            count_row_r <= 0;
            finished_r  <= 0;
            data_r      <= 0;
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