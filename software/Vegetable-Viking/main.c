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
#define to_hw_port0 (volatile unsigned long long*) 0x00000100 // actual address here
#define to_hw_port1 (volatile unsigned long long*) 0x000000f0 // actual address here
#define to_hw_port2 (volatile unsigned long long*) 0x000000e0 // actual address here
#define to_hw_port3 (volatile unsigned long long*) 0x000000d0 // actual address here
#define to_hw_port4 (volatile unsigned long long*) 0x000000c0 // actual address here
#define to_hw_port5 (volatile unsigned long long*) 0x000000b0 // actual address here
#define to_hw_port6 (volatile unsigned long long*) 0x000000a0 // actual address here
#define to_hw_port7 (volatile unsigned long long*) 0x00000060 // actual address here
#define to_hw_port8 (volatile unsigned long long*) 0x00000090 // actual address here
#define to_hw_port9 (volatile unsigned long long*) 0x00000080 // actual address here
#define to_hw_port10 (volatile unsigned long long*) 0x00000040 // actual address here
#define to_hw_port11 (volatile unsigned long long*) 0x00000030 // actual address here
#define to_hw_port12 (volatile unsigned long long*) 0x00000020 // actual address here
// hardware-software signals
#define to_hw_sig (volatile char*) 0x00000070 // actual address here
#define to_sw_sig (char*) 0x00000050 // actual address here
//#define to_sw_port (char*) 0x00000030 // actual address here

// struct your stuff
struct displayPackage
{
	unsigned long xPosition;		// x position on the screen
	unsigned long yPosition;		// y position on the screen
	unsigned long objectType;		// type of the object (different fruits/bombs)
	unsigned long objectState;		// state of the object
//	unsigned long objectRot;		// rotation of the object (no longer included)
	int packageType;	// type of message: 0- cursor, 1- fruit, 2- game status
};

/* FOR GAME STATUS PACKAGE
 *	xPosition -> game score
 *	yPosition -> game timer
 *	objectType -> game start state
 *	objectState -> game end state
*/

// declarations of functions and stuff
void FPGAcommunicator(unsigned long long* FPGAmessage);
unsigned long messagePackager(struct displayPackage);
unsigned long convertDecimalToBinary(unsigned long n);
unsigned long convertBinaryToDecimal(unsigned long long n);


// our main function!!!
int main()
{
	// make our struct
	struct displayPackage gameObject[16];

	gameObject[0].xPosition = 127;
	gameObject[0].yPosition = 96;
	gameObject[0].objectType = 7;
	gameObject[0].objectState = 7;
	gameObject[0].packageType = 1;

	gameObject[11].xPosition = 34;
	gameObject[11].yPosition = 84;
	gameObject[11].objectType = 2;
	gameObject[11].objectState = 4;
	gameObject[11].packageType = 1;

	gameObject[12].xPosition = 640;
	gameObject[12].yPosition = 480;
	gameObject[12].objectType = 0;
	gameObject[12].objectState = 0;
	gameObject[12].packageType = 0;

	// initialization of message we need to send to FPGA (array of 32-bit messages)
	unsigned long long FPGAmessage[16];

	int i;
	for (i=0; i<13; i++)
	{
		// read in our temp package
		unsigned long long tempPackage = messagePackager(gameObject[i]);

		printf("Our %dth message is %llu\n", i, tempPackage);

		FPGAmessage[i] = tempPackage;
	}

	// printf("Now we doing our communicatin\n");
	FPGAcommunicator(FPGAmessage);

	return 0;
}

// this function takes a struct and converts it into a message we can send
unsigned long messagePackager(struct displayPackage specifiedObject)
{
	// basic variables
	int packageType;
	unsigned long long tempDecimal;
	unsigned long long tempBinary;

	// figure out how to package it
	packageType = specifiedObject.packageType;

	if (packageType == 2)
	{
		// this means we are packaging our game package instead
		unsigned long long tempScore, tempTime, tempStart, tempEnd;

		// grab our stuff in conversion
		tempScore = specifiedObject.xPosition;
		tempTime = specifiedObject.yPosition;
		tempStart = specifiedObject.objectType;
		tempEnd = specifiedObject.objectState;

		// and convert it to binary!
		tempScore = convertDecimalToBinary(tempScore);
		tempTime = convertDecimalToBinary(tempTime);
		tempStart = convertDecimalToBinary(tempStart);
		tempEnd = convertDecimalToBinary(tempEnd);

		// and now we append everything together!			// TO DO HERE
		tempBinary = tempScore + tempTime*10000000 + tempStart*10000000*10000000 + tempEnd*1000*10000000*10000000;
	}
	else		// else, this is just a regular package
	{
		// make our specific variables
		unsigned long long tempX, tempY, tempType, tempState;

		// grab our stuff from the struct
		tempX = specifiedObject.xPosition;
		tempY = specifiedObject.yPosition;
		tempType = specifiedObject.objectType;
		tempState = specifiedObject.objectState;

		// and convert stuff to binary!
		tempX = convertDecimalToBinary(tempX);
		tempY = convertDecimalToBinary(tempY);
		tempType = convertDecimalToBinary(tempType);
		tempState = convertDecimalToBinary(tempState);
/*
		printf("tempX: %llu   ", tempX);
		printf("tempY: %llu   ", tempY);
		printf("tempType: %llu   ", tempType);
		printf("tempState: %llu   ", tempState);
*/

		// now we append everything together!
		if (packageType == 0)	// this means we are packaging the cursor
		{
			// location is important!
			tempBinary = tempX + tempY*10000000000;
		}
		else	// this means we are packaging a fruit/bomb
		{
			// location not as important
			tempBinary = tempX + tempY*10000000 + tempType*100000000000000 + tempState*100000000000000000;
		//	printf("tempBinary: %llu   ", tempBinary);
		}
	}

	// and convert it back to decimal!
	tempDecimal = convertBinaryToDecimal(tempBinary);

	// and return it!
	return tempDecimal;
}

// this function takes an array of 32-bit messages and sends them all out
void FPGAcommunicator(unsigned long long* FPGAmessage)
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
	*to_hw_port10 = FPGAmessage[10];
	*to_hw_port11 = FPGAmessage[11];
	*to_hw_port12 = FPGAmessage[12];
//	printf("FPGAmessage 11 is %llu \n", FPGAmessage[11]);

	while(*to_sw_sig != 2);	// wait for FPGA to wake up

	*to_hw_sig = 1;		// now we are done putting in messages

	while(*to_sw_sig != 0); // wait for response from hardware
	*to_hw_sig = 0;		// okay we're done now, going back to sleep

	printf("message stuff done\n");
}

// converts decimal to binary
unsigned long convertDecimalToBinary(unsigned long n)
{
  // printf("decimal input: %lu   ", n);
    unsigned long long binaryNumber = 0;
    int remainder, i = 1;

    while (n!=0)
    {
        remainder = n%2;
        n /= 2;
        binaryNumber += remainder*i;
        i *= 10;
    }
  //  printf("binary ouput: %llu \n", binaryNumber);
    return binaryNumber;
}

// converts binary to decimal!
unsigned long convertBinaryToDecimal(unsigned long long n)
{
 //	printf("binary input: %llu   ", n);
    unsigned long decimalNumber = 0, i = 0, remainder;
    while (n!=0)
    {
        remainder = n%10;
        n /= 10;
        decimalNumber += remainder*pow(2,i);
        ++i;
    }
  //  printf("decimal output: %lu\n", decimalNumber);
    return decimalNumber;
}
