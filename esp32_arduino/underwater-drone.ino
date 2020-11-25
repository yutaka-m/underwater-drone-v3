#include<Wire.h>
#include "ICM20948.h"

// Serial input example
// X0,0,0,0,0,0,2733
// X1,0,110,120,130,140,2733
// X0,0,-110,-120,-130,-150,2733

// an ICM20948 object with the ICM-20948 sensor on I2C bus 0 with address 0x69
ICM20948 IMU(Wire, 0x68);
int status;

const int MIDDLE_LEVEL = 4800;

#define paramsLen 20
long params[paramsLen];

float xAccl = 0.00;
float yAccl = 0.00;
float zAccl = 0.00;
float xGyro = 0.00;
float yGyro = 0.00;
float zGyro = 0.00;
float xMag  = 0;
float yMag  = 0;
float zMag  = 0;
float tempIMU = 0;


int a1BlmotorValue = 0;
int a2BlmotorValue = 0;
int b1BlmotorValue = 0;
int b2BlmotorValue = 0;

// Pin assign
const int powerMon  = 34;
const int waterMon  = 35;
const int led       = 5;

// TODO dup delete
const int pwmPin0 = A4; //A4 IO32
const int pwmPin1 = A18; //A18 IO25
const int pwmPin2 = A5;  //A5 IO33
const int pwmPin3 = A13;  //A13 IO15

//Serial
const int rxPin     = 14;
const int txPin     = 17;

void setup()
{
  Wire.begin();
  Serial.begin(115200);
  Serial1.begin(115200,SERIAL_8N1, rxPin, txPin);

  Serial.print("Setup...");
  initIMU();
  delay(300);
  pinMode(powerMon, INPUT);
  pinMode(waterMon, INPUT);
  pinMode(led, OUTPUT);
  
  int pwmf = 50;
  ledcSetup(0, pwmf, 16);
  ledcAttachPin(pwmPin0, 0);
  ledcSetup(1, pwmf, 16);
  ledcAttachPin(pwmPin1, 1);
  ledcSetup(2, pwmf, 16);
  ledcAttachPin(pwmPin2, 2);
  ledcSetup(3, pwmf, 16);
  ledcAttachPin(pwmPin3, 3);

  // start blheli_s
  ledcWrite(0, MIDDLE_LEVEL - 1500);
  ledcWrite(1, MIDDLE_LEVEL - 1500);
  ledcWrite(2, MIDDLE_LEVEL - 1500);
  ledcWrite(3, MIDDLE_LEVEL - 1500);
  delay(2000);
  Serial.println(".end");
}

void initIMU() {
  status = -1;
  int timeoutCount = 10;
  int count = 0;
  while(status < 0) {
    status = IMU.begin();
    Serial.print("status = ");
    Serial.println(status);
    if (status < 0) {
      Serial.println("IMU initialization unsuccessful");
      Serial.println("Check IMU wiring or try cycling power");
      Serial.print("Status: ");
      Serial.println(status);
      sleep(2);
    }
    if (count > timeoutCount) {
      Serial.println("IMU Timeout.");     
      break;
    }
    count++;
  }
}

void readIMU() {
  IMU.readSensor();
  xAccl = IMU.getAccelX_mss();
  yAccl = IMU.getAccelY_mss();
  zAccl = IMU.getAccelZ_mss();
  xGyro = IMU.getGyroX_rads();
  yGyro = IMU.getGyroY_rads();
  zGyro = IMU.getGyroZ_rads();
  xMag = IMU.getMagX_uT();
  yMag = IMU.getMagY_uT();
  zMag = IMU.getMagZ_uT();
  tempIMU = IMU.getTemperature_C();  
}

void printIMU() {
  Serial1.print(xAccl);
  Serial1.print(",");
  Serial1.print(yAccl);
  Serial1.print(",");
  Serial1.print(zAccl);
  Serial1.print(","); 

  Serial1.print(xGyro);
  Serial1.print(",");
  Serial1.print(yGyro);
  Serial1.print(",");
  Serial1.print(zGyro);
  Serial1.print(","); 

  Serial1.print(xMag);
  Serial1.print(",");
  Serial1.print(yMag);
  Serial1.print(",");
  Serial1.print(zMag);
  Serial1.print(",");
  
  Serial1.print(tempIMU);
  Serial1.println("");
}

