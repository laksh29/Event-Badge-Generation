import 'package:flutter/material.dart';

class StunningTextField extends StatelessWidget {
  const StunningTextField({
    super.key,
    required this.onChanged,
  });

  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        // cursorColor: Colors.,
        decoration: const InputDecoration(
          hintText: 'Enter Name',
          border: InputBorder.none,
          icon: Icon(
            Icons.person,
          ),
        ),
        onChanged: onChanged,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}
