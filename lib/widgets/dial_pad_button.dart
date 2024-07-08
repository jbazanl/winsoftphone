import 'package:flutter/material.dart';
import '../services/sound_service.dart';

class DialPadButton extends StatelessWidget {
  final String number;
  final String letters;
  final VoidCallback onPressed;
  final SoundService _soundService = SoundService();

  DialPadButton({
    Key? key,
    required this.number,
    required this.letters,
    required this.onPressed,
  }) : super(key: key);

  void _handlePress() {
    _soundService.playDTMFTone(number);
    onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handlePress,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF2C2C2E),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              number,
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              letters,
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
