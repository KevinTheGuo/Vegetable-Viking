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

// include our stuff
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

// define our PIO interaction stuff
// from software, to hardware
#define to_hw_port0 (volatile unsigned long*) 0x00000100 // game status data
#define to_hw_port1 (volatile unsigned long*) 0x000000f0 // game object
#define to_hw_port2 (volatile unsigned long*) 0x000000e0 //    |
#define to_hw_port3 (volatile unsigned long*) 0x000000d0 //    |
#define to_hw_port4 (volatile unsigned long*) 0x000000c0 //    |
#define to_hw_port5 (volatile unsigned long*) 0x000000b0 //    |
#define to_hw_port6 (volatile unsigned long*) 0x000000a0 //    |
#define to_hw_port7 (volatile unsigned long*) 0x00000060 //    |
#define to_hw_port8 (volatile unsigned long*) 0x00000090 //    |
#define to_hw_port9 (volatile unsigned long*) 0x00000080 //    |
#define to_hw_port10 (volatile unsigned long*) 0x00000040 //   |
#define to_hw_port11 (volatile unsigned long*) 0x00000030 //   |
#define to_hw_port12 (volatile unsigned long*) 0x00000020 //   |
#define to_hw_port13 (volatile unsigned long*) 0x00000160 //   |
#define to_hw_port14 (volatile unsigned long*) 0x00000150 //   |
#define to_hw_port15 (volatile unsigned long*) 0x00000140 // __V__
// from hardware, to software
#define to_sw_port0 (unsigned long*) 0x00000130 // switch input
#define to_sw_port1 (unsigned long*) 0x00000120 // .1 sec counter
#define to_sw_port2 (char*) 0x00000110 // 3 key signals + cursor status
#define to_sw_port3 (unsigned int*) 0x00000180 // cursor x coordinate input
#define to_sw_port4 (unsigned int*) 0x00000170 // cursor y coordinate input
// hardware-software signals
#define to_hw_sig (volatile char*) 0x00000070 // to hw sig
#define to_sw_sig (char*) 0x00000050 // to sw sig


// struct your stuff
struct gameObject
{
	long xPosition;		// x position on the screen
	long yPosition;		// y position on the screen
	long objectType;		// type of the object (different fruits/bombs)
	long objectState;		// state of the object
//	long objectRot;		// rotation of the object (no longer included)
	int packageType;	// type of message: 0- fruit, 1- game status
// THE FOLLOWING ARE NOT FOR TRANSMISSION
	double xVelocity;
	double yVelocity;
};
struct gameObject veggieObject[16];

/* FOR GAME STATUS PACKAGE
 *	xPosition -> game score
 *	yPosition -> game timer
 *	objectType -> game start state
 *	objectState -> game end state
*/

// random variables for cursor status
int xCursor;	// xcoordinate
int yCursor;	// ycoordinate
int cursorStreak;	// whether cursor has a streak or not
int cursorClicked;	// whether our thingy was clicked!

// random variables for key button status
int key1;
int key2;
int key3;

// declarations of functions and stuff
void physicsEngine();	// updates all the positions of our objects, with PHYSICS!
void spawningEngine();	// spawn more objects!! with randomness!!
void FPGAcommunicator();	// sends our structs to FPGA
unsigned long messagePackager(struct gameObject);	// packages our messages
void port2Unpackager();
unsigned long convertDecimalToBinary(unsigned long n);	// read the title
unsigned long convertBinaryToDecimal(unsigned long long n);	// see above

