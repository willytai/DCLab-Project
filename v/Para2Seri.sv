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
//    input [307199:0]     mFlash;    //480*640pixels
    input     mFlash;    //5*640pixels
    output               pixel;
	 output	        	    oFinished;
	
    localparam IDLE = 1'b0;
    localparam RUN = 1'b1;
    logic state_w, state_r, finished_r, finished_w;
    logic [18:0]        count_r, count_w;
//    logic [307199:0]    data_r, data_w;
    logic    data_r, data_w;

//    assign pixel = data_r[307199];
    assign pixel = data_r;
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
                    state_w     = RUN;
                    count_w     = 0;
                    data_w      = mFlash;
                end
            end
            RUN:
            begin
//				if (count_r < 307200) begin       
				if (count_r < 1) begin       
                    data_w = data_r << 1;
                    count_w = count_r + 1;
                end 
//				if (count_r == 307200) begin
				if (count_r == 1) begin
					count_w = 0;
					state_w = IDLE;
					finished_w = 1'b1;
				end
            end
        endcase
    end

    always_ff @(posedge iCLK or negedge iRST_n) begin
        if (!iRST_n) begin
            count_r     <= 0;
            finished_r  <= 0;
            data_r      <= 0;
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