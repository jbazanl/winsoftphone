import 'package:flutter/material.dart';

class CallButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CallButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green,
        ),
        child: Icon(Icons.phone, color: Colors.white, size: 30),
      ),
    );
  }
}
