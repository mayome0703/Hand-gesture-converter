import 'package:flutter/material.dart';
import 'package:hand_gesture/widgets/video_player.dart';

class Tutorial extends StatelessWidget {
  const Tutorial({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 40.0,
        vertical: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hardware Connection",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          VideoPlayer(
            id: '8BNp6niBp-A',
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            "How to wear gloves?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          VideoPlayer(
            id: 'oBpehYPtOAA',
          ),
        ],
      ),
    );
  }
}
