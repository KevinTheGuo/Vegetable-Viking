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

// define our PIO interaction stuff
// from software, to hardware
#define to_hw_port0 (volatile unsigned int*) 0x00000100 // game status data
#define to_hw_port1 (volatile unsigned int*) 0x000000f0 // game objects
#define to_hw_port2 (volatile unsigned int*) 0x000000e0 //    |
#define to_hw_port3 (volatile unsigned int*) 0x000000d0 //    |
#define to_hw_port4 (volatile unsigned int*) 0x000000c0 //    |
#define to_hw_port5 (volatile unsigned int*) 0x000000b0 //    |
#define to_hw_port6 (volatile unsigned int*) 0x000000a0 //    |
#define to_hw_port7 (volatile unsigned int*) 0x00000060 //    |
#define to_hw_port8 (volatile unsigned int*) 0x00000090 //    |
#define to_hw_port9 (volatile unsigned int*) 0x00000080 //    |
#define to_hw_port10 (volatile unsigned int*) 0x00000040 //   |
#define to_hw_port11 (volatile unsigned int*) 0x00000030 //   |
#define to_hw_port12 (volatile unsigned int*) 0x00000020 //   |
#define to_hw_port13 (volatile unsigned int*) 0x00000160 //   |
#define to_hw_port14 (volatile unsigned int*) 0x00000150 //   |
#define to_hw_port15 (volatile unsigned int*) 0x00000140 // __V__

// from hardware, to software
#define to_sw_port0 (unsigned long*) 0x00000130 // switch input
#define to_sw_port1 (unsigned long*) 0x00000120 // .01 sec counter (100 hz)
#define to_sw_port2 (char*) 0x00000110 // 3 key signals + cursor status
#define to_sw_port3 (unsigned int*) 0x00000180 // cursor x coordinate input
#define to_sw_port4 (unsigned int*) 0x00000170 // cursor y coordinate input
// hardware-software signals
#define to_hw_sig (volatile char*) 0x00000070 // to hw sig
#define to_sw_sig (char*) 0x00000050 // to sw sig


// struct your stuff
struct gameObject
{
	int xPosition;		// x position on the screen		(0-640)
	int yPosition;		// y position on the screen		(0-480)
	int objectType;		// type of the object (different fruits/bombs) (0-7)
	int objectState;	// state of the object							(0-7)
	// THE FOLLOWING ARE NOT FOR TRANSMISSION
	int packageType;	// type of message: 0- fruit, 1- game status
	double xVelocity;
	double yVelocity;
};
struct gameObject veggieObject[16];

/* FOR GAME STATUS PACKAGE
 *	xPosition -> game score
 *	yPosition -> game timer
 *	objectState -> game state
 *	objectType -> n/a
*/

// random variables for cursor status
unsigned int xCursor;	// xcoordinate
unsigned int yCursor;	// ycoordinate
int cursorStreak;	// whether cursor has a streak or not
int cursorClicked;	// whether our thingy was clicked!

// random variables for key input (not anymore)
int key1, key2, key3;

// variable for spawning multiple of same type of fruit
int sameFruit;

// declarations of functions and stuff
void physicsEngine();	// updates all the positions of our objects, with PHYSICS!
void spawningEngine(int pattern);	// spawn more objects!! with randomness!!
void sliceEngine();		// determines when objects are sliced, and how they behave
void disintegrateEngine();	// handles the disintegration animation of fruits/bomb
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

	// assign this to 0 at start
	sameFruit = 0;

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
	veggieObject[0].xPosition = 0;
	veggieObject[0].yPosition = 0;
	veggieObject[0].objectType = 0;
	veggieObject[0].objectState = 7;
	veggieObject[0].packageType = 1;

	// start out in the initial black menu
	while(cursorClicked == 0)
	{
		FPGAcommunicator();	// call this every time to update the FPGA
		port2Unpackager();	// just run our unpackager
	}

	// initialize timing stuff
	unsigned long processorStart = *to_sw_port1;
	unsigned long processorTime = processorStart;
	unsigned long elapsedTime;
	unsigned long lastPhysixed = processorTime;
	unsigned long lastSpawned = processorTime;
	unsigned long nextSpawnTime = processorTime;
	unsigned long lastDisintegrated = processorTime;
