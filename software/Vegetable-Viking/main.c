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

// variable for adding additional score per fruit sliced
int comboFruit;

// variable for determining whether physics is on or not
int physixOn;

// timer variables we need to be global
unsigned long elapsedTime;
unsigned long lastPhysixed;
unsigned long lastSpawned;
unsigned long nextSpawnTime;
unsigned long lastDisintegrated;
unsigned long roundStart;

// declarations of functions and stuff
void statusEngine();	// keeps track of the game status
void physicsEngine();	// updates all the positions of our objects, with PHYSICS!
void spawningEngine(int pattern);	// spawn more objects!! with randomness!!
void slicingEngine();		// determines when objects are sliced, and how they behave
void disintegrateEngine();	// handles the disintegration animation of fruits/bomb
void FPGAcommunicator();	// sends our structs to FPGA
unsigned long messagePackager(struct gameObject);	// packages our messages
void port2Unpackager();		// unpackages messages from software port2, also does various other assorted things
unsigned long convertDecimalToBinary(unsigned long n);	// read the title
unsigned long convertBinaryToDecimal(unsigned long long n);	// can you even read

// our main function!!! this is where the magic happens
int main()
{
	// put in our seed
	srand(*to_sw_port0);

	// assign these to 0 at start
	comboFruit = 0;
	physixOn = 0;

	// initialize all our structs
	int i;
	for(i=0; i<16; i++)
	{
		veggieObject[i].xPosition = 0;
		veggieObject[i].yPosition = 0;
		veggieObject[i].objectType = 0;
		veggieObject[i].objectState = 0;
		veggieObject[i].xVelocity = 0;
		veggieObject[i].yVelocity = 0;
	}

	// TEST STUFF
	veggieObject[0].xPosition = 0;
	veggieObject[0].yPosition = 0;
	veggieObject[0].objectType = 0;
	veggieObject[0].objectState = 0;

	// start out in the initial black menu
	// FIX THIS LATER
	cursorClicked = 1;

	while(cursorClicked == 0)
	{
		FPGAcommunicator();	// call this every time to update the FPGA
		port2Unpackager();	// just run our unpackager
	}

	// initialize timing stuff
	unsigned long processorStart = *to_sw_port1;
	unsigned long processorTime = processorStart;
	lastPhysixed = processorTime;
	lastSpawned = processorTime;
	nextSpawnTime = processorTime;
	lastDisintegrated = processorTime;
	roundStart = 0;
//	printf("our start time is %ld \n", processorStart);

	// initialize our cursor and key stuff
	xCursor = *to_sw_port3;
	yCursor = *to_sw_port4;
	port2Unpackager();

	// initialize our 3 fruits on screen for menu
	veggieObject[1].xPosition = 30;
	veggieObject[1].yPosition = 100;
	veggieObject[1].objectState = 1;
	veggieObject[1].xVelocity = 0;
	veggieObject[1].yVelocity = 0;

	veggieObject[2].xPosition = 180;
	veggieObject[2].yPosition = 320;
	veggieObject[2].objectState = 1;
	veggieObject[2].xVelocity = 0;
	veggieObject[2].yVelocity = 0;

	veggieObject[3].xPosition = 540;
	veggieObject[3].yPosition = 220;
	veggieObject[3].objectState = 1;
	veggieObject[3].xVelocity = 0;
	veggieObject[3].yVelocity = 0;

	while(1)	// game while loop
	{
		// constantly updating our current time in seconds
		processorTime = *to_sw_port1;
//		printf("our time is %lu \n", processorTime);
		elapsedTime = processorTime - processorStart;
//		printf("elapsed time is %lu \n", elapsedTime);

		statusEngine();	// keep track of our game state

		// constantly doing physics
		if (((elapsedTime - lastPhysixed) > 5) && (physixOn))
		{
			// greater than .05 seconds pass, and we're in a game playing state
			physicsEngine();	// call our physics engine!
			lastPhysixed = elapsedTime;
		}

		// spawning objects
		if ((elapsedTime - lastSpawned) > nextSpawnTime)	// greater than random time
		{
			// determine next spawn time based on level
			if(veggieObject[0].objectState == 1)	// easy mode spawn
			{
				spawningEngine(rand() % 5);
				nextSpawnTime = (rand() % 50) + 75;
			}
			else if(veggieObject[0].objectState == 2)	// medium mode
			{
				spawningEngine(rand() % 7);
				nextSpawnTime = (rand() % 75) + 50;
			}
			else if(veggieObject[0].objectState == 3)	// easy mode spawn
			{
				spawningEngine(rand() % 9);
				nextSpawnTime = (rand() % 100 + 25);		// hard mode
			}
			else
			{
				nextSpawnTime = 200;	// we're in another state. check back soon!
			}
	//		printf("we generated a random number at %lu   ", nextSpawnTime);
			lastSpawned = elapsedTime;
		}

		if ((elapsedTime - lastDisintegrated) > 20)	// greater than .1 sec
		{
			disintegrateEngine();	// call our spawning engine!
			lastDisintegrated = elapsedTime;
		}
		slicingEngine();	// check if we need to slice anything
		port2Unpackager();	// keep unpacking our stuff! (also updates cursor)
		FPGAcommunicator();	// call this every time to update the FPGA
	}
	return 0;
}

