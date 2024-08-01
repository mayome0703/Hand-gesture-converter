import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
              onPressed: () {},
              child: const Text("Connect"),
            ),
          ],
        ),
      ),
    );
  }
}
