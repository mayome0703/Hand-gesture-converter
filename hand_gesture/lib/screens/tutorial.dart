import 'package:flutter/material.dart';
import 'package:hand_gesture/widgets/video_player.dart';

class Tutorial extends StatelessWidget {
  const Tutorial({super.key});

  @override
  Widget build(BuildContext context) {
    String longVideo = "assets/videos/microprocessor.mp4";
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 40.0,
        vertical: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Hardware Connection",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomVideoPlayerComponent(
            videoUrl: longVideo,
          ),
          const SizedBox(
            height: 40,
          ),
          const Text(
            "How to wear gloves?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomVideoPlayerComponent(
            videoUrl: longVideo,
          ),
        ],
      ),
    );
  }
}
