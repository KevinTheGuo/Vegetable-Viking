// Here is our code for VEGETABLE VIKING!!!

#include <stdio.h>
#include <stdlib.h>

// define our PIO interaction stuff
// hw ports 0 through 1
#define to_hw_port0 (volatile char*) 0x00000050 // actual address here
#define to_hw_port1 (volatile char*) 0x00000050 // actual address here
#define to_hw_port2 (volatile char*) 0x00000050 // actual address here
#define to_hw_port3 (volatile char*) 0x00000050 // actual address here
#define to_hw_port4 (volatile char*) 0x00000050 // actual address here
#define to_hw_port5 (volatile char*) 0x00000050 // actual address here
#define to_hw_port6 (volatile char*) 0x00000050 // actual address here
#define to_hw_port7 (volatile char*) 0x00000050 // actual address here
#define to_hw_port8 (volatile char*) 0x00000050 // actual address here
#define to_hw_port9 (volatile char*) 0x00000050 // actual address here
// hardware-software signals
#define to_hw_sig (volatile char*) 0x00000040 // actual address here
#define to_sw_sig (char*) 0x00000020 // actual address here
//#define to_sw_port (char*) 0x00000030 // actual address here


// this function takes an array of 32-bit messages and sends them all out
int FPGAcommunicator(unsigned long* FPGAmessage)
{
	*to_hw_sig = 3;	// 3 means we're starting communication
	int i;	// for loop iterator
	while(*to_sw_sig == 0);	// wait for FPGA to wake up

	// now we put in all our messages
	to_hw_port0 = FPGAmessage[0];
	to_hw_port1 = FPGAmessage[1];
	to_hw_port2 = FPGAmessage[2];
	to_hw_port3 = FPGAmessage[3];
	to_hw_port4 = FPGAmessage[4];
	to_hw_port5 = FPGAmessage[5];
	to_hw_port6 = FPGAmessage[6];
	to_hw_port7 = FPGAmessage[7];
	to_hw_port8 = FPGAmessage[8];
	to_hw_port9 = FPGAmessage[9];

	while(*to_sw_sig == 1) // wait for response from hardware
	*to_hw_sig = 1;
	while(*to_sw_sig = 0)
	*to_hw_sig = 0;	// okay we're done now, going back to sleep
}

int main()
{
	// initialization of message we need to send to FPGA (array of 32-bit messages)
	unsigned long FPGAmessage[16];


}