void statusEngine()
{
	if((veggieObject[0].objectState > 0) && (veggieObject[0].objectState < 4))
	{
		// this means we're currently playing a round
		physixOn = 1;
		veggieObject[0].yPosition = 60 - ((elapsedTime - roundStart)/100);	// timer
		if(veggieObject[0].yPosition == 0)	// check if our timer ended
		{
			physixOn = 0;
			veggieObject[0].objectState = 4;	// move to GAME WON state

			int i;
			for(i=1; i<16; i++)
			{
				veggieObject[i].xPosition = 0;
				veggieObject[i].yPosition = 0;
				veggieObject[i].objectType = 0;
				veggieObject[i].objectState = 0;
				veggieObject[i].xVelocity = 0;
				veggieObject[i].yVelocity = 0;
			}

			printf("timed out\n");
		}
		else if(((veggieObject[0].objectState == 2) || (veggieObject[0].objectState == 3)) && (veggieObject[0].objectType <= 0))
		{
			// this means we're game over :(
			physixOn = 0;
			veggieObject[0].objectState = 5;	// move to GAME OVER state

			int i;
			for(i=1; i<16; i++)
			{
				veggieObject[i].xPosition = 0;
				veggieObject[i].yPosition = 0;
				veggieObject[i].objectType = 0;
				veggieObject[i].objectState = 0;
				veggieObject[i].xVelocity = 0;
				veggieObject[i].yVelocity = 0;
			}

			printf("game over\n");
		}
	}
	else if(veggieObject[0].objectState == 0)	// check if we're in menu
	{
		physixOn = 0;
		veggieObject[0].xPosition = 0;
		veggieObject[0].yPosition = 0;

		// initialize our 3 fruits on screen for menu
		veggieObject[1].xPosition = 30;
		veggieObject[1].yPosition = 100;
		veggieObject[1].objectState = 1;
		veggieObject[1].xVelocity = 0;
		veggieObject[1].yVelocity = 0;

		veggieObject[2].xPosition = 180;
		veggieObject[2].yPosition = 320;
		veggieObject[2].objectState = 1;
		veggieObject[2].xVelocity = 0;
		veggieObject[2].yVelocity = 0;

		veggieObject[3].xPosition = 540;
		veggieObject[3].yPosition = 220;
		veggieObject[3].objectState = 1;
		veggieObject[3].xVelocity = 0;
		veggieObject[3].yVelocity = 0;
	}
	else if((veggieObject[0].objectState == 4) || (veggieObject[0].objectState == 5))
	{
		// put in our veggie
		veggieObject[4].xPosition = 230;
		veggieObject[4].yPosition = 150;
		veggieObject[4].objectState = 1;
		veggieObject[4].xVelocity = 0;
		veggieObject[4].yVelocity = 0;

		physixOn = 0;
	}
}

