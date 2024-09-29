import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hand_gesture/screens/after_connect_home_nav.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:hand_gesture/utils/api_sattings.dart';

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
        setState(() {
          isConnected = true; // Connection successful
        });

        // Listen for incoming data
        connection!.input!.listen((Uint8List data) async {
          String incomingData = String.fromCharCodes(data);
          // Append incoming data to receivedData
          setState(() {
            receivedData += incomingData;
            print('Received data: $receivedData');
          });

          // Check if a complete message is received (assuming '\n' as delimiter)
          if (receivedData.contains('\n')) {
            List<String> messages = receivedData.split('\n');
            for (var msg in messages) {
              if (msg.trim().isEmpty) continue;
              // Parse and send to backend
              await _processReceivedData(msg.trim());
            }
            // Reset receivedData
            receivedData = '';
          }
        }).onDone(() {
          setState(() {
            isConnected = false; // Connection closed
          });
        });

        // After connection is established, navigate to the next screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AfterConnectHomeNav(
              signedLetterStream: _signedLetterController.stream,
            ),
          ),
        );
      }).catchError((error) {
        print('Error: $error');
        setState(() {
          isConnected = false; // Connection failed
        });
      });
    } else {
      print('No HC-05 device found.');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Device Not Found"),
          content: const Text(
              "No HC-05 device found. Please pair the device and try again."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  // Function to parse received data and send to backend
  Future<void> _processReceivedData(String data) async {
    // Example data:
    // "aX = -2316 | aY = -340 | aZ = -2316 | F1 = 6.00 | F2 = 5.00 | F3 = 6.00 | F4 = 5.00 | F5 = 6.00"

    List<String> parts = data.split('|').map((e) => e.trim()).toList();

    Map<String, String> dataMap = {};
    for (var part in parts) {
      var keyValue = part.split('=').map((e) => e.trim()).toList();
      if (keyValue.length == 2) {
        dataMap[keyValue[0]] = keyValue[1];
      }
    }

    // Extract accelerometer data
    int? aX = int.tryParse(dataMap['aX'] ?? '');
    int? aY = int.tryParse(dataMap['aY'] ?? '');
    int? aZ = int.tryParse(dataMap['aZ'] ?? '');

    // Extract flex sensor data
    // Assuming F1 to F5 correspond to flex_sensors indices 0 to 4
    double? f1 = double.tryParse(dataMap['F1'] ?? '');
    double? f2 = double.tryParse(dataMap['F2'] ?? '');
    double? f3 = double.tryParse(dataMap['F3'] ?? '');
    double? f4 = double.tryParse(dataMap['F4'] ?? '');
    double? f5 = double.tryParse(dataMap['F5'] ?? '');

    List<int> accelerometers = [];
    List<int> flexSensors = [];

    if (aX != null && aY != null && aZ != null) {
      accelerometers = [aX, aY, aZ];
    }

    if (f1 != null && f2 != null && f3 != null && f4 != null && f5 != null) {
      // Convert double values to integers if necessary
      flexSensors = [
        f1.round(),
        f2.round(),
        f3.round(),
        f4.round(),
        f5.round()
      ];
    }

    print('Parsed accelerometers: $accelerometers');
    print('Parsed flexSensors: $flexSensors');

    // Prepare JSON payload
    Map<String, dynamic> requestBody = {
      "flex_sensors": flexSensors,
      "accelerometers": accelerometers,
    };

    try {
      // var url = Uri.parse(
      //     "http://192.168.0.107:5000/sign/get"); // Replace with your machine's IP

      ApiSettings apiSettings = ApiSettings(endPoint: "sign/get");
      var response = await apiSettings.postMethod(jsonEncode(requestBody));

      // var response = await http.post(
      //   url,
      //   headers: {"Content-Type": "application/json"},
      //   body: jsonEncode(requestBody),
      // );
      
      // var response = await apiSettings.postMethod(
      //   url,
      //   headers: {"Content-Type": "application/json"},
      //   body: jsonEncode(requestBody),
      // );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        String signedLetter = responseData['signed_letter'] ?? '';
        print('Signed Letter: $signedLetter');

        // Add signedLetter to the Stream
        _signedLetterController.add(signedLetter);
      } else {
        print(
            'Failed to fetch data from backend. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while sending data to backend: $e');
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
