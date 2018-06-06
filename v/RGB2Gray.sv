module	RGB2Gray				(	iCLK,iRST_n,
								//Read Port 1
								iRed,
								iGreen,
								iBlue,
								oRed,
								oGreen,
								oBlue
							);



	input			iCLK;
	input			iRST_n;
	input	[9:0]	iRed;
	input	[9:0]	iGreen;
	input	[9:0]	iBlue;

	output	[9:0]	oRed;
	output	[9:0]	oGreen;
	output	[9:0]	oBlue;

	logic [9:0]	Red_w, Red_r;
	logic [9:0]	Green_w, Green_r;
	logic [9:0]	Blue_w, Blue_r;

	logic [19:0]	Gray;

	assign oRed = Red_r;
	assign oGreen = Green_r;
	assign oBlue = Blue_r;
	
	assign Red_w = Gray[19:10];
	assign Green_w = Gray[19:10];
	assign Blue_w = Gray[19:10];


	always_comb begin
		Gray = (iRed*306+iGreen*601+iBlue*117);
	end

	always_ff@(posedge iCLK or negedge iRST_n)	begin
		if(!iRST_n) begin
			Red_r <= 0;
			Green_r <= 0;
			Blue_r <= 0;
		end else begin
			Red_r <= Red_w;
			Green_r <= Green_w;
			Blue_r <= Blue_w;
			//Red_r <= 127;
			//Green_r <= 127;
			//Blue_r <= 127;
		end
	end
	
endmodule