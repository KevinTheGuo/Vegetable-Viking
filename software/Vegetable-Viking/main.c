// Here is our code for VEGETABLE VIKING!!!

#include <stdio.h>
#include <stdlib.h>

// define our PIO interaction stuff
#define to_hw_port0 (volatile char*) 0x00000020 // actual address here
#define to_hw_port1 (volatile char*) 0x000000d0 // actual address here
#define to_hw_port2 (volatile char*) 0x000000c0 // actual address here
#define to_hw_port3 (volatile char*) 0x000000b0 // actual address here
#define to_hw_port4 (volatile char*) 0x000000a0 // actual address here
#define to_hw_port5 (volatile char*) 0x00000090 // actual address here
#define to_hw_port6 (volatile char*) 0x00000080 // actual address here
#define to_hw_port7 (volatile char*) 0x00000040 // actual address here
#define to_hw_port8 (volatile char*) 0x00000070 // actual address here
#define to_hw_port9 (volatile char*) 0x00000060 // actual address here
// hardware-software signals
#define to_hw_sig (volatile char*) 0x00000050 // actual address here
#define to_sw_sig (char*) 0x00000030 // actual address here
//#define to_sw_port (char*) 0x00000030 // actual address here

// this function takes an array of 32-bit messages and sends them all out
void FPGAcommunicator(unsigned long* FPGAmessage)
{
	*to_hw_sig = 2;	// 2 means we're starting communication

	// now we put in all our messages
	*to_hw_port0 = FPGAmessage[0];
	*to_hw_port1 = FPGAmessage[1];
	*to_hw_port2 = FPGAmessage[2];
	*to_hw_port3 = FPGAmessage[3];
	*to_hw_port4 = FPGAmessage[4];
	*to_hw_port5 = FPGAmessage[5];
	*to_hw_port6 = FPGAmessage[6];
	*to_hw_port7 = FPGAmessage[7];
	*to_hw_port8 = FPGAmessage[8];
	*to_hw_port9 = FPGAmessage[9];

	printf("got past putting it in\n");

	while(*to_sw_sig != 2);	// wait for FPGA to wake up

	*to_hw_sig = 1;		// now we are done putting in messages

	printf("almost done\n");

	while(*to_sw_sig != 0); // wait for response from hardware
	*to_hw_sig = 0;		// okay we're done now, going back to sleep

	printf("message stuff done\n");
}

int main()
{
	// struct your stuff
	struct displayPackage
	{
		unsigned long xPosition;
		unsigned long yPosition;
		unsigned long objectState;
		unsigned long objectType;
		unsigned long objectRot;
	};
	struct displayPackage gameObject[16];


	// initialization of message we need to send to FPGA (array of 32-bit messages)
	unsigned long FPGAmessage[16];

	int i;
	for (i=0; i<16; i++)
	{
		unsigned long tempPackage, tempX, tempY, tempState, tempType, tempRot;
		tempX = gameObject[i].xPosition;
		tempY = gameObject[i].yPosition;
		tempState = gameObject[i].objectState;
		tempType = gameObject[i].objectType;
		tempRot = gameObject[i].objectRot;

		tempPackage = tempY + 1000*tempX + 1000000*tempState + 10000000*tempState + 100000000*tempType + 100000000*tempRot;
		printf("Our %dth message is %lu\n", i, tempPackage);

		FPGAmessage[i] = tempPackage;
	}

	printf("Now we doing our communicatin\n");
	FPGAcommunicator(FPGAmessage);

	return 0;
}
