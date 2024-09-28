import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothSerialMonitor extends StatefulWidget {
  const BluetoothSerialMonitor({Key? key}) : super(key: key);

  @override
  State<BluetoothSerialMonitor> createState() => _BluetoothSerialMonitorState();
}

class _BluetoothSerialMonitorState extends State<BluetoothSerialMonitor> {
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? connection;
  bool isConnected = false;
  List<String> serialLog = [];
  final ScrollController _scrollController = ScrollController();

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
        BluetoothConnection newConnection = await BluetoothConnection.toAddress(targetDevice.address);
        setState(() {
          connection = newConnection;
          isConnected = true;
          print('Connected to ${targetDevice?.name}');
        });

        // Listen for incoming data
        connection!.input!.listen((Uint8List data) {
          setState(() {
            String newData = String.fromCharCodes(data);
            serialLog.add(newData);
            _scrollToBottom(); // Scroll down when new data is added
          });
        }).onDone(() {
          setState(() {
            isConnected = false;
            serialLog.add("Connection closed by remote device.");
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

  // Scroll to the bottom of the ListView
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Disconnect from Bluetooth
  void disconnectFromBluetooth() async {
    if (connection != null && isConnected) {
      try {
        await connection!.close();
        connection = null;
        setState(() {
          isConnected = false;
          serialLog.add("Disconnected from HC-05.");
        });
        print("Disconnected from HC-05.");
      } catch (error) {
        print("Error disconnecting: $error");
      }
    }
  }

  @override
  void dispose() {
    if (isConnected) {
      connection?.dispose();
      connection = null;
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Serial Monitor'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Serial Monitor",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              isConnected
                  ? Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: serialLog.length,
                          itemBuilder: (context, index) {
                            return Text(
                              serialLog[index],
                              style: const TextStyle(fontSize: 16),
                            );
                          },
                        ),
                      ),
                    )
                  : const Text(
                      "Not connected to any Bluetooth device.",
                      style: TextStyle(fontSize: 18),
                    ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: isConnected ? null : connectToBluetooth,
                    child: Text(isConnected ? "Connected" : "Connect to HC-05"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: isConnected ? disconnectFromBluetooth : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Stop button color
                    ),
                    child: const Text("Stop"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
