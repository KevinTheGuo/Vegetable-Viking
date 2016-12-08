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

// our regular includes and stuff
#include "I2Cdev.h"
#include "MPU6050_6Axis_MotionApps20.h"
#include <SPI.h>
#include "RF24.h"

// pin constants!             STILL NEED TO ASSIGN ARDUINO PINS
const int buttonPin = 6;   // pin for our clicky button

#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
    #include "Wire.h"
#endif

// declare our mpu object
MPU6050 mpu;

// MPU control and status variables
bool dmpReady = false;  // set true if DMP init was successful
uint8_t mpuIntStatus;   // holds actual interrupt status byte from MPU
uint8_t devStatus;      // return status after each device operation (0 = success, !0 = error)
uint16_t packetSize;    // expected DMP packet size (default is 42 bytes)
uint16_t fifoCount;     // count of all bytes currently in FIFO
uint8_t fifoBuffer[64]; // FIFO storage buffer

// MPU orientation and motion variables
Quaternion q;           // [w, x, y, z]         quaternion container
VectorInt16 aa;         // [x, y, z]            accel sensor measurements
VectorInt16 aaReal;     // [x, y, z]            gravity-free accel sensor measurements
VectorInt16 aaWorld;    // [x, y, z]            world-frame accel sensor measurements
VectorFloat gravity;    // [x, y, z]            gravity vector
float euler[3];         // [psi, theta, phi]    Euler angle container
float ypr[3];           // [yaw, pitch, roll]   yaw/pitch/roll container and gravity vector

// MPU interruption detection
volatile bool mpuInterrupt = false;     // indicates whether MPU interrupt pin has gone high
void dmpDataReady() {
    mpuInterrupt = true;
}

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

// our timer variable
unsigned long currentMillis = 0; 
unsigned long streakMillis = 0; 

// whole buncha global variables
int prevX, prevY;
float currYaw, currPitch, currRoll, prevYaw, prevPitch, prevRoll;
long currGrav, prevGrav;

// glitch tracker, to see if we've encountered a glitch this loop
int antiGlitch;

// anti-anti-glitch variable, prevents us from staying in anti-glitch mode for too long
int glitchCounter;

// and a mode that tells us whether to operate normally or ignore antiglitch
int deGlitchMode;


void setup() 
{
/*  Serial.begin(38400);
  Serial.println(F("Welcome to Veggie Viking! The newest revolution that's sweeping the nation!"));
  Serial.println(F("This is the MPU unit"));
*/
  // join I2C bus (I2Cdev library doesn't do this automatically)
  #if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
      Wire.begin();
      TWBR = 24; // 400kHz I2C clock (200kHz if CPU is 8MHz)
  #elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
      Fastwire::setup(400, true);
  #endif

  // initialize object
  devStatus = mpu.dmpInitialize();

  // set offsets
  mpu.setXGyroOffset(191);
  mpu.setYGyroOffset(2);
  mpu.setZGyroOffset(-22);
  mpu.setZAccelOffset(1289); // 1688 factory default for my test chip
  
  // make sure all our MPU stuff worked, and turn it on!
  if (devStatus == 0) {
      // turn on the DMP, now that it's ready
//      Serial.println(F("Enabling DMP..."));
      mpu.setDMPEnabled(true);

      // enable Arduino interrupt detection
//      Serial.println(F("Enabling interrupt detection (Arduino external interrupt 0)..."));
      attachInterrupt(0, dmpDataReady, RISING);
      mpuIntStatus = mpu.getIntStatus();

      // set our DMP Ready flag so the main loop() function knows it's okay to use it
//      Serial.println(F("DMP ready! Waiting for first interrupt..."));
      dmpReady = true;

      // get expected DMP packet size for later comparison
      packetSize = mpu.dmpGetFIFOPacketSize();
  } else {
      // ERROR!
      // 1 = initial memory load failed
      // 2 = DMP configuration updates failed
      // (if it's going to break, usually the code will be 1)
/*      Serial.print(F("DMP Initialization failed (code "));
      Serial.print(devStatus);
      Serial.println(F(")"));
*/  }

  // set our radio stuff
  radio.begin();
  radio.setDataRate(RF24_250KBPS);
  radio.setChannel(108);
  radio.setPALevel(RF24_PA_LOW); // we might need to do this or not

  // open radio pipes
  radio.openWritingPipe(addresses[1]);
//radio.openReadingPipe(1,addresses[0]);
  radio.stopListening();

  // initialize our structs
  radioPackage.xCoordinate = 320;
  radioPackage.yCoordinate = 240;
  radioPackage.streakActive = 0; 
  radioPackage.buttonClicked = 0;   

  // do our input pullup! this means it is normally high, and active low
  pinMode(buttonPin, INPUT_PULLUP); 

  // and set a gravity thing so it wont scream at me
  prevGrav = 8000;

  // and antiglitch
  antiGlitch = 0;
  glitchCounter = 0;
  deGlitchMode = 1;
}

