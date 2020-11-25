#include<Wire.h>

// BMX055　加速度センサのI2Cアドレス  
#define Addr_Accl 0x19
// BMX055　ジャイロセンサのI2Cアドレス
#define Addr_Gyro 0x69
// BMX055　磁気センサのI2Cアドレス
#define Addr_Mag 0x13

#define paramsLen 20
long params[paramsLen];

float xAccl = 0.00;
float yAccl = 0.00;
float zAccl = 0.00;
float xGyro = 0.00;
float yGyro = 0.00;
float zGyro = 0.00;
int   xMag  = 0;
int   yMag  = 0;
int   zMag  = 0;

// Pin assign
const int powerMon  = 34;
const int waterMon  = 36;
const int led       = 5;

// TODO dup delete
const int pwmPin0 = A18;
const int pwmPin1 = A4;
const int pwmPin2 = A19; 
const int pwmPin3 = A5; 

const int md_x8     = 25; //PWMA A18
const int md_x7     = 23; //AIN2
const int md_x6     = 27; //AIN2
//const int md_x4     = 0; //STBY desabled 14
const int md_x3     = 12; //BIN1
const int md_x2     = 13; //BIN2
const int md_x1     = 32; //PWMB A4
const int md_y8     = 26; //PWMA A19
const int md_y7     = 19; //AIN2
const int md_y6     = 18; //AIN1
//const int md_y4     = 0; //STBY desabled 17
const int md_y3     = 16; //BIN1
const int md_y2     = 4;  //BIN2
const int md_y1     = 33; //PWMB A5

//Serial
const int rxPin     = 14;
const int txPin     = 17;

void setup()
{
  Wire.begin();
  Serial.begin(115200);
  Serial1.begin(115200,SERIAL_8N1, rxPin, txPin);

  Serial.print("Setup...");
  initBMX055();
  delay(300);
  pinMode(powerMon, INPUT);
  pinMode(waterMon, INPUT);
  pinMode(led, OUTPUT);
  pinMode(md_x8, OUTPUT);
  pinMode(md_x7, OUTPUT);
  pinMode(md_x6, OUTPUT);
//  pinMode(md_x4, OUTPUT);
  pinMode(md_x3, OUTPUT);
  pinMode(md_x2, OUTPUT);
  pinMode(md_x1, OUTPUT);
  pinMode(md_y8, OUTPUT);
  pinMode(md_y7, OUTPUT);
  pinMode(md_y6, OUTPUT);
//  pinMode(md_y4, OUTPUT);
  pinMode(md_y3, OUTPUT);
  pinMode(md_y2, OUTPUT);
  pinMode(md_y1, OUTPUT);

  int pwmf = 1000000;
  ledcSetup(0, pwmf, 8);
  ledcAttachPin(pwmPin0, 0);
  ledcSetup(1, pwmf, 8);
  ledcAttachPin(pwmPin1, 1);
  ledcSetup(2, pwmf, 8);
  ledcAttachPin(pwmPin2, 2);
  ledcSetup(3, pwmf, 8);
  ledcAttachPin(pwmPin3, 3);
  Serial.println(".end");
}


void readBMX055() {
  //BMX055 加速度の読み取り
  BMX055_Accl();
  //BMX055 ジャイロの読み取り
  BMX055_Gyro();
  //BMX055 磁気の読み取り
  BMX055_Mag();
}

void printBMX055() {
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
  Serial1.println("");
}

int power = 0;
int water = 0;
int led_status = LOW;
int mode_status = 0;

int md_x8_value = 0; //PWMA
int md_x7_value = LOW; //AIN2
int md_x6_value = LOW; //AIN1
//int md_x4_value = LOW; //STBY
int md_x3_value = LOW; //BIN1
int md_x2_value = LOW; //BIN2
int md_x1_value = 0; //PWMB
int md_y8_value = 0; //PWMA
int md_y7_value = LOW; //AIN2
int md_y6_value = LOW; //AIN1
//int md_y4_value = LOW; //STBY
int md_y3_value = LOW; //BIN1
int md_y2_value = LOW; //BIN2
int md_y1_value = 0; //PWMB