//	printf("our start time is %ld \n", processorStart);

	// initialize our cursor and key stuff
	xCursor = *to_sw_port3;
	yCursor = *to_sw_port4;
	port2Unpackager();

	while(1)	// game while loop
	{
		if(veggieObject[0].objectState == 0)	// DEBUG THinGY
		{
			if(key1)
			{
				veggieObject[0].objectState = 1;	// easy mode
			}
			else if(key2)
			{
				veggieObject[0].objectState = 2;	// medium mode
			}
			else if(key3)
			{
				veggieObject[0].objectState = 3;	// hard mode
			}
		}

		// constantly updating our current time in seconds
		processorTime = *to_sw_port1;
//		printf("our time is %lu \n", processorTime);
		elapsedTime = processorTime - processorStart;
//		printf("elapsed time is %lu \n", elapsedTime);

		// constantly doing physics
		if ((elapsedTime - lastPhysixed) > 1)	// greater than .02 seconds pass
		{
			physicsEngine();	// call our physics engine!
			lastPhysixed = elapsedTime;
		}

		// spawning objects
		if ((elapsedTime - lastSpawned) > nextSpawnTime)	// greater than random time
		{
			// determine next spawn time based on level
			if(veggieObject[0].objectState == 0)	// menu spawn for funsies
			{
				spawningEngine(1);	// call our spawning engine!
				nextSpawnTime = (rand() % 50) + 25;
			}
			else if(veggieObject[0].objectState == 1)	// easy mode spawn
			{
				spawningEngine(rand() % 5);
				nextSpawnTime = (rand() % 50) + 100;
			}
			else if(veggieObject[0].objectState == 2)	// medium mode
			{
				spawningEngine(rand() % 7);
				nextSpawnTime = (rand() % 75) + 50;
			}
			else if(veggieObject[0].objectState == 3)	// easy mode spawn
			{
				spawningEngine(rand() % 9);
				nextSpawnTime = (rand() % 100);		// hard mode
			}
			else
			{
				nextSpawnTime = 200;	// we're in another state. check occasionally
			}
	//		printf("we generated a random number at %lu   ", nextSpawnTime);
			sameFruit = 0;	// reset this
			lastSpawned = elapsedTime;
		}

		if ((elapsedTime - lastDisintegrated) > 20)	// greater than .2 sec
		{
			disintegrateEngine();	// call our spawning engine!
			lastDisintegrated = elapsedTime;
		}
	port2Unpackager();	// keep unpacking our stuff! (also updates cursor)
	FPGAcommunicator();	// call this every time to update the FPGA
	}
	return 0;
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
			veggieObject[i].yVelocity = veggieObject[i].yVelocity - 5;
	/*		printf("object %d!   ", i);
			printf("xPosition is  %li ", veggieObject[i].xPosition);
			printf("yPosition is  %li ", veggieObject[i].yPosition);
			printf("yVelocity is  %f \n", veggieObject[i].yVelocity);
	*/
			// let's now check if any of these objects are beyond the screen
			if((veggieObject[i].yPosition < 0) || (veggieObject[i].xPosition < 0) || (veggieObject[i].xPosition > 640))
			{
				// it has outlived its usefulness. ruthlessly slaughter it!
				veggieObject[i].xPosition = 0;
				veggieObject[i].yPosition = 0;
				veggieObject[i].objectType = 0;
				veggieObject[i].objectState = 0;
				veggieObject[i].xVelocity = 0;
				veggieObject[i].yVelocity = 0;
			//	printf("eliminating object %d! \n", i);
			}
		}
	}
	return;
}

