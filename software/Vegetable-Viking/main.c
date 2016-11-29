/*---------------------------------------------------------------------------
		 __      __              _       __      ___ _    _
		 \ \    / /             (_)      \ \    / (_) |  (_)
		  \ \  / /__  __ _  __ _ _  ___   \ \  / / _| | ___ _ __   __ _
			\ \/ / _ \/ _` |/ _` | |/ _ \   \ \/ / | | |/ / | '_ \ / _` |
			 \  /  __/ (_| | (_| | |  __/    \  /  | |   <| | | | | (_| |
			  \/ \___|\__, |\__, |_|\___|     \/   |_|_|\_\_|_| |_|\__, |
					  __/ | __/ |                                  __/ |
					 |___/ |___/                                  |___/
  ---------------------------------------------------------------------------*/
// A revolutionary addition to the popular Fruit Ninja game! Coming soon, to you, on FPGA!

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

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

// struct your stuff
struct displayPackage
{
	unsigned long xPosition;
	unsigned long yPosition;
	unsigned long objectState;
	unsigned long objectType;
	unsigned long objectRot;
};

// declarations of functions and stuff
void FPGAcommunicator(unsigned long* FPGAmessage);
unsigned long messagePackager(struct displayPackage);
unsigned long convertDecimalToBinary(unsigned long n);
unsigned long convertBinaryToDecimal(unsigned long long n);


// our main function!!!
int main()
{
	// make our struct
	struct displayPackage gameObject[16];


	// initialization of message we need to send to FPGA (array of 32-bit messages)
	unsigned long FPGAmessage[16];

	int i;
	for (i=0; i<16; i++)
	{
		unsigned long tempPackage = messagePackager(gameObject[i]);


		printf("Our %dth message is %lu\n", i, tempPackage);

		FPGAmessage[i] = tempPackage;
	}

	printf("Now we doing our communicatin\n");
	FPGAcommunicator(FPGAmessage);

	return 0;
}

// this function takes a struct and converts it into a message we can send
unsigned long messagePackager(struct displayPackage specifiedObject)
{
	// make our variables
	unsigned long tempDecimal, tempX, tempY, tempState, tempType, tempRot;
	unsigned long long tempBinary;

	// grab our stuff from the struct
	tempX = specifiedObject.xPosition;
	tempY = specifiedObject.yPosition;
	tempState = specifiedObject.objectState;
	tempType = specifiedObject.objectType;
	tempRot = specifiedObject.objectRot;

	// and convert stuff to binary!
	tempX = convertDecimalToBinary(tempX);
	tempY = convertDecimalToBinary(tempY);
	tempState = convertDecimalToBinary(tempState);
	tempType = convertDecimalToBinary(tempType);
	tempRot = convertDecimalToBinary(tempRot);

	// now we append everything together!
	if (tempState == 42)	// this means we are packaging the cursor
	{
		// location is important!
		tempBinary = tempX + tempY*1000000000;
	}
	else	// this means we are packaging a fruit/bomb
	{
		// location not as important
		tempBinary = tempX + tempY*1000 + tempState*1000 + tempType*1000 + tempRot*1000;
	}

	// and convert it back to decimal!
	tempDecimal = convertBinaryToDecimal(tempBinary);

	// and return it!
	return tempDecimal;
}

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

// converts decimal to binary
unsigned long convertDecimalToBinary(unsigned long n)
{
    long long binaryNumber = 0;
    int remainder, i = 1;

    while (n!=0)
    {
        remainder = n%2;
        n /= 2;
        binaryNumber += remainder*i;
        i *= 10;
    }
    return binaryNumber;
}

// converts binary to decimal!
unsigned long convertBinaryToDecimal(unsigned long long n)
{
    int decimalNumber = 0, i = 0, remainder;
    while (n!=0)
    {
        remainder = n%10;
        n /= 10;
        decimalNumber += remainder*pow(2,i);
        ++i;
    }
    return decimalNumber;
}
