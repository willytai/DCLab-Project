module	Gray2Binary	(	iCLK,iRST_n,
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
	input	[11:0]	iRed;
	input	[11:0]	iGreen;
	input	[11:0]	iBlue;

	output	[11:0]	oRed;
	output	[11:0]	oGreen;
	output	[11:0]	oBlue;

	logic [11:0]	Red_w, Red_r;
	logic [11:0]	Green_w, Green_r;
	logic [11:0]	Blue_w, Blue_r;

	logic [21:0]	Gray;

	parameter th=2048;
	
//	assign oRed = Red_r;
//	assign oGreen = Green_r;
//	assign oBlue = Blue_r;
	
	assign oRed = iRed > th ? 4095 : 0;
	assign oGreen = iGreen > th ? 4095 : 0;
	assign oBlue = iBlue > th ? 4095 : 0;


	always_ff@(posedge iCLK or negedge iRST_n)	begin
		if(!iRST_n) begin
			Red_r <= 0;
			Green_r <= 0;
			Blue_r <= 0;
		end else begin
			Red_r <= Red_w;
			Green_r <= Green_w;
			Blue_r <= Blue_w;
		end
	end
	
endmodule