void spawningEngine(int pattern)
{
	if(pattern == 0)	// one pattern will have us skip a spawn
	{
		return;
	}
	int i;
	for(i=1; i<16; i++)	// let's go through our objects and see which ones are free
	{
		if(veggieObject[i].objectState == 0)	// if one doesn't exist, go for it
		{
			unsigned int randomX;	// x coordinate on bottom of screen
			int randomType;		// type of fruit that's spawned
			double randomSpeedY, randomSpeedX;	// starting velocity

			veggieObject[i].objectState = 1;	// reserve this slot

			if(pattern >= 5)	// can spawn multiples and identical depending on pattern
			{
				if(((rand() % 2) == 1)&&(sameFruit == 0))
				{
					sameFruit = (rand() % 8);
				}
				int j;
				for(j=4; j<pattern; j++)
				{
					spawningEngine(1);	// call ourselves to spawn another!
				}
			}

			// RANDOM GENERATION!!
			randomX = (rand() % 540) + 50;
			randomSpeedY = (rand() % 22) + 45;
			randomSpeedX = (rand() % 40) - 20;

			// check if we are spawning samefruit
			if(sameFruit == 0)
			{
				randomType = (rand() % 8);
			}
			else
			{
				randomType = sameFruit;
			}

			// make sure we aren't throwing them out the edges
			if (randomX < 100)
			{
				randomSpeedX = (rand() % 40);
			}
			else if (randomX > 540)
			{
				randomSpeedX = (rand() % 40) - 40;
			}

			// now let's store these
			veggieObject[i].xPosition = randomX;
			veggieObject[i].yPosition = 0;
			veggieObject[i].objectType = randomType;
			veggieObject[i].xVelocity = randomSpeedX;
			veggieObject[i].yVelocity = randomSpeedY;
/*			printf("x is %lu  ", randomX);
			printf("type is %d  ", randomType);
			printf("xvelocity is %f  ", randomSpeedX);
			printf("yvelocity is %f  \n", randomSpeedY);
*/
			i = 42;
			break;
		}
	}
	return;
}

void sliceEngine()
{
	if((veggieObject[0].objectState == 0)&&(cursorStreak))	// this is menu state
	{
		// let's check menu collision
		// THIS IS TO DO
	}
	else if(cursorStreak)	// if cursor has streak, we can cut!
	{
		int i;
		for(i=1; i<16; i++)	// let's go through our objects and see which ones collide
		{
			// only if it is in perfect state
			if(veggieObject[i].objectState == 1)
			{
				// let's grab the vegetable coordinates
				int veggieX = veggieObject[i].xPosition;
				int veggieY = veggieObject[i].xPosition;

				// let's set our collision box
				int collideX, collideY;
				int offsetX = 10;
				if((veggieObject[i].objectType == 1)) //eggplant
				{
					collideX = 45;
					collideY = 85;
				}
				else if((veggieObject[i].objectType == 2))	// potato
				{
					collideX = 45;
					collideY = 80;
				}
				else if((veggieObject[i].objectType == 3)) 	// carrot
				{
					collideX = 45;
					collideY = 40;
				}
				else if((veggieObject[i].objectType == 3))	// tomato
				{
					collideX = 40;
					collideY = 40;
				}
				else	// broccoli, cabbage, radish, onion
				{
					offsetX = 0;
					collideX = 64;
					collideY = 64;
				}

				// now let's check collision
				if(((veggieX+offsetX)<xCursor)&&((veggieX+collideX)>xCursor)&&(veggieY<yCursor)&&((veggieY+collideY)>yCursor))
				{
					// this means we are in the 'hitbox'!! kill the fruit!
					veggieObject[i].objectState = 2;
				}
			}
		}
	}
	return;
}

void disintegrateEngine()
{
	int i;
	for(i=1; i<16; i++)	// let's go through our objects
	{
		if(veggieObject[i].objectState == 2) // just been cut
		{
			veggieObject[i].objectState = 3;
		}
		else if(veggieObject[i].objectState == 3) // midway through
		{
			veggieObject[i].objectState = 4;
		}
		else if(veggieObject[i].objectState == 4) // almost dedded
		{
			veggieObject[i].xPosition = 0;		// gone!
			veggieObject[i].yPosition = 0;
			veggieObject[i].objectType = 0;
			veggieObject[i].objectState = 0;
			veggieObject[i].xVelocity = 0;
			veggieObject[i].yVelocity = 0;
		}
	}
}