void physicsEngine()
{
	int i;
	for(i=1; i<10; i++)	// update all our physics of all objects!
	{
		if(veggieObject[i].objectState != 0)	// does it even exist?
		{
			// PHYSICS MAGIC!
			veggieObject[i].xPosition = veggieObject[i].xPosition + veggieObject[i].xVelocity;
			veggieObject[i].yPosition = veggieObject[i].yPosition + veggieObject[i].yVelocity;
			veggieObject[i].yVelocity = veggieObject[i].yVelocity - 1;
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

				// reduce score!
				if(i<9)
				{
					veggieObject[0].xPosition = veggieObject[0].xPosition - 5;
					printf("veggie escaped! score decreased to %d! \n", veggieObject[0].xPosition);
				}
			//	printf("eliminating object %d! \n", i);
			}
		}
	}
	return;
}

void spawningEngine(int pattern)
{
	if(pattern == 0)	// one pattern will have us skip a spawn...caus whatev
	{
		return;
	}
	else if((pattern == 7) || (pattern == 9))	// they want us.. to build a bomb!
	{
		if((rand() % 3) == 1)	// one last chance to not bomb this!
		{
			if(veggieObject[9].objectState == 0)	// if one doesn't exist, go!
			{
				unsigned int randomX;	// x coordinate on bottom of screen
				double randomSpeedY, randomSpeedX;	// starting velocity

				// RANDOM GENERATION!!
				randomX = (rand() % 540) + 50;
				randomSpeedY = (rand() % 7) + 24;
				randomSpeedX = (rand() % 12) - 6;

				// make sure we aren't throwing them out the edges
				if (randomX < 300)
				{
					randomSpeedX = (rand() % 12);
				}
				else if (randomX > 350)
				{
					randomSpeedX = (rand() % 12) - 12;
				}

				// now let's store these
				veggieObject[9].xPosition = randomX;
				veggieObject[9].yPosition = 0;
				veggieObject[9].objectType = 0;
				veggieObject[9].xVelocity = randomSpeedX;
				veggieObject[9].yVelocity = randomSpeedY;
				veggieObject[9].objectState = 1;	// reserve this slot

				return; // our evillness is done!!!
			}
		}
	}
	int i, j;
	for(j=1; j<9; j++)	// let's go through our veggies and see which ones are free
	{
		i = (rand() % 14 + 1);	// put it in a random port for random veggies
		if(veggieObject[i].objectState == 0)	// if one doesn't exist, go for it
		{
			unsigned int randomX;	// x coordinate on bottom of screen
			double randomSpeedY, randomSpeedX;	// starting velocity
			veggieObject[i].objectState = 1;	// reserve this slot

			if(pattern >= 5)	// can spawn multiples and identical depending on pattern
			{
				int j;
				for(j=4; j<pattern; j++)
				{
					spawningEngine(1);	// call ourselves to spawn another!
				}
			}

			// RANDOM GENERATION!!
			randomX = (rand() % 540) + 50;
			randomSpeedY = (rand() % 7) + 24;
			randomSpeedX = (rand() % 12) - 6;

			// make sure we aren't throwing them out the edges
			if (randomX < 250)
			{
				randomSpeedX = (rand() % 12);
			}
			else if (randomX > 400)
			{
				randomSpeedX = (rand() % 12) - 12;
			}

			// now let's store these
			veggieObject[i].xPosition = randomX;
			veggieObject[i].yPosition = 0;
			veggieObject[i].xVelocity = randomSpeedX;
			veggieObject[i].yVelocity = randomSpeedY;
/*			printf("x is %lu  ", randomX);
			printf("type is %d  ", randomType);
			printf("xvelocity is %f  ", randomSpeedX);
			printf("yvelocity is %f  \n", randomSpeedY);	*/
			return;
		}
	}
	return;
}

