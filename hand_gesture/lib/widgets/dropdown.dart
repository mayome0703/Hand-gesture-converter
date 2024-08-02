import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  const Dropdown({super.key});

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  final List<String> items = [
    'Flex sensor 1',
    'Flex sensor 2',
    'Flex sensor 3',
    'Flex sensor 4',
    'Flex sensor 5'
  ];
  String? selectedItem;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedItem,
      hint: const Text('Select a sensor'),
      style: const TextStyle(
        color: Colors.black,
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          selectedItem = newValue!;
        });
      },
    );
  }
}
