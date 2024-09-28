import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomeConnected extends StatelessWidget {
  final FlutterTts flutterTts = FlutterTts();
  HomeConnected({super.key});

  //text to speech. DO NOT REMOVE*****
  void speak(String text) async {
    await flutterTts.setLanguage('bn-BD');
    await flutterTts.setPitch(1);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setSpeechRate(0.3);
    await flutterTts.speak(text + text); //one letter makes barely any sound, but repeating twice, it can be heard.
  }
  //DO NOT REMOVE*******

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
                  const Text(
                    "Identified alphabet is",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "A",
                    style: TextStyle(
                      fontSize: 100,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //DO NOT REMOVE****
                      IconButton(
                        onPressed: () {
                          speak('অ');
                        },
                        icon: const Icon(
                          Icons.volume_up,
                          size: 30,
                        ),
                      )
                      //DO NOT REMOVE****
                    ],
                  )
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
                      Text(
                        "History",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.history,
                        size: 30,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        "A",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "B",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