void slicingEngine()
{
	if((veggieObject[0].objectState == 0)&&(cursorStreak))	// this is menu state
	{
		// let's check menu collision
		// THIS IS TO DO
		if((xCursor>30)&&(xCursor<100)&&(yCursor>30)&&(yCursor<100))
		{
			veggieObject[0].objectState = 1;	// easy mode start
			veggieObject[0].objectType = 0;		// where we're goin, we don't need lives
			physixOn = 1;
			veggieObject[1].objectState = 2;	// cut the object!
			roundStart = elapsedTime;
		}
		else if((xCursor>180)&&(xCursor<250)&&(yCursor>220)&&(yCursor<310))
		{
			veggieObject[0].objectState = 2;	// medium mode start
			veggieObject[0].objectType = 7;		// lots of lives for u!
			physixOn = 1;
			veggieObject[2].objectState = 2;	// cut the object!
			roundStart = elapsedTime;
		}
		else if((xCursor>450)&&(xCursor<520)&&(yCursor>120)&&(yCursor<210))
		{
			veggieObject[0].objectState = 3;	// hard mode start
			veggieObject[0].objectType = 3;		// ..good luck...you'll need it
			physixOn = 1;
			veggieObject[3].objectState = 2;	// cut the object!
			roundStart = elapsedTime;
		}
	}
	else if(((veggieObject[0].objectState == 4) || (veggieObject[0].objectState == 5))&&(cursorStreak))
	{
		// DO MORE MENU COLLISION
		if((xCursor>230)&&(xCursor<300)&&(yCursor>80)&&(yCursor<150))
		{
			veggieObject[0].objectState = 0;	// return to main menu
			veggieObject[4].objectState = 2;	// cut the object!

			physixOn = 0;
		}
	}
	else	// we can cut!
	{
		int i;
		for(i=1; i<10; i++)	// let's go through our objects and see which ones collide
		{
			// only if it is in perfect state
			if(veggieObject[i].objectState == 1)
			{
				// let's grab the vegetable coordinates
				int veggieX = veggieObject[i].xPosition;
				int veggieY = veggieObject[i].yPosition;

/*				// let's set our collision box
				int collideX = 64;
				int collideY = 64;
				int offsetX = 10;
				if((veggieObject[i].objectType == 1)) //eggplant
				{
					collideX = 64;
					collideY = 85;
				}
				else if((veggieObject[i].objectType == 2))	// potato
				{
					collideX = 64;
					collideY = 80;
				}
				else if((veggieObject[i].objectType == 3)) 	// carrot
				{
					collideX = 64;
					collideY = 40;
				}
				else if((veggieObject[i].objectType == 6))	// tomato
				{
					collideX = 64;
					collideY = 40;
				}
				else	// broccoli, cabbage, radish, onion
				{
					collideX = 64;
					collideY = 64;
				}
*/
				// now let's check collision
				if(((veggieX)<xCursor)&&((veggieX+75)>xCursor)&&((veggieY-60)<yCursor)&&((veggieY+15)>yCursor))
				{
					// this means we are in the 'hitbox'!! kill the fruit!
					veggieObject[i].objectState = 2;

					if(i<14)
					{
						comboFruit = comboFruit + 1;
						veggieObject[0].xPosition = veggieObject[0].xPosition + 2*comboFruit;
						printf(" increased score to %d! \n", veggieObject[0].xPosition);
						printf("lives still at %d! \n", veggieObject[0].objectType);
					}
					else	// ITS A BOMB!!! OMGOGMGOMGG!!
					{
						veggieObject[0].objectType = veggieObject[0].objectType-1;
						comboFruit = 0;
						veggieObject[0].xPosition = veggieObject[0].xPosition - 25;
						printf("hit a bomb! scored decreased to %d! \n", veggieObject[0].xPosition);
						printf("also, lives decreased to %d! \n", veggieObject[0].objectType);
					}
				}
			}
		}
	}
	return;
}