int power = 0;
int water = 0;
int ledStatus = LOW;
int modeStatus = 0;

void loop()
{
  Serial.print(".");
  getParam();
  
  setMonitor();
  printMonitor();

  setMotor();
  printMotor();
  
  readIMU();
  printIMU();
}

int split(String source, char delimiter, long* result) {
  int i=0;
  int num=0;
  int delim=0;
  while (source.length() > i) {
    if (num >= paramsLen) {break;}
    delim = source.indexOf(delimiter, i);
    if (delim == -1) {
      params[num++] = source.substring(i, source.length()).toInt();
      i = source.length();
    } else {
      params[num++] = source.substring(i, delim).toInt();
      i = delim + 1;
    }
  }
  return num;
}

String buffer = "";
int incomingByte = 0;
int scanParam = 0;
int startParam = 0;
// X0,0,0,0,0,0,2733
// X1,0,110,120,130,140,2733
// X0,0,-110,-120,-130,-150,2733
void getParam() {
  while (Serial.available() > 0) {
    incomingByte = Serial.read();
    if ((isDigit(incomingByte) || incomingByte == ',' || incomingByte == 'X' || incomingByte == '-') && startParam == 1) {
      buffer += (char)incomingByte;
    } else if (incomingByte == 'X') {
      startParam = 1;
    } else if (incomingByte == '\n') {
      scanParam = 1;
      startParam = 0;
    } else {
      buffer = "";
      startParam = 0;
    }
  }
  
  while (Serial1.available() > 0) {
    
    Serial.print(":");
    incomingByte = Serial1.read();
    if ((isDigit(incomingByte) || incomingByte == ',' || incomingByte == 'X' || incomingByte == '-') && startParam == 1) {
      buffer += (char)incomingByte;
    } else if (incomingByte == 'X') {
      startParam = 1;
    } else if (incomingByte == '\n') {
      scanParam = 1;
      startParam = 0;
    } else {
      buffer = "";
      startParam = 0;
    }
  }
  
  if(scanParam == 1 && buffer.length() != 0) {
    Serial.println("");
    Serial.print("in:");
    Serial.print(buffer);
    scanParam = 0;
    int len = split(buffer, ',', params);
    if (len == 7 && params[6] == 2733) {
      ledStatus = constrain(params[0], 0, 1);
      modeStatus = constrain(params[1], 0, 1);
      a1BlmotorValue = constrain(params[2], -300, 300);
      a2BlmotorValue = constrain(params[3], -300, 300);
      b1BlmotorValue = constrain(params[4], -300, 300);
      b2BlmotorValue = constrain(params[5], -300, 300);
    } else {
      Serial.print("D");
    }
    buffer = "";
  }
}

void setMonitor() {
  power = analogRead(powerMon);
  water = analogRead(waterMon);
  digitalWrite(led, ledStatus);
}

void printMonitor() {
  Serial1.print(power);
  Serial1.print(",");
  Serial1.print(water);
  Serial1.print(",");
  Serial1.print(ledStatus);
  Serial1.print(",");
  Serial1.print(modeStatus);
  Serial1.print(",");
}

void setMotor() {
  //PWM
  ledcWrite(0, MIDDLE_LEVEL + a1BlmotorValue);
  ledcWrite(1, MIDDLE_LEVEL + a2BlmotorValue);
  ledcWrite(2, MIDDLE_LEVEL + b1BlmotorValue);
  ledcWrite(3, MIDDLE_LEVEL + b2BlmotorValue);
}

void printMotor()
{
  Serial1.print(a1BlmotorValue);
  Serial1.print(",");
  Serial1.print(a2BlmotorValue);
  Serial1.print(",");
  Serial1.print(b1BlmotorValue);
  Serial1.print(",");
  Serial1.print(b2BlmotorValue);
  Serial1.print(",");
}