// our main function!!! this is where the magic happens
int main()
{
	// put in our seed
	srand(*to_sw_port0);
//	printf("Our current inputseed is %lu \n", *to_sw_port0);

	// initialize timing stuff
	unsigned long processorStart = *to_sw_port1;
	unsigned long processorTime = processorStart;
	unsigned long elapsedTime;
	unsigned long lastPhysixed;
	unsigned long lastSpawned;
	unsigned long nextSpawnTime;
//	printf("our start time is %ld \n", processorStart);

	// initialize our cursor and key stuff
	xCursor = *to_sw_port3;
	yCursor = *to_sw_port4;
	port2Unpackager();

	// initialize all our structs
	int i;
	for(i=0; i<16; i++)
	{
		veggieObject[i].xPosition = 0;
		veggieObject[i].yPosition = 0;
		veggieObject[i].objectType = 0;
		veggieObject[i].objectState = 0;
		veggieObject[i].packageType = 0;
		veggieObject[i].xVelocity = 0;
		veggieObject[i].yVelocity = 0;
	}
	veggieObject[0].packageType = 1;	// game status

	// TEST STUFF
	veggieObject[0].xPosition = 94;
	veggieObject[0].yPosition = 34;
	veggieObject[0].objectType = 5;
	veggieObject[0].objectState = 1;
	veggieObject[0].packageType = 1;
	veggieObject[0].xVelocity = 0;
	veggieObject[0].yVelocity = 0;

	while(1)
	{
		// constantly updating our current time in seconds
		processorTime = *to_sw_port1;
	//	printf("our time is %lu \n", processorTime);
		elapsedTime = processorTime - processorStart;
	//	printf("elapsed time is %lu \n", elapsedTime);

		// constantly doing physics
		if ((elapsedTime - lastPhysixed) > 1)	// greater than .1 seconds pass
		{
			physicsEngine();	// call our physics engine!
			lastPhysixed = elapsedTime;
		}

		// spawning objects
		if ((elapsedTime - lastSpawned) > nextSpawnTime)	// greater than random time
		{
			spawningEngine();	// call our spawning engine!
			lastSpawned = elapsedTime;
			nextSpawnTime = (rand() % 60) + 20;
	//		printf("we generated a random number at %lu   ", nextSpawnTime);
		}

	port2Unpackager();	// keep unpacking our stuff!
	FPGAcommunicator();	// call this every time to update the FPGA
	}
	return 0;
}

void spawningEngine()
{
	int i;
	for(i=1; i<16; i++)	// let's go through our objects and see which ones are free
	{
		if(veggieObject[i].objectState == 0)	// if one doesn't exist, go for it
		{
			// RANDOM GENERATION!!
			unsigned long randomX = (rand() % 104) + 14;
			int randomType = (rand() % 8) + 1;
			double randomSpeedY = (rand() % 30) + 30;
			double randomSpeedX = (rand() % 15) - 7.5;

			if (randomX > 80)
			{
				randomSpeedX = (rand() % 15);
			}
			else if (randomX < 40)
			{
				randomSpeedX = (rand() % 15) - 15;
			}

			// now let's store these
			veggieObject[i].xPosition = randomX;
			veggieObject[i].yPosition = 0;
			veggieObject[i].objectType = randomType;
			veggieObject[i].objectState = 1;
			veggieObject[i].xVelocity = randomSpeedX;
			veggieObject[i].yVelocity = randomSpeedY;

/*			printf("x is %lu  ", randomX);
			printf("type is %d  ", randomType);
			printf("xvelocity is %f  ", randomSpeedX);
			printf("yvelocity is %f  \n", randomSpeedY);
*/
			// now let's break
			i = 42;
			break;
		}
	}
}

