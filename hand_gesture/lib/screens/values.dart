import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Values extends StatefulWidget {
  const Values({Key? key}) : super(key: key);

  @override
  State<Values> createState() => _ValuesState();
}

class _ValuesState extends State<Values> {
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? connection;
  bool isConnected = false;

  // Variables to store parsed data
  String ax = "", ay = "", az = "";
  String f1 = "", f2 = "", f3 = "", f4 = "", f5 = "";
  String buffer = ""; // Buffer to store incoming data chunks

  @override
  void initState() {
    super.initState();
    enableBluetooth();
  }

  // Enable Bluetooth on the device
  void enableBluetooth() async {
    bool? isEnabled = await _bluetooth.isEnabled;
    if (!isEnabled!) {
      await _bluetooth.requestEnable();
    }
  }

  // Connect to the HC-05 Bluetooth device
  void connectToBluetooth() async {
    List<BluetoothDevice> devices = await _bluetooth.getBondedDevices();
    BluetoothDevice? targetDevice;

    for (BluetoothDevice device in devices) {
      if (device.name == "HC-05") {
        targetDevice = device;
        break;
      }
    }

    if (targetDevice != null) {
      try {
        BluetoothConnection newConnection =
            await BluetoothConnection.toAddress(targetDevice.address);
        setState(() {
          connection = newConnection;
          isConnected = true;
          print('Connected to ${targetDevice?.name}');
        });

        // Listen for incoming data
        connection!.input!.listen((Uint8List data) {
          String incomingData = String.fromCharCodes(data);
          buffer += incomingData; // Add incoming data to the buffer

          if (buffer.contains('\n')) {
            // Split the buffer into lines by the newline
            List<String> lines = buffer.split('\n');
            for (int i = 0; i < lines.length - 1; i++) {
              _preprocessAndParseData(lines[i].trim());
            }
            // Save the last incomplete line back into the buffer
            buffer = lines.last;
          }
        }).onDone(() {
          setState(() {
            isConnected = false;
            print('Connection closed by remote device.');
          });
        });
      } catch (error) {
        print('Error connecting to device: $error');
        setState(() {
          isConnected = false; // Connection failed
        });
      }
    } else {
      print('No HC-05 device found.');
    }
  }

  // Preprocess the incoming data and extract values
  void _preprocessAndParseData(String data) {
    // Clean the data and split by the separator '|' and '='
    List<String> parts = data.split('|');

    if (parts.length == 8) {
      setState(() {
        // Extract each value by splitting the key-value pair
        ax = _extractValue(parts[0], 'aX');
        ay = _extractValue(parts[1], 'aY');
        az = _extractValue(parts[2], 'aZ');
        f1 = _extractValue(parts[3], 'F1');
        f2 = _extractValue(parts[4], 'F2');
        f3 = _extractValue(parts[5], 'F3');
        f4 = _extractValue(parts[6], 'F4');
        f5 = _extractValue(parts[7], 'F5');
      });
    } else {
      print("Unexpected data format: $data");
    }
  }

  // Helper function to extract the numeric value from key-value pair
  String _extractValue(String part, String key) {
    List<String> keyValue = part.split('=');
    if (keyValue.length == 2 && keyValue[0].trim() == key) {
      return keyValue[1].trim();
    }
    return "-";
  }

  // Disconnect from Bluetooth
  void disconnectFromBluetooth() async {
    if (connection != null && isConnected) {
      await connection!.close();
      setState(() {
        isConnected = false;
        print("Disconnected from HC-05.");
      });
    }
  }

  @override
  void dispose() {
    if (isConnected) {
      connection?.dispose();
      connection = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Serial Monitor'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Sensor Data",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildDataDisplay("aX", ax),
                _buildDataDisplay("aY", ay),
                _buildDataDisplay("aZ", az),
                _buildDataDisplay("F1", f1),
                _buildDataDisplay("F2", f2),
                _buildDataDisplay("F3", f3),
                _buildDataDisplay("F4", f4),
                _buildDataDisplay("F5", f5),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: isConnected ? null : connectToBluetooth,
                      child:
                          Text(isConnected ? "Connected" : "Connect to HC-05"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: isConnected ? disconnectFromBluetooth : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text("Stop"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget to display data in a box
  Widget _buildDataDisplay(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label:",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              value.isEmpty ? "-" : value,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
