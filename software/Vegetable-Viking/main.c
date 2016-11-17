// Here is our code for VEGETABLE VIKING!!!

#include <stdio.h>
#include <stdlib.h>

#define to_hw_port (volatile char*) 0x00000050 // actual address here
#define to_hw_sig (volatile char*) 0x00000040 // actual address here
#define to_sw_port (char*) 0x00000030 // actual address here
#define to_sw_sig (char*) 0x00000020 // actual address here


// this function sends bunches of 24-bit messages
int FPGAcommunicator(unsigned char FPGAmessage)
{
	*to_hw_sig = 3;	// 3 means we're starting communication
	while(*to_sw_sig == 0);	// wait for FPGA to wake up
	*to_hw_port = FPGAmessage;
	while(*to_sw_sig == 1);	// wait for FPGA to receive our message
	*to_hw_sig = 0;	// okay we're done now, going back to sleep
}

int main()
{



}

