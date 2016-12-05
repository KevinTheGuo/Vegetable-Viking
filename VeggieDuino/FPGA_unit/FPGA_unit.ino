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
  int xCoordinate;    
  int yCoordinate;
  bool streakActive;
  bool buttonClicked;
};
struct dataPackage radioPackage;

// all our pin constants!             STILL NEED TO ASSIGN ARDUINO PINS
const int coordinatePin0 = 2;   // GPIO pin 0                       yellow
const int coordinatePin1 = 3;   // GPIO pin 1                       green
const int coordinatePin2 = 4;   // GPIO pin 2                       blue
const int coordinatePin3 = 5;   // GPIO pin 3                       purple
const int coordinatePin4 = 6;   // GPIO pin 4                       grey
const int coordinatePin5 = 9;   // GPIO pin 5                       white
const int coordinatePin6 = 10;   // GPIO pin 6                      black
const int coordinatePin7 = 14;   // GPIO pin 7      14 = A0         brown
const int coordinatePin8 = 15;   // GPIO pin 8      15 = A1         red
const int coordinatePin9 = 16;   // GPIO pin 9      16 = A2         orange
const int xyPin = 17;            // GPIO pin 10     17 = A3         short white
const int streakPin = 18;        // GPIO pin 11     18 = A4         short grey
const int buttonPin = 19;        // GPIO pin 12     19 = A5         short orange

// our timer variable
unsigned long currentMillis; 
unsigned long lastTransmittedMillis; 

// our last transmitted type
bool transmittedType;    // 0 means last transmitted was x, 1 means y

// our binary arrays
bool xArray[10];
bool yArray[10];

void setup() 
{
//  Serial.begin(9600);
//  Serial.println(F("Welcome to Veggie Viking! The newest revolution that's sweeping the nation!"));
//  Serial.println(F("This is the FPGA unit"));

  // set our radio stuff
  radio.begin();
  radio.setDataRate(RF24_250KBPS);
  radio.setChannel(108);
  radio.setPALevel(RF24_PA_HIGH); // we might need to do this or not

//radio.openWritingPipe(addresses[0]);
  radio.openReadingPipe(1,addresses[1]);
  radio.startListening();

  radioPackage.xCoordinate = 420;
  radioPackage.yCoordinate = 75;
  radioPackage.streakActive = 1;
  radioPackage.buttonClicked = 0;

  // now let's put our stuff into our arrays
  decimalToBinary(radioPackage.xCoordinate, 10, xArray);
  decimalToBinary(radioPackage.yCoordinate, 10, yArray);

  // doing all our pinmode stuff   
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
  pinMode(xyPin, OUTPUT);
  pinMode(streakPin, OUTPUT);  
  pinMode(buttonPin, OUTPUT);

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
  //    Serial.println(F("We got something!"));
    while(radio.available())
    {
      radio.read(&radioPackage, sizeof(radioPackage));  // read in our thing
    }
/*    Serial.print("x is ");
    Serial.print(radioPackage.xCoordinate);
    Serial.print("     y is ");
    Serial.print(radioPackage.yCoordinate);
    Serial.print("     streak is ");
    Serial.print(radioPackage.streakActive);
    Serial.print("     button is ");
    Serial.println(radioPackage.buttonClicked);
*/  }

    // now let's put our stuff into our arrays
    decimalToBinary(radioPackage.xCoordinate, 10, xArray);
    decimalToBinary(radioPackage.yCoordinate, 10, yArray);

  // timer stuff
  currentMillis = millis();
  if(currentMillis - lastTransmittedMillis >= 2)    // make a new transmission once every 2 milliseconds
  {
    lastTransmittedMillis = currentMillis;

    if(transmittedType)   // this means our last transmitted was y
    {
      // TRANSMIT X
      digitalWrite(coordinatePin0, xArray[9]);      // reverse our order cause thats how we made it, huh!!
      digitalWrite(coordinatePin1, xArray[8]); 
      digitalWrite(coordinatePin2, xArray[7]); 
      digitalWrite(coordinatePin3, xArray[6]); 
      digitalWrite(coordinatePin4, xArray[5]); 
      digitalWrite(coordinatePin5, xArray[4]); 
      digitalWrite(coordinatePin6, xArray[3]); 
      digitalWrite(coordinatePin7, xArray[2]); 
      digitalWrite(coordinatePin8, xArray[1]); 
      digitalWrite(coordinatePin9, xArray[0]); // i am kevin hear me rawr
      digitalWrite(xyPin, transmittedType); 
      transmittedType = 0;   // TRANSMITTED X indicator
 //     Serial.println(F("transmitted X"));
    }
    else   // this means our last transmitted was x
    {
      // TRANSMIT Y
      digitalWrite(coordinatePin0, yArray[9]); 
      digitalWrite(coordinatePin1, yArray[8]); 
      digitalWrite(coordinatePin2, yArray[7]); 
      digitalWrite(coordinatePin3, yArray[6]); 
      digitalWrite(coordinatePin4, yArray[5]); 
      digitalWrite(coordinatePin5, yArray[4]); 
      digitalWrite(coordinatePin6, yArray[3]); 
      digitalWrite(coordinatePin7, yArray[2]); 
      digitalWrite(coordinatePin8, yArray[1]); 
      digitalWrite(coordinatePin9, yArray[0]); // i am kevin hear me rawr
      digitalWrite(xyPin, transmittedType); 
      transmittedType = 1;   // TRANSMITTED Y indicator
  //    Serial.println(F("transmitted Y"));
    }
      // stuff we always do
      digitalWrite(streakPin, radioPackage.streakActive); 
      digitalWrite(buttonPin, radioPackage.buttonClicked); 
  }
}

void decimalToBinary(unsigned int decimal, int inputSize, bool* binaryArray)
{
  // haha i actually have very little idea how this works
  unsigned int mask = 1U << (inputSize-1);
  int i;
  for(i=0; i<inputSize; i++)
  {
    binaryArray[i] = (decimal & mask) ? 1:0;
    decimal <<=1;
  }  
}