void loop() 
{
  // if programming failed, don't try to do anything
  if (!dmpReady) return;

  // timer stuff
  currentMillis = millis();

  // reset interrupt flag and get INT_STATUS byte
  mpuInterrupt = false;
  mpuIntStatus = mpu.getIntStatus();

  // get current FIFO count
  fifoCount = mpu.getFIFOCount();

  // wait for correct available data length, should be a VERY short wait
  while (fifoCount < packetSize) fifoCount = mpu.getFIFOCount();

  // read a packet from FIFO
  mpu.getFIFOBytes(fifoBuffer, packetSize);
  mpu.resetFIFO();    // AND CLEAR THE FFER
  
  // track FIFO count here in case there is > 1 packet available
  // (this lets us immediately read more without waiting for an interrupt)
  fifoCount -= packetSize;

// displaying yaw, pitch and roll
  mpu.dmpGetQuaternion(&q, fifoBuffer);
  mpu.dmpGetGravity(&gravity, &q);
  mpu.dmpGetYawPitchRoll(ypr, &q, &gravity);
  mpu.dmpGetAccel(&aa, fifoBuffer);
/*
  Serial.print("ypr\t");
  Serial.print(ypr[0] * 180/M_PI);
  Serial.print("\t");
  Serial.print(ypr[1] * 180/M_PI);
  Serial.print("\t");
  Serial.print(ypr[2] * 180/M_PI);
  Serial.print("\t");
  Serial.print("angular velocity is");
  Serial.println(gyro);
*/
  
  // save previous coordinate values
  prevX = radioPackage.xCoordinate;
  prevY = radioPackage.yCoordinate;
  prevRoll = currRoll;    // and roll!
  prevGrav = currGrav;    // and gravity!
  
  // save our currpitch and yaw (and roll and gravity!)
  currYaw = (ypr[0] * 180/M_PI);
  currPitch = -(ypr[1] * 180/M_PI);
  currRoll = (ypr[2] * 180/M_PI);
  currGrav = aa.z;

/*  Serial.print(F("currYaw is "));
  Serial.print(currYaw);
  Serial.print(F("      currPitch is "));
  Serial.println(currPitch);
*/    

  // disregard crazy gravity values
  if((abs(currGrav - prevGrav) > 6000) && (deGlitchMode))
  {
//    Serial.println(F("Woah there! Who forgot to pay the gravity bill?!"));
    currGrav = prevGrav;
    antiGlitch = 1;
  }

  // now turn these into our 640x480 coordinate system
  if((currRoll > 60) || (currRoll < -60)) // are we vertical?
  {
    radioPackage.xCoordinate = prevX;
    radioPackage.yCoordinate = 4*currPitch + 240; //disregard x coordinate
  }
  else if(currGrav > 1000)    // check if orientation is upright
  {
    radioPackage.xCoordinate = 4*currYaw + 320; 
    radioPackage.yCoordinate = 4*currPitch + 240;      
  }
  else if(currGrav < -1000)              // else it's not upright
  {
    radioPackage.xCoordinate = -(4*currYaw) + 320;    // flip x 
    radioPackage.yCoordinate = 4*currPitch + 240;       
  }
  else  // SENSOR FUSION!!! gravity and roll work together to eliminate glitches!
  {
    radioPackage.xCoordinate = prevX;
    radioPackage.yCoordinate = 4*currPitch + 240;
  }
  
  // also check for boundaries
  if(radioPackage.xCoordinate > 640)
  {
    radioPackage.xCoordinate = 640;
  }
  else if(radioPackage.xCoordinate < 0)
  {
    radioPackage.xCoordinate = 0;
  }
  if(radioPackage.yCoordinate > 480)
  {
    radioPackage.yCoordinate = 480;
  }
  else if(radioPackage.yCoordinate < 0)
  {
    radioPackage.yCoordinate = 0;
  }  

  // disregard crazy coordinate values
  if(((abs(radioPackage.xCoordinate - prevX) > 64) || (abs(radioPackage.yCoordinate - prevY) > 48)) && (deGlitchMode))
  {
/*    Serial.print(F("Woah there! Got a crazy coordinate!         "));
    Serial.print(F("xCoord: "));
    Serial.print(radioPackage.xCoordinate);
    Serial.print(F("    yCoord: "));
    Serial.println(radioPackage.yCoordinate);
*/    radioPackage.xCoordinate = prevX;
    radioPackage.yCoordinate = prevY;
    antiGlitch = 1;
  }
  
  // check if angular velocity is above our threshold (or has been recently)
  if((abs(radioPackage.xCoordinate - prevX)+abs(radioPackage.yCoordinate - prevY)) > 6)
  {
    radioPackage.streakActive = 1;
    streakMillis = currentMillis;   // update last time we had a streak
  }
  else if (currentMillis - streakMillis < 50)
  {
    radioPackage.streakActive = 1;
  }
  else
  {
    radioPackage.streakActive = 0;
  }
/*
  // print statements
  Serial.print(F("xCoord: "));
  Serial.print(radioPackage.xCoordinate);
  Serial.print(F("    yCoord: "));
  Serial.print(radioPackage.yCoordinate);
  Serial.print(F("    Streak: "));
  Serial.print(radioPackage.streakActive);
  Serial.print(F("    Gravity: "));
  Serial.print(currGrav);
  Serial.print(F("    Roll: "));
  Serial.println(currRoll);
*/
  // our antiglitch stuff
  if(antiGlitch)
  {
    glitchCounter++;
  }
  else
  {
    glitchCounter = 0;
  }

  // whether to stay in deGlitch mode or not
  deGlitchMode = 1;
  if(glitchCounter == 25)
  {
    deGlitchMode = 0;
    glitchCounter = 0;
  }

  // send our radio message every loop!
 if(!radio.write(&radioPackage, sizeof(radioPackage)))
 {
 //  Serial.println(F("oopsies, our stuff was not sent correctly"));
 }  

  // check if our button has been pressed! (active low)
 if(!digitalRead(buttonPin))
 {
    // if it's pressed, reset out MPU!
//    Serial.println(F("button clicked! reset our MPU!"));
    mpu.setDMPEnabled(false);

    // update radio
    radioPackage.xCoordinate = 320;
    radioPackage.streakActive = 0; 
    radioPackage.buttonClicked = 1;  
    if(!radio.write(&radioPackage, sizeof(radioPackage)))
    {
    //  Serial.println(F("oopsies, our stuff was not sent correctly"));
    }  
    // and delay for a sec
    delay(1000);

    mpu.dmpInitialize();
    mpu.setXGyroOffset(191);
    mpu.setYGyroOffset(2);
    mpu.setZGyroOffset(-22);
    mpu.setZAccelOffset(1289); // 1688 factory default for my test chip
    mpu.setDMPEnabled(true);
    // enable Arduino interrupt detection
    attachInterrupt(0, dmpDataReady, RISING);
    mpuIntStatus = mpu.getIntStatus();

    // set our DMP Ready flag so the main loop() function knows it's okay to use it
//    Serial.println(F("RESET is DONE!!!"));
    dmpReady = true;
    radioPackage.buttonClicked = 0;   // do our button stuff
 }
}