void physicsEngine()
{
	int i;
	for(i=1; i<16; i++)	// update all our physics of all objects!
	{
		if(veggieObject[i].objectState != 0)	// does it even exist?
		{
			// PHYSICS MAGIC!
			veggieObject[i].xPosition = veggieObject[i].xPosition + veggieObject[i].xVelocity;
			veggieObject[i].yPosition = veggieObject[i].yPosition + veggieObject[i].yVelocity;
			veggieObject[i].yVelocity = veggieObject[i].yVelocity - 3;

	/*		printf("object %d!   ", i);
			printf("xPosition is  %li ", veggieObject[i].xPosition);
			printf("yPosition is  %li ", veggieObject[i].yPosition);
			printf("yVelocity is  %f \n", veggieObject[i].yVelocity);
	*/
			// let's now check if any of these objects are below the screen
			if((veggieObject[i].yPosition < 0) || (veggieObject[i].xPosition < 0) || (veggieObject[i].xPosition > 640))
			{
				// it has outlived its usefulness. ruthlessly slaughter it!
				veggieObject[i].xPosition = 0;
				veggieObject[i].yPosition = 0;
				veggieObject[i].objectType = 0;
				veggieObject[i].objectState = 0;
				veggieObject[i].packageType = 0;
				veggieObject[i].xVelocity = 0;
				veggieObject[i].yVelocity = 0;
			//	printf("eliminating object %d! \n", i);
			}
		}
	}
	return;
}

// this function takes an array of 32-bit messages and sends them all out
void FPGAcommunicator()
{
	// initialization of message we need to send to FPGA (array of 32-bit messages)
	unsigned long long FPGAmessage[16];

	// load all of our structs in
	int i;
	for (i=0; i<16; i++)
	{
		unsigned long long tempPackage = messagePackager(veggieObject[i]);
	//	printf("Our %dth message is %llu\n", i, tempPackage);

		FPGAmessage[i] = tempPackage;
	}


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
	*to_hw_port13 = FPGAmessage[13];
	*to_hw_port14 = FPGAmessage[14];
	*to_hw_port15 = FPGAmessage[15];
//	printf("FPGAmessage 11 is %llu \n", FPGAmessage[11]);

// actually didnt need this tbh :p
//	while(*to_sw_sig != 2);	// wait for FPGA to wake up

	*to_hw_sig = 1;		// now we are done putting in messages

//	while(*to_sw_sig != 0); // wait for response from hardware
	*to_hw_sig = 0;		// okay we're done now, going back to sleep

//	printf("message stuff done\n");
	return;
}

// this function takes a single struct and converts it into a message we can send
unsigned long messagePackager(struct gameObject specifiedObject)
{
	// basic variables
	int packageType;
	unsigned long long tempDecimal;
	unsigned long long tempBinary;

	// figure out how to package it
	packageType = specifiedObject.packageType;

	if (packageType == 1)
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

		// take X and Y and divide them by 5 to fit in our message
		tempX = tempX/5 - 1;
		tempY = tempY/5 - 1;

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
		tempBinary = tempX + tempY*10000000 + tempType*100000000000000 + tempState*100000000000000000;
		//	printf("tempBinary: %llu   ", tempBinary);
	}
	// and convert it back to decimal!
	tempDecimal = convertBinaryToDecimal(tempBinary);

	// and return it!
	return tempDecimal;
}

// this function unpacks to software port 2 into its 5 different signals
void port2Unpackager()
{
	// read it in and convert to binary
	unsigned long port2 = *to_sw_port2;
	port2 = convertDecimalToBinary(port2);

	// now let's unpack it one by one
	int unpackaged[5];
	int i;
	for(i=0; i<5; i++)
	{
		unpackaged[i] = port2 % 10;

		port2 /= 10;
	}

	// now let's assign out all the statements
	key1 = unpackaged[2];
	key2 = unpackaged[3];
	key3 = unpackaged[4];
	cursorStreak = unpackaged[0];
	cursorClicked = unpackaged[1];

	for(i=4; i>=0; i--)
	{
		printf("%d", unpackaged[i]);
	}
	printf("\n");
	if(key1)
	{
		printf("key1 pressed!");
	}
	if(key2)
	{
		printf("key2 pressed!");
	}
	if(key3)
	{
		printf("key3 pressed!");
	}
	if(cursorStreak)
	{
		printf("cursorstreak!");
	}
	if(cursorClicked)
	{
		printf("clicked!");
	}

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
