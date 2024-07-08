import 'package:flutter/material.dart';
import '../widgets/dial_pad_button.dart';
import '../widgets/call_button.dart';
import '../services/sip_service.dart';
import 'call_screen.dart';
import 'contact_list_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _sipService.initialize();
    _phoneController = TextEditingController(text: _phoneNumber);
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

  void _makeCall() {
    if (_phoneNumber.isNotEmpty) {
      _sipService.makeCall(_phoneNumber);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(phoneNumber: _phoneNumber),
        ),
      );
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
          _buildNavItem(Icons.star, 'Favorites'),
          _buildNavItem(Icons.access_time, 'Recents'),
          _buildNavItem(Icons.contacts, 'Contacts', onTap: _openContacts),
          _buildNavItem(Icons.dialpad, 'Keypad', isSelected: true),
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
}
