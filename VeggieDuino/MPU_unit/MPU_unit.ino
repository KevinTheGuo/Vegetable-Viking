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

void setup() 
{
  Serial.begin(9600);
  Serial.println(F("Welcome to Veggie Viking! The newest revolution that's sweeping the nation!"));
  Serial.println(F("This is the MPU unit"));

  // set our radio stuff
  radio.begin();
  radio.setDataRate(RF24_250KBPS);
  radio.setChannel(108);
  radio.setPALevel(RF24_PA_HIGH); // we might need to do this or not

  // open radio pipes
  radio.openWritingPipe(addresses[1]);
//radio.openReadingPipe(1,addresses[0]);
  radio.stopListening();

  radioPackage.xCoordinate = 0;
  radioPackage.yCoordinate = 0;
  radioPackage.streakActive = 0;  
}

void loop() 
{
  // now we send out info!
  // Serial.println(F("Sending our info"));
   
  // now we are constantly sending our stuff
   if (!radio.write(&radioPackage, sizeof(radioPackage)))
   {
     Serial.println(F("oopsies, our stuff was not sent correctly"));
   }
}

