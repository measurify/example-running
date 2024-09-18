#include <Arduino_BMI270_BMM150.h>  //#include <Arduino_LSM9DS1.h>
#include <ArduinoBLE.h>
#include "model.h"
#include <TensorFlowLite.h>
#include <tensorflow/lite/micro/all_ops_resolver.h>
#include "tensorflow/lite/micro/micro_log.h"
#include <tensorflow/lite/micro/micro_interpreter.h>
#include <tensorflow/lite/schema/schema_generated.h>

// Constants
#define ACC_MULTIPLIER 8192
#define GYR_MULTIPLIER 16.384
constexpr int kTensorArenaSize = 20 * 1024;

// Globals
tflite::AllOpsResolver tflResolver;
const tflite::Model* tflModel = nullptr;
tflite::MicroInterpreter* tflInterpreter = nullptr;
TfLiteTensor* tflInputTensor = nullptr;
TfLiteTensor* tflOutputTensor = nullptr;
alignas(8) uint8_t tensor_arena[kTensorArenaSize];

BLEService service("8e7c2dae-0000-4b0d-b516-f525649c49ca");
BLECharacteristic tiredCharacteristic("8e7c2dae-0001-4b0d-b516-f525649c49ca", BLENotify, sizeof(int16_t));

float acceleration[3];
float angular_speed[3];
int counter = 0;

void init_sensors() {
  if (!IMU.begin()) {
    Serial.println("IMU initialization failed");
    while (1)
      ;
  }
  Serial.println("IMU initialized successfully");
}

void init_BLE() {
  if (!BLE.begin()) {
    Serial.println("BLE initialization failed");
    while (1)
      ;
  }
  BLE.setLocalName("A");
  BLE.setDeviceName("A");
  BLE.setAdvertisedService(service);
  service.addCharacteristic(tiredCharacteristic);
  BLE.addService(service);
  BLE.advertise();
  Serial.println("BLE initialized and advertising");
}

void init_tflite() {
  tflModel = tflite::GetModel(model);
  if (tflModel->version() != TFLITE_SCHEMA_VERSION) {
    MicroPrintf("Model version mismatch");
    while (1)
      ;
  }

  static tflite::MicroInterpreter static_interpreter(tflModel, tflResolver, tensor_arena, kTensorArenaSize);
  tflInterpreter = &static_interpreter;

  if (tflInterpreter->AllocateTensors() != kTfLiteOk) {
    MicroPrintf("Tensor allocation failed");
    while (1)
      ;
  }

  tflInputTensor = tflInterpreter->input(0);
  tflOutputTensor = tflInterpreter->output(0);
  Serial.println("TensorFlow Lite initialized successfully");
}

void manageRawValues() {
  if (IMU.accelerationAvailable()) {
    float x, y, z;
    IMU.readAcceleration(x, y, z);
    acceleration[0] = x;
    acceleration[1] = y;
    acceleration[2] = z;
  }

  if (IMU.gyroscopeAvailable()) {
    float x, y, z;
    IMU.readGyroscope(x, y, z);
    angular_speed[0] = x;
    angular_speed[1] = y;
    angular_speed[2] = z;
  }
}

void setup() {
  Serial.begin(9600);
  Serial.println("Initializing sensors...");
  init_sensors();

  Serial.println("Initializing BLE...");
  init_BLE();

  Serial.println("Initializing TensorFlow Lite...");
  init_tflite();
}

void loop() {
  if (BLE.connected()) {

    while (counter < 80) {
      if (BLE.connected()) {
        manageRawValues();
        tflInputTensor->data.f[counter * 6 + 0] = acceleration[0];
        tflInputTensor->data.f[counter * 6 + 1] = acceleration[0];
        tflInputTensor->data.f[counter * 6 + 2] = acceleration[0];
        tflInputTensor->data.f[counter * 6 + 3] = angular_speed[0];
        tflInputTensor->data.f[counter * 6 + 4] = angular_speed[0];
        tflInputTensor->data.f[counter * 6 + 5] = angular_speed[0];
        counter++;
        delay(50);
      }
    }
    counter = 0;
    unsigned long startTime = micros();

    if (tflInterpreter->Invoke() != kTfLiteOk) {
      Serial.println("Inference failed");
      while (1)
        ;
    }

    unsigned long endTime = micros();
    unsigned long elapsedTime = endTime - startTime;

    Serial.print("Model output: ");
    Serial.println(tflOutputTensor->data.f[0], 6);
    Serial.println(tflOutputTensor->data.f[1], 6);
    if (tflOutputTensor->data.f[0] > 0.50) {
      Serial.println("Corsa Ottimale");
      tiredCharacteristic.writeValue((int16_t)0, sizeof(int16_t));
    }
    if (tflOutputTensor->data.f[1] > 0.50) {
      Serial.println("Corsa Affaticata");
      tiredCharacteristic.writeValue((int16_t)1, sizeof(int16_t));
    }

    Serial.print("Inference time: ");
    Serial.print(elapsedTime);
    Serial.println(" microseconds");
  }
}