void loop()
{
  Serial.print(".");
  getParam();
  
  setMonitor();
  printMonitor();

  setMotor();
  printMotor();
  
  readBMX055();
  printBMX055();
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
// X0,0,0,0,0,0,0,0,0,0,0,0,0,0,2733
// X1,0,0,0,0,0,0,0,0,0,0,0,0,0,2733
// X1,0,1,1,0,0,0,0,0,0,0,0,0,0,2733
// X1,0,1,0,1,0,0,0,0,0,0,0,0,0,2733
// X1,0,0,0,0,1,0,1,0,0,0,0,0,0,2733
// X1,0,0,0,0,0,1,1,0,0,0,0,0,0,2733
// X1,0,0,0,0,0,0,0,1,1,0,0,0,0,2733
// X1,0,0,0,0,0,0,0,1,0,1,0,0,0,2733
// X1,0,0,0,0,0,0,0,0,0,0,1,0,1,2733
// X1,0,0,0,0,0,0,0,0,0,0,0,1,1,2733
// X1,0,100,1,0,1,0,100,100,0,1,0,1,100,2733
// X0,0,0,0,1,0,1,0,0,0,1,0,1,0,2733
void getParam() {
  while (Serial.available() > 0) {
    incomingByte = Serial.read();
    if ((isDigit(incomingByte) || incomingByte == ',' || incomingByte == 'X') && startParam == 1) {
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
    incomingByte = Serial1.read();
    if ((isDigit(incomingByte) || incomingByte == ',' || incomingByte == 'X') && startParam == 1) {
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
    if (len == 15 && params[14] == 2733) {
      led_status = constrain(params[0], 0, 1);
      mode_status = constrain(params[1], 0, 1);
      md_x8_value = constrain(params[2], 0, 255);
      md_x7_value = constrain(params[3], 0, 1);
      md_x6_value = constrain(params[4], 0, 1);
      md_x3_value = constrain(params[5], 0, 1);
      md_x2_value = constrain(params[6], 0, 1);
      md_x1_value = constrain(params[7], 0, 255);
      md_y8_value = constrain(params[8], 0, 255);
      md_y7_value = constrain(params[9], 0, 1);
      md_y6_value = constrain(params[10], 0, 1);
      md_y3_value = constrain(params[11], 0, 1);
      md_y2_value = constrain(params[12], 0, 1);
      md_y1_value = constrain(params[13], 0, 255);
    } else {
      Serial.print("D");
    }
    buffer = "";
  }
}

void setMonitor() {
  power = analogRead(powerMon);
  water = analogRead(waterMon);
  digitalWrite(led, led_status);
}

void printMonitor() {
  Serial1.print(power);
  Serial1.print(",");
  Serial1.print(water);
  Serial1.print(",");
  Serial1.print(led_status);
  Serial1.print(",");
  Serial1.print(mode_status);
  Serial1.print(",");
}

void setMotor() {
  //PWM
  ledcWrite(0, md_x8_value);
  ledcWrite(1, md_x1_value);
  ledcWrite(2, md_y8_value);
  ledcWrite(3, md_y1_value);

  //DIGITAL
  //digitalWrite(md_x8, md_x8_value); //PWMA
  digitalWrite(md_x7, md_x7_value); //AIN2
  digitalWrite(md_x6, md_x6_value); //AIN1
  //digitalWrite(md_x4, md_x4_value); //STBY
  digitalWrite(md_x3, md_x3_value); //BIN1
  digitalWrite(md_x2, md_x2_value); //BIN2
  //digitalWrite(md_x1, md_x1_value); //PWMB
  
  //digitalWrite(md_y8, md_y8_value); //PWMA
  digitalWrite(md_y7, md_y7_value); //AIN2
  digitalWrite(md_y6, md_y6_value); //AIN1
  //digitalWrite(md_y4, md_y4_value); //STBY
  digitalWrite(md_y3, md_y3_value); //BIN1
  digitalWrite(md_y2, md_y2_value); //BIN2
  //digitalWrite(md_y1, md_y1_value); //PWMB
}

void printMotor()
{
  Serial1.print(md_x8_value);
  Serial1.print(",");
  Serial1.print(md_x7_value);
  Serial1.print(",");
  Serial1.print(md_x6_value);
  Serial1.print(",");
  //Serial1.print(md_x4_value);
  //Serial1.print(",");
  Serial1.print(md_x3_value);
  Serial1.print(",");
  Serial1.print(md_x2_value);
  Serial1.print(",");
  Serial1.print(md_x1_value);
  Serial1.print(",");
  Serial1.print(md_y8_value);
  Serial1.print(",");
  Serial1.print(md_y7_value);
  Serial1.print(",");
  Serial1.print(md_y6_value);
  Serial1.print(",");
  //Serial1.print(md_y4_value);
  //Serial1.print(",");
  Serial1.print(md_y3_value);
  Serial1.print(",");
  Serial1.print(md_y2_value);
  Serial1.print(",");
  Serial1.print(md_y1_value);
  Serial1.print(",");
}

void initBMX055() {
  Wire.beginTransmission(Addr_Accl);
  Wire.write(0x0F); // Select PMU_Range register
  Wire.write(0x03);   // Range = +/- 2g
  Wire.endTransmission();
  delay(100);
  Wire.beginTransmission(Addr_Accl);
  Wire.write(0x10);  // Select PMU_BW register
  Wire.write(0x08);  // Bandwidth = 7.81 Hz
  Wire.endTransmission();
  delay(100);
  Wire.beginTransmission(Addr_Accl);
  Wire.write(0x11);  // Select PMU_LPW register
  Wire.write(0x00);  // Normal mode, Sleep duration = 0.5ms
  Wire.endTransmission();
  delay(100);
  Wire.beginTransmission(Addr_Gyro);
  Wire.write(0x0F);  // Select Range register
  Wire.write(0x04);  // Full scale = +/- 125 degree/s
  Wire.endTransmission();
  delay(100);
  Wire.beginTransmission(Addr_Gyro);
  Wire.write(0x10);  // Select Bandwidth register
  Wire.write(0x07);  // ODR = 100 Hz
  Wire.endTransmission();
  delay(100);
  Wire.beginTransmission(Addr_Gyro);
  Wire.write(0x11);  // Select LPM1 register
  Wire.write(0x00);  // Normal mode, Sleep duration = 2ms
  Wire.endTransmission();
  delay(100);
  Wire.beginTransmission(Addr_Mag);
  Wire.write(0x4B);  // Select Mag register
  Wire.write(0x83);  // Soft reset
  Wire.endTransmission();
  delay(100);
  Wire.beginTransmission(Addr_Mag);
  Wire.write(0x4B);  // Select Mag register
  Wire.write(0x01);  // Soft reset
  Wire.endTransmission();
  delay(100);
  Wire.beginTransmission(Addr_Mag);
  Wire.write(0x4C);  // Select Mag register
  Wire.write(0x00);  // Normal Mode, ODR = 10 Hz
  Wire.endTransmission();
  Wire.beginTransmission(Addr_Mag);
  Wire.write(0x4E);  // Select Mag register
  Wire.write(0x84);  // X, Y, Z-Axis enabled
  Wire.endTransmission();
  Wire.beginTransmission(Addr_Mag);
  Wire.write(0x51);  // Select Mag register
  Wire.write(0x04);  // No. of Repetitions for X-Y Axis = 9
  Wire.endTransmission();
  Wire.beginTransmission(Addr_Mag);
  Wire.write(0x52);  // Select Mag register
  Wire.write(0x16);  // No. of Repetitions for Z-Axis = 15
  Wire.endTransmission();
}

void BMX055_Accl(){
  int data[6];
  for (int i = 0; i < 6; i++)
  {
    Wire.beginTransmission(Addr_Accl);
    Wire.write((2 + i));// Select data register
    Wire.endTransmission();
    Wire.requestFrom(Addr_Accl, 1);// Request 1 byte of data
    // Read 6 bytes of data
    // xAccl lsb, xAccl msb, yAccl lsb, yAccl msb, zAccl lsb, zAccl msb
    if (Wire.available() == 1)
      data[i] = Wire.read();
  }
  // Convert the data to 12-bits
  xAccl = ((data[1] * 256) + (data[0] & 0xF0)) / 16;
  if (xAccl > 2047)  xAccl -= 4096;
  yAccl = ((data[3] * 256) + (data[2] & 0xF0)) / 16;
  if (yAccl > 2047)  yAccl -= 4096;
  zAccl = ((data[5] * 256) + (data[4] & 0xF0)) / 16;
  if (zAccl > 2047)  zAccl -= 4096;
  xAccl = xAccl * 0.0098; // renge +-2g
  yAccl = yAccl * 0.0098; // renge +-2g
  zAccl = zAccl * 0.0098; // renge +-2g
}

void BMX055_Gyro()
{
  int data[6];
  for (int i = 0; i < 6; i++)
  {
    Wire.beginTransmission(Addr_Gyro);
    Wire.write((2 + i));    // Select data register
    Wire.endTransmission();
    Wire.requestFrom(Addr_Gyro, 1);    // Request 1 byte of data
    // Read 6 bytes of data
    // xGyro lsb, xGyro msb, yGyro lsb, yGyro msb, zGyro lsb, zGyro msb
    if (Wire.available() == 1)
      data[i] = Wire.read();
  }
  // Convert the data
  xGyro = (data[1] * 256) + data[0];
  if (xGyro > 32767)  xGyro -= 65536;
  yGyro = (data[3] * 256) + data[2];
  if (yGyro > 32767)  yGyro -= 65536;
  zGyro = (data[5] * 256) + data[4];
  if (zGyro > 32767)  zGyro -= 65536;

  xGyro = xGyro * 0.0038; //  Full scale = +/- 125 degree/s
  yGyro = yGyro * 0.0038; //  Full scale = +/- 125 degree/s
  zGyro = zGyro * 0.0038; //  Full scale = +/- 125 degree/s
}

void BMX055_Mag()
{
  int data[8];
  for (int i = 0; i < 8; i++)
  {
    Wire.beginTransmission(Addr_Mag);
    Wire.write((0x42 + i));    // Select data register
    Wire.endTransmission();
    Wire.requestFrom(Addr_Mag, 1);    // Request 1 byte of data
    // Read 6 bytes of data
    // xMag lsb, xMag msb, yMag lsb, yMag msb, zMag lsb, zMag msb
    if (Wire.available() == 1)
      data[i] = Wire.read();
  }
  // Convert the data
  xMag = ((data[1] <<8) | (data[0]>>3));
  if (xMag > 4095)  xMag -= 8192;
  yMag = ((data[3] <<8) | (data[2]>>3));
  if (yMag > 4095)  yMag -= 8192;
  zMag = ((data[5] <<8) | (data[4]>>3));
  if (zMag > 16383)  zMag -= 32768;
}