void disintegrateEngine()
{
	int i;
	for(i=1; i<10; i++)	// let's go through our objects
	{
		if(veggieObject[i].objectState == 2) // just been cut
		{
			veggieObject[i].objectState = 3;
		}
		else if(veggieObject[i].objectState == 3) // almost dedded
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
/*	*to_hw_port10 = veggieObject[10].xPosition;
	*to_hw_port11 = veggieObject[11].xPosition;
	*to_hw_port12 = veggieObject[12].xPosition;
	*to_hw_port13 = veggieObject[13].xPosition;
	*to_hw_port14 = veggieObject[14].xPosition;
	*to_hw_port15 = veggieObject[15].xPosition;
*/	// wait for response
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
/*	*to_hw_port10 = veggieObject[10].yPosition;
	*to_hw_port11 = veggieObject[11].yPosition;
	*to_hw_port12 = veggieObject[12].yPosition;
	*to_hw_port13 = veggieObject[13].yPosition;
	*to_hw_port14 = veggieObject[14].yPosition;
	*to_hw_port15 = veggieObject[15].yPosition;
*/	// wait for confirmation
	while(*to_sw_sig != 2);

	// initialization of message we need to send to FPGA (array of 32-bit messages)
	unsigned int FPGAmessage = messagePackager(veggieObject[0]);
	// printf("fpgamessage is %lu   \n", FPGAmessage);

	*to_hw_sig = 3;		// our final sending
	*to_hw_port0 = FPGAmessage;
	*to_hw_port1 = veggieObject[1].objectState;
	*to_hw_port2 = veggieObject[2].objectState;
	*to_hw_port3 = veggieObject[3].objectState;
	*to_hw_port4 = veggieObject[4].objectState;
	*to_hw_port5 = veggieObject[5].objectState;
	*to_hw_port6 = veggieObject[6].objectState;
	*to_hw_port7 = veggieObject[7].objectState;
	*to_hw_port8 = veggieObject[8].objectState;
	*to_hw_port9 = veggieObject[9].objectState;
/*	*to_hw_port10 = veggieObject[10].objectState;
	*to_hw_port11 = veggieObject[11].objectState;
	*to_hw_port12 = veggieObject[12].objectState;
	*to_hw_port13 = veggieObject[13].objectState;
	*to_hw_port14 = veggieObject[14].objectState;
	*to_hw_port15 = veggieObject[15].objectState;
*/
	// last confirmation
	while(*to_sw_sig != 3);
	*to_hw_sig = 0;

	return;
}

// this function takes a single struct and converts it into a message we can send
unsigned long messagePackager(struct gameObject specifiedObject)
{
	// basic variables
	unsigned int tempDecimal;
	unsigned long tempBinary;

	// make our specific variables
	unsigned long tempType, tempState;

	// grab our stuff from the struct
	tempType = specifiedObject.objectType;
	tempState = specifiedObject.objectState;

	// and convert stuff to binary!
	tempType = convertDecimalToBinary(tempType);
	tempState = convertDecimalToBinary(tempState);

//	printf("tempX: %llu   ", tempX);
//	printf("tempY: %llu   ", tempY);
//	printf("tempType: %lu   ", tempType);
//	printf("tempState: %lu   \n", tempState);

	// now we append everything together!
	tempBinary = tempState + tempType*1000;
//		printf("tempBinary: %lu   ", tempBinary);

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

	if(cursorStreak == 0)	// reset combo if cursor no longer streaking
	{
		comboFruit = 0;
	}

	if(veggieObject[0].xPosition < 0)	// also don't let score go below zero
	{
		veggieObject[0].xPosition = 0;
	}

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


