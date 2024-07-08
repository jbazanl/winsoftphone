// lib/screens/call_screen.dart

import 'package:flutter/material.dart';
import '../services/sip_service.dart';

class CallScreen extends StatefulWidget {
  final String phoneNumber;

  CallScreen({required this.phoneNumber});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final SipService _sipService = SipService();

  @override
  void initState() {
    super.initState();
    _sipService.makeCall(widget.phoneNumber);
  }

  void _toggleMute() {
    setState(() {
      _sipService.toggleMute(!_sipService.isMuted);
    });
  }

  void _toggleSpeaker() {
    setState(() {
      _sipService.toggleSpeaker(!_sipService.isSpeakerOn);
    });
  }

  void _endCall() {
    _sipService.endCall();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C1E),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    widget.phoneNumber,
                    style: TextStyle(fontSize: 36, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '00:06',
                    style: TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                childAspectRatio: 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildCallOption(
                      Icons.mic_off, 'mute', _toggleMute, _sipService.isMuted),
                  _buildCallOption(Icons.dialpad, 'keypad', () {}),
                  _buildCallOption(Icons.volume_up, 'speaker', _toggleSpeaker,
                      _sipService.isSpeakerOn),
                  _buildCallOption(Icons.add, 'add call', () {}),
                  _buildCallOption(Icons.videocam, 'FaceTime', () {}),
                  _buildCallOption(Icons.contacts, 'contacts', () {}),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: ElevatedButton(
                onPressed: _endCall,
                child: Text('End'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallOption(IconData icon, String label, VoidCallback onPressed,
      [bool isActive = false]) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.white : Color(0xFF2C2C2E),
          ),
          child: IconButton(
            icon: Icon(icon),
            onPressed: onPressed,
            color: isActive ? Colors.black : Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
