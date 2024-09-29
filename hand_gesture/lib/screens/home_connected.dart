import 'dart:convert';
// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:hand_gesture/utils/api_sattings.dart';
import 'package:hand_gesture/utils/constants.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomeConnected extends StatefulWidget {
  
  final BluetoothDevice? bluetoothDevice;

  const HomeConnected({
    Key? key,
    this.bluetoothDevice,
  }) : super(key: key);

  @override
  State<HomeConnected> createState() => _HomeConnectedState();
}

class _HomeConnectedState extends State<HomeConnected> {
  final FlutterTts flutterTts = FlutterTts();
  String receivedData = "";
  String DetectedSignedLetter = "";
  BluetoothConnection? connection;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void speak(String text) async {
    await flutterTts.setLanguage('bn-BD');
    await flutterTts.setPitch(1);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setSpeechRate(0.3);
    await flutterTts.speak(text + text); //one letter makes barely any sound, but repeating twice, it can be heard.
  }

  void getData() async {
    if (widget.bluetoothDevice != null) {
      await BluetoothConnection.toAddress(widget.bluetoothDevice?.address)
          .then((_connection) {
        connection = _connection;

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
        });
      }).catchError((error) {
        print('Error: $error');
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
        setState(() {
          DetectedSignedLetter = signedLetter;
        });
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR,
        title: const Text("Hand Gesture Detector"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 10.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Your Device is Connected",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      "Identified alphabet is \n $DetectedSignedLetter",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.volume_up, size: 30),
                          onPressed: () {
                          if(DetectedSignedLetter != "No character found")
                            {
                              speak(DetectedSignedLetter);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "History",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(
                          Icons.history,
                          size: 30,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // widget.history.isNotEmpty
                    //     ? ListView.builder(
                    //         shrinkWrap: true,
                    //         physics: const NeverScrollableScrollPhysics(),
                    //         itemCount: widget.history.length,
                    //         itemBuilder: (context, index) {
                    //           return Padding(
                    //             padding:
                    //                 const EdgeInsets.symmetric(vertical: 5.0),
                    //             child: Row(
                    //               children: [
                    //                 Text(
                    //                   widget.history[index],
                    //                   style: const TextStyle(
                    //                     fontSize: 25,
                    //                   ),
                    //                 ),
                    //                 const SizedBox(
                    //                   width: 20,
                    //                 ),
                    //               ],
                    //             ),
                    //           );
                    //         },
                    //       )
                    //     : const Text(
                    //         "No history yet.",
                    //         style: TextStyle(
                    //           fontSize: 16,
                    //           color: Colors.grey,
                    //         ),
                    //       ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
