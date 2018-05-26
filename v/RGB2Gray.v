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
input	[11:0]	iRed;
input	[11:0]	iGreen;
input	[11:0]	iBlue;

output	[11:0]	oRed;
output	[11:0]	oGreen;
output	[11:0]	oBlue;

logic [11:0]	mRed;
 [11:0]	mGreen;
wire [11:0]	mBlue;

assign mRed = iRed;
assign mGreen = iGreen;
assign mBlue = iBlue;

always comb
	begin
		
	end

always_ff@(posedge iCLK or negedge iRST_n)
	begin
		if(!iRST_n)
			oRed = 0;
			oGreen = 0;
			oBlue = 0;
		else
			oRed = mRed;
			oGreen = mGreen;
			oBlue = mBlue;
	end

endmodule;