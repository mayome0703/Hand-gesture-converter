import 'package:flutter/material.dart';
import 'package:hand_gesture/utils/constants.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: const BoxDecoration(
            color: PRIMARY_COLOR,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/hardware.jpg',
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Shahabuddin akhon",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              Text(
                "Shahabuddin Akhon",
                style: TextStyle(
                  fontSize: 25,
                  color: PRIMARY_COLOR,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Email",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              Text(
                "shavoddin54@gmail.com",
                style: TextStyle(
                  fontSize: 25,
                  color: PRIMARY_COLOR,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Number",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              Text(
                "+8801982711168",
                style: TextStyle(
                  fontSize: 25,
                  color: PRIMARY_COLOR,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Date of birth",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              Text(
                "27/3/2001",
                style: TextStyle(
                  fontSize: 25,
                  color: PRIMARY_COLOR,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
