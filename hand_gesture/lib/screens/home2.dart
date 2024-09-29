import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:hand_gesture/screens/home_connected.dart';

class Home2 extends StatefulWidget {
  const Home2({super.key});

  @override
  State<Home2> createState() => _HomeState();
}

class _HomeState extends State<Home2> {
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? connection;
  BluetoothDevice? targetDevice;
  bool isConnected = false;
  String receivedData = "";

  final StreamController<String> _signedLetterController =
      StreamController<String>();

  @override
  void initState() {
    super.initState();
    enableBluetooth();
  }

  @override
  void dispose() {
    connection?.dispose();
    _signedLetterController.close();
    super.dispose();
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
    for (BluetoothDevice device in devices) {
      if (device.name == "HC-05") {
        // Ensure you pair with the right device
        print("connected");
        setState(() {
          targetDevice = device;
        });
        break;
      }
    }

    if (targetDevice != null) {
      // After connection is established, navigate to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomeConnected(
                  bluetoothDevice: targetDevice,
                )),
      );
    }
  }

  // Function to parse received data and send to backend

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40.0,
          vertical: 10.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Connect Your Device",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/hardware.jpg',
                width: 500,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                ),
              ),
              onPressed: () {
                connectToBluetooth(); // Initiate connection
              },
              child: const Text("Connect"),
            ),
          ],
        ),
      ),
    );
  }
}
