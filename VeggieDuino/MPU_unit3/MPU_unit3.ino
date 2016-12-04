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
#include <SoftEasyTransfer.h>
#include <SoftwareSerial.h>

// initialize our softwareserial
SoftwareSerial mySerial(3, 4);

// create our transfer object
SoftEasyTransfer PLSwork; 

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
int gyro;

// MPU interruption detection
volatile bool mpuInterrupt = false;     // indicates whether MPU interrupt pin has gone high
void dmpDataReady() {
    mpuInterrupt = true;
}

// our struct for transmission
struct MPUPackage{
  float pitch;
  float yaw;
  bool streakActive;
};
struct MPUPackage serialPackage;

void setup() 
{
  Serial.begin(115200);
  Serial.println(F("Welcome to Veggie Viking! The newest revolution that's sweeping the nation!"));
  Serial.println(F("This is the MPU unit"));

  // begin our software serial transmission
  mySerial.begin(9600);
  PLSwork.begin(details(serialPackage), &mySerial);

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
  mpu.setXGyroOffset(192);
  mpu.setYGyroOffset(2);
  mpu.setZGyroOffset(-21);
  mpu.setZAccelOffset(1277); // 1688 factory default for my test chip
  
  // make sure all our MPU stuff worked, and turn it on!
  if (devStatus == 0) {
      // turn on the DMP, now that it's ready
      Serial.println(F("Enabling DMP..."));
      mpu.setDMPEnabled(true);

      // enable Arduino interrupt detection
      Serial.println(F("Enabling interrupt detection (Arduino external interrupt 0)..."));
      attachInterrupt(0, dmpDataReady, RISING);
      mpuIntStatus = mpu.getIntStatus();

      // set our DMP Ready flag so the main loop() function knows it's okay to use it
      Serial.println(F("DMP ready! Waiting for first interrupt..."));
      dmpReady = true;

      // get expected DMP packet size for later comparison
      packetSize = mpu.dmpGetFIFOPacketSize();
  } else {
      // ERROR!
      // 1 = initial memory load failed
      // 2 = DMP configuration updates failed
      // (if it's going to break, usually the code will be 1)
      Serial.print(F("DMP Initialization failed (code "));
      Serial.print(devStatus);
      Serial.println(F(")"));
  }

  serialPackage.pitch = 0;
  serialPackage.yaw = 0;
  serialPackage.streakActive = 0;  
}

void loop() 
{
  // if programming failed, don't try to do anything
  if (!dmpReady) return;

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
    mpu.dmpGetGyro(&gyro, fifoBuffer);
    mpu.dmpGetGravity(&gravity, &q);
    mpu.dmpGetYawPitchRoll(ypr, &q, &gravity);
    Serial.print("ypr\t");
    Serial.print(ypr[0] * 180/M_PI);
    Serial.print("\t");
    Serial.print(ypr[1] * 180/M_PI);
    Serial.print("\t");
    Serial.print(ypr[2] * 180/M_PI);
    Serial.print("\t");
    Serial.print("angular velocity is");
    Serial.println(gyro);

    // check if angular velocity is above our threshold
    if(gyro > 10)
    {
      serialPackage.streakActive = 1;
    }
    else
    {
      serialPackage.streakActive = 0;
    }
    // do the rest of our sending
    serialPackage.pitch = (ypr[1] * 180/M_PI);
    serialPackage.yaw = (ypr[0] * 180/M_PI);

    // and send!
    PLSwork.sendData();
 
}

