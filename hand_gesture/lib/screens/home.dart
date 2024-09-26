import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hand_gesture/screens/after_connect_home_nav.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? connection;
  bool isConnected = false;
  String receivedData = "";

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

  void connectToBluetooth() async {
    List<BluetoothDevice> devices = await _bluetooth.getBondedDevices();
    BluetoothDevice? targetDevice;

    for (BluetoothDevice device in devices) {
      if (device.name == "HC-05") {
        // Ensure you pair with the right device
        targetDevice = device;
        break;
      }
    }

    if (targetDevice != null) {
      await BluetoothConnection.toAddress(targetDevice.address)
          .then((_connection) {
        connection = _connection;
        isConnected = true;

        connection!.input!.listen((Uint8List data) {
          setState(() {
            receivedData = String.fromCharCodes(data);
          });
        }).onDone(() {
          isConnected = false;
        });
      }).catchError((error) {
        print('Error: $error');
      });
    }
  }

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
                connectToBluetooth();
                if (isConnected) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AfterConnectHomeNav(),
                    ),
                  );
                }
              },
              child: const Text("Connect"),
            ),
          ],
        ),
      ),
    );
  }
}