// this function takes an array of 32-bit messages and sends them all out
void FPGAcommunicator()
{
	// start putting in our xcoords
	*to_hw_sig = 1;	// 1 means we're starting communication of xCoord
	*to_hw_port0 = veggieObject[0].xPosition;
	*to_hw_port1 = veggieObject[1].xPosition;
	*to_hw_port2 = veggieObject[2].xPosition;
	*to_hw_port3 = veggieObject[3].xPosition;
	*to_hw_port4 = veggieObject[4].xPosition;
	*to_hw_port5 = veggieObject[5].xPosition;
	*to_hw_port6 = veggieObject[6].xPosition;
	*to_hw_port7 = veggieObject[7].xPosition;
	*to_hw_port8 = veggieObject[8].xPosition;
	*to_hw_port9 = veggieObject[9].xPosition;
	*to_hw_port10 = veggieObject[10].xPosition;
	*to_hw_port11 = veggieObject[11].xPosition;
	*to_hw_port12 = veggieObject[12].xPosition;
	*to_hw_port13 = veggieObject[13].xPosition;
	*to_hw_port14 = veggieObject[14].xPosition;
	*to_hw_port15 = veggieObject[15].xPosition;
	// wait for response
	while(*to_sw_sig != 1);

	*to_hw_sig = 2;	// 2 means we're starting communication of yCoord
	*to_hw_port0 = veggieObject[0].yPosition;
	*to_hw_port1 = veggieObject[1].yPosition;
	*to_hw_port2 = veggieObject[2].yPosition;
	*to_hw_port3 = veggieObject[3].yPosition;
	*to_hw_port4 = veggieObject[4].yPosition;
	*to_hw_port5 = veggieObject[5].yPosition;
	*to_hw_port6 = veggieObject[6].yPosition;
	*to_hw_port7 = veggieObject[7].yPosition;
	*to_hw_port8 = veggieObject[8].yPosition;
	*to_hw_port9 = veggieObject[9].yPosition;
	*to_hw_port10 = veggieObject[10].yPosition;
	*to_hw_port11 = veggieObject[11].yPosition;
	*to_hw_port12 = veggieObject[12].yPosition;
	*to_hw_port13 = veggieObject[13].yPosition;
	*to_hw_port14 = veggieObject[14].yPosition;
	*to_hw_port15 = veggieObject[15].yPosition;
	// wait for confirmation
	while(*to_sw_sig != 2);

	// initialization of message we need to send to FPGA (array of 32-bit messages)
	unsigned int FPGAmessage[15];
	int i;		// load all of our structs in
	for (i=0; i<16; i++)
	{
		unsigned int tempPackage = messagePackager(veggieObject[i]);
	//	printf("Our %dth message is %llu\n", i, tempPackage);
		FPGAmessage[i] = tempPackage;
	}
	*to_hw_sig = 3;		// our final sending
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

	// last confirmation
	while(*to_sw_sig != 3);
	*to_hw_sig = 0;

	return;
}

// this function takes a single struct and converts it into a message we can send
unsigned long messagePackager(struct gameObject specifiedObject)
{
	// basic variables
	int packageType;
	unsigned int tempDecimal;
	unsigned long tempBinary;

	// figure out how to package it
	packageType = specifiedObject.packageType;

	if (packageType == 100)		// impossible number for now
	{
		// this means we are packaging our game package instead
		unsigned long tempScore, tempTime, tempStart, tempEnd;

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
		unsigned long tempType, tempState;

		// grab our stuff from the struct
//		tempType = specifiedObject.objectType;
//		tempState = specifiedObject.objectState;
		tempType = 4;
		tempState = 7;

		// and convert stuff to binary!
		tempType = convertDecimalToBinary(tempType);
		tempState = convertDecimalToBinary(tempState);
/*
		printf("tempX: %llu   ", tempX);
		printf("tempY: %llu   ", tempY);
		printf("tempType: %llu   ", tempType);
		printf("tempState: %llu   ", tempState);
*/
		// now we append everything together!
		tempBinary = tempState + tempType*1000;
		//	printf("tempBinary: %llu   ", tempBinary);
	}
	// and convert it back to decimal!
	// SEE IF WE CAN SEND TO HARDWARE TO DO THIS
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
	xCursor = *to_sw_port3;
	yCursor = *to_sw_port4;
	return;
}

// converts decimal to binary
unsigned long convertDecimalToBinary(unsigned long n)
{
	if (n == 0)
    {
        return 0;
    }
    else
    {
        return (n % 2 + 10 * convertDecimalToBinary(n / 2));
    }
}

// converts binary to decimal! (NOW FASTER AND BETTER THAN EVER!!)
unsigned long convertBinaryToDecimal(unsigned long long n)
{
 //	printf("binary input: %llu   ", n);
    unsigned decimal = 0;
    int i;
    for(i = 0; n > 0; ++i)
    {
        if((n % 10) == 1)
            decimal += (1 << i);

        n /= 10;
    }
    return decimal;
}
