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

#include <SPI.h>
#include "RF24.h"

// the Radio object
RF24 radio(7,8);

// veggi is for FPGA writing(if any), vikin is for sword writing
byte addresses[][6] = {"veggi","vikin"};

// our struct for transmission
struct dataPackage{
  unsigned int xCoordinate;    
  unsigned int yCoordinate;
  unsigned int streakActive;
};
struct dataPackage radioPackage;

// all our pin constants!
const int xyPin = 3;
const int coordinatePin0 = 3;
const int coordinatePin1 = 2;
const int coordinatePin2 = 3;
const int coordinatePin3 = 3;
const int coordinatePin4 = 3;
const int coordinatePin5 = 3;
const int coordinatePin6 = 3;
const int coordinatePin7 = 3;
const int coordinatePin8 = 3;
const int coordinatePin9 = 3;
const int streakPin = 3;

// our timer variable
unsigned long currentMillis; 
unsigned long lastTransmittedMillis; 

// our last transmitted type
int transmittedType;    // 0 means last transmitted was x, 1 means y

// our binary arrays
int xArray[10];
int yArray[10];

void setup() 
{
  Serial.begin(9600);
  Serial.println(F("Welcome to Veggie Viking! The newest revolution that's sweeping the nation!"));
  Serial.println(F("This is the FPGA unit"));

  // set our radio stuff
  radio.begin();
  radio.setDataRate(RF24_250KBPS);
  radio.setChannel(108);
  radio.setPALevel(RF24_PA_HIGH); // we might need to do this or not

//radio.openWritingPipe(addresses[0]);
  radio.openReadingPipe(1,addresses[1]);
  radio.startListening();

  radioPackage.xCoordinate = 0;
  radioPackage.yCoordinate = 0;
  radioPackage.streakActive = 0;

  // doing all our pin stuff
  pinMode(xyPin, OUTPUT);   
  pinMode(coordinatePin0, OUTPUT); 
  pinMode(coordinatePin1, OUTPUT);   
  pinMode(coordinatePin2, OUTPUT); 
  pinMode(coordinatePin3, OUTPUT); 
  pinMode(coordinatePin4, OUTPUT); 
  pinMode(coordinatePin5, OUTPUT); 
  pinMode(coordinatePin6, OUTPUT); 
  pinMode(coordinatePin7, OUTPUT); 
  pinMode(coordinatePin8, OUTPUT); 
  pinMode(coordinatePin9, OUTPUT); 
  pinMode(streakPin, OUTPUT);   

  // let's fill our arrays with 0's and stuff
  int i;
  for(i=0; i<10; i++)
  {
    xArray[i] = 0;
    yArray[i] = 0;
  }
}

void loop() 
{
  if(radio.available())
  {
    Serial.println(F("We got something!"));
    while(radio.available())
    {
      radio.read(&radioPackage, sizeof(radioPackage));  // read in our thing
    }
    // now let's put our stuff into our arrays
    decimalToBinary(radioPackage.xCoordinate, 10, xArray);
    decimalToBinary(radioPackage.yCoordinate, 10, yArray);
  }

  if(currentMillis - lastTransmittedMillis >= 5)    // change our transmission once every 5 milliseconds
  {
    lastTransmittedMillis = currentMillis;

    if(transmittedType)   // this means our last transmitted was y
    {
      // TRANSMIT X
      digitalWrite(coordinatePin0, xArray[0]); 
      digitalWrite(coordinatePin1, xArray[1]); 
      digitalWrite(coordinatePin2, xArray[2]); 
      digitalWrite(coordinatePin3, xArray[3]); 
      digitalWrite(coordinatePin4, xArray[4]); 
      digitalWrite(coordinatePin5, xArray[5]); 
      digitalWrite(coordinatePin6, xArray[6]); 
      digitalWrite(coordinatePin7, xArray[7]); 
      digitalWrite(coordinatePin8, xArray[8]); 
      digitalWrite(coordinatePin9, xArray[9]); // i am kevin hear me rawr
      digitalWrite(xyPin, transmittedType); 
      transmittedType = 0;   // flip around our xy pin 
    }
    else   // this means our last transmitted was x
    {
      // TRANSMIT Y
      digitalWrite(coordinatePin0, yArray[0]); 
      digitalWrite(coordinatePin1, yArray[1]); 
      digitalWrite(coordinatePin2, yArray[2]); 
      digitalWrite(coordinatePin3, yArray[3]); 
      digitalWrite(coordinatePin4, yArray[4]); 
      digitalWrite(coordinatePin5, yArray[5]); 
      digitalWrite(coordinatePin6, yArray[6]); 
      digitalWrite(coordinatePin7, yArray[7]); 
      digitalWrite(coordinatePin8, yArray[8]); 
      digitalWrite(coordinatePin9, yArray[9]); // i am kevin hear me rawr
      digitalWrite(xyPin, transmittedType); 
      transmittedType = 1;   // flip around our xy pin 
    }
  }
}

void decimalToBinary(unsigned int decimal, int inputSize, int* binaryArray)
{
  unsigned int mask = 1U << (inputSize-1);
  int i;
  for(i=0; i<inputSize; i++)
  {
    binaryArray[i] = (decimal & mask) ? 1:0;
    decimal <<=1;
  }  
}

