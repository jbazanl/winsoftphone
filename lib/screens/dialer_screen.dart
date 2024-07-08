import 'package:flutter/material.dart';
import '../widgets/dial_pad_button.dart';
import '../widgets/call_button.dart';
import '../services/sip_service.dart';
import 'call_screen.dart';
import 'contact_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RecentCall {
  final String phoneNumber;
  final DateTime timestamp;

  RecentCall({
    required this.phoneNumber,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory RecentCall.fromJson(Map<String, dynamic> json) {
    return RecentCall(
      phoneNumber: json['phoneNumber'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class DialerScreen extends StatefulWidget {
  @override
  _DialerScreenState createState() => _DialerScreenState();
}

class _DialerScreenState extends State<DialerScreen> {
  String _phoneNumber = '';
  String _name = '';
  final SipService _sipService = SipService();
  late TextEditingController _phoneController;
  final FocusNode _focusNode = FocusNode();
  List<RecentCall> _recentCalls = [];

  @override
  void initState() {
    super.initState();
    _sipService.initialize();
    _phoneController = TextEditingController(text: _phoneNumber);
    _loadRecentCalls();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addDigit(String digit) {
    setState(() {
      final previousText = _phoneController.text;
      final newText = previousText + digit;
      _phoneController.text = newText;
      _phoneController.selection =
          TextSelection.fromPosition(TextPosition(offset: newText.length));
      _phoneNumber = newText;
      _name = '';
    });
  }

  void _removeDigit() {
    final text = _phoneController.text;
    final selection = _phoneController.selection;

    if (text.isNotEmpty && selection.start > 0) {
      final start = selection.start;
      final end = selection.end;

      final newText = text.replaceRange(start - 1, end, '');
      final newSelectionIndex = start - 1;

      setState(() {
        _phoneController.text = newText;
        _phoneController.selection =
            TextSelection.fromPosition(TextPosition(offset: newSelectionIndex));
        _phoneNumber = newText;
        _name = '';
      });
    }
  }

  Future<void> _makeCall() async {
    if (_phoneNumber.isNotEmpty) {
      _sipService.makeCall(_phoneNumber);

      // Crear un nuevo objeto RecentCall
      RecentCall newCall = RecentCall(
        phoneNumber: _phoneNumber,
        timestamp: DateTime.now(),
      );

      // Insertar al inicio de la lista
      setState(() {
        _recentCalls.insert(0, newCall);
      });

      // Guardar en shared_preferences
      await _saveRecentCalls();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(phoneNumber: _phoneNumber),
        ),
      );
    }
  }

  Future<void> _saveRecentCalls() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recentCallsJson =
        _recentCalls.map((call) => jsonEncode(call.toJson())).toList();
    await prefs.setStringList('recentCalls', recentCallsJson);
  }

  Future<void> _loadRecentCalls() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? recentCallsJson = prefs.getStringList('recentCalls');

    if (recentCallsJson != null) {
      setState(() {
        _recentCalls = recentCallsJson
            .map((jsonString) => RecentCall.fromJson(
                  jsonDecode(jsonString),
                ))
            .toList();
      });
    }
  }

  void _openContacts() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactListScreen()),
    );
    if (result != null) {
      setState(() {
        _phoneNumber = result.phoneNumber;
        _phoneController.text = _phoneNumber;
        _phoneController.selection = TextSelection.fromPosition(
            TextPosition(offset: _phoneNumber.length));
        _name = result.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(_focusNode);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: EditableText(
                        controller: _phoneController,
                        focusNode: _focusNode,
                        style: TextStyle(fontSize: 36, color: Colors.white),
                        cursorColor: Colors.blue,
                        backgroundCursorColor: Colors.grey,
                        keyboardType: TextInputType.none,
                        textAlign: TextAlign.center,
                        cursorWidth: 2.0,
                        cursorRadius: Radius.circular(2.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _name,
                    style: TextStyle(fontSize: 16, color: Colors.blue),
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
                  DialPadButton(
                      number: '1',
                      letters: '',
                      onPressed: () => _addDigit('1')),
                  DialPadButton(
                      number: '2',
                      letters: 'ABC',
                      onPressed: () => _addDigit('2')),
                  DialPadButton(
                      number: '3',
                      letters: 'DEF',
                      onPressed: () => _addDigit('3')),
                  DialPadButton(
                      number: '4',
                      letters: 'GHI',
                      onPressed: () => _addDigit('4')),
                  DialPadButton(
                      number: '5',
                      letters: 'JKL',
                      onPressed: () => _addDigit('5')),
                  DialPadButton(
                      number: '6',
                      letters: 'MNO',
                      onPressed: () => _addDigit('6')),
                  DialPadButton(
                      number: '7',
                      letters: 'PQRS',
                      onPressed: () => _addDigit('7')),
                  DialPadButton(
                      number: '8',
                      letters: 'TUV',
                      onPressed: () => _addDigit('8')),
                  DialPadButton(
                      number: '9',
                      letters: 'WXYZ',
                      onPressed: () => _addDigit('9')),
                  DialPadButton(
                      number: '*',
                      letters: '',
                      onPressed: () => _addDigit('*')),
                  DialPadButton(
                      number: '0',
                      letters: '+',
                      onPressed: () => _addDigit('0')),
                  DialPadButton(
                      number: '#',
                      letters: '',
                      onPressed: () => _addDigit('#')),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: SizedBox()), // Espacio a la izquierda
                  Expanded(
                    child: Center(
                      child: CallButton(onPressed: _makeCall),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: Icon(Icons.backspace, color: Colors.white),
                        onPressed: _removeDigit,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.star, 'Favoritos'),
          _buildNavItem(Icons.access_time, 'Recientes',
              onTap: _showRecentCalls),
          _buildNavItem(Icons.contacts, 'Contactos', onTap: _openContacts),
          _buildNavItem(Icons.dialpad, 'Teclado', isSelected: true),
          //_buildNavItem(Icons.voicemail, 'Voicemail'),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label,
      {bool isSelected = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
          Text(label,
              style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  void _showRecentCalls() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecentCallsScreen(recentCalls: _recentCalls),
      ),
    );
  }
}

class RecentCallsScreen extends StatelessWidget {
  final List<RecentCall> recentCalls;

  const RecentCallsScreen({Key? key, required this.recentCalls})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recent Calls'),
      ),
      body: ListView.builder(
        itemCount: recentCalls.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(recentCalls[index].phoneNumber),
            subtitle: Text('Date: ${recentCalls[index].timestamp.toString()}'),
          );
        },
      ),
    );
  }
}
