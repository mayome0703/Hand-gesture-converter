#include <Wire.h>
#include <MPU6050.h>
#include <SoftwareSerial.h>

MPU6050 mpu;
SoftwareSerial Bluetooth(10, 11); // RX, TX

void setup() {
  Serial.begin(9600); // Initialize serial communication for USB
  //Bluetooth.begin(9600); // Initialize serial communication for HC-06
  Wire.begin();
  mpu.initialize();
  
  if (mpu.testConnection()) {
    Serial.println("MPU6050 connection successful");
    //Bluetooth.println("MPU6050 connection successful"); // Send confirmation to Bluetooth
  } else {
    Serial.println("MPU6050 connection failed");
    //Bluetooth.println("MPU6050 connection failed"); // Send failure message to Bluetooth
  }
}

void loop() {
  int16_t ax, ay, az;
  mpu.getAcceleration(&ax, &ay, &az);

  Serial.print("aX = "); Serial.print(ax);
  Serial.print(" | aY = "); Serial.print(ay);
  Serial.print(" | aZ = "); Serial.println(az);

  // Send the data to the HC-06 Bluetooth module
  // Bluetooth.print("aX = "); Bluetooth.print(ax);
  // Bluetooth.print(" | aY = "); Bluetooth.print(ay);
  // Bluetooth.print(" | aZ = "); Bluetooth.println(az);

  delay(100);
}
