#include <Wire.h>
#include <MPU6050.h>
#include <SoftwareSerial.h>

MPU6050 mpu;
SoftwareSerial Bluetooth(10, 11); // RX, TX

const float flexPin1 = A0, flexPin2 = A1, flexPin3 = A2, flexPin4 = A3, flexPin5 = A6; // flex sensor analog pins
const float VCC = 5, R_DIV = 10000.0;
const float flatR1 = 38000.0, flatR2 = 26800.0, flatR3 = 32600.0, flatR4 = 21600.0, flatR5 = 30000.0; // resistance when flat
const float bendR1 = 100000.0, bendR2 = 56200.0, bendR3 = 69300.0, bendR4 = 44200.0, bendR5 = 72000.0; // resistance when bend

void PrintResult(int16_t ax=0, int16_t ay=0, int16_t az=0, float F1=0, float F2=0, float F3=0, float F4=0, float F5=0){
  
  // Serial.print(String(-10));
  // Serial.print("aX = "); Serial.print(ax);
  // Serial.print(" | aY = "); Serial.print(ay);
  // Serial.print(" | aZ = "); Serial.print(az);
  // Serial.print(" | F1 = "); Serial.print(String(F1));
  // Serial.print(" | F2 = "); Serial.print(String(F2));
  // Serial.print(" | F3 = "); Serial.print(String(F3));
  // Serial.print(" | F4 = "); Serial.print(String(F4));
  // Serial.print(" | F5 = "); Serial.print(String(F5));
  // Serial.print(" | "+ String(100));
  // Serial.print("\n");

  // Send the data to the HC-05 Bluetooth module
  
  Bluetooth.print("aX = "); Bluetooth.print(ax);
  Bluetooth.print(" | aY = "); Bluetooth.print(ay);
  Bluetooth.print(" | aZ = "); Bluetooth.print(az);
  Bluetooth.print(" | F1 = "); Bluetooth.print(String(F1));
  Bluetooth.print(" | F2 = "); Bluetooth.print(String(F2));
  Bluetooth.print(" | F3 = "); Bluetooth.print(String(F3));
  Bluetooth.print(" | F4 = "); Bluetooth.print(String(F4));
  Bluetooth.print(" | F5 = "); Bluetooth.print(String(F5));
  Bluetooth.print("\n");

}

float FlexAngle(float flexPin, float flatR, float bendR) {
  // Read the ADC, and calculate voltage and resistance from it
  float ADCflex = analogRead(flexPin);
	float Vflex = ADCflex * VCC / 1023.0;
	float Rflex = R_DIV * (VCC / Vflex - 1.0);
	//Serial.println("Resistance: " + String(Rflex) + " ohms");
  //Serial.print(Rflex);

	// Use the calculated resistance to estimate the sensor's bend angle:
	float angle = map(Rflex, flatR, bendR, 0, 90.0);
  return angle;
}


void setup() {
  // Serial.begin(9600); // Initialize serial communication for USB
  Bluetooth.begin(9600); // Initialize serial communication for HC-06
  Wire.begin();
  mpu.initialize();
  pinMode(flexPin1, INPUT);
  // pinMode(flexPin2, INPUT);
  // pinMode(flexPin3, INPUT);
  // pinMode(flexPin4, INPUT);
  // pinMode(flexPin5, INPUT);
  
  if (mpu.testConnection()) {
    // Serial.println("MPU6050 connection successful");
    Bluetooth.println("Bluetooth connection successful"); // Send confirmation to Bluetooth
  } else {
    // Serial.println("MPU6050 connection failed");
    Bluetooth.println("Bluetooth connection failed"); // Send failure message to Bluetooth
  }
}

void loop() {
  int16_t ax, ay, az;
  mpu.getAcceleration(&ax, &ay, &az);
  float F1= FlexAngle(flexPin1, flatR1, bendR1);
  float F2= FlexAngle(flexPin2, flatR2, bendR2);
  float F3= FlexAngle(flexPin3, flatR3, bendR3);
  float F4= FlexAngle(flexPin4, flatR4, bendR4);
  float F5= FlexAngle(flexPin5, flatR5, bendR5);

  PrintResult(ax, ay, ax, F1, F2, F3, F4, F5);

  delay(2000);
}
