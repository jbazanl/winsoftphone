// lib/services/sip_service.dart

class SipService {
  static final SipService _instance = SipService._internal();
  factory SipService() => _instance;

  SipService._internal();

  bool _isInCall = false;
  bool _isMuted = false;
  bool _isSpeakerOn = false;

  void initialize() {
    // Simulamos la inicialización
    print('SIP Service initialized');
  }

  Future<void> makeCall(String phoneNumber) async {
    // Simulamos hacer una llamada
    await Future.delayed(Duration(seconds: 1));
    _isInCall = true;
    print('Calling $phoneNumber');
  }

  void endCall() {
    // Simulamos terminar la llamada
    _isInCall = false;
    print('Call ended');
  }

  void toggleMute(bool isMuted) {
    _isMuted = isMuted;
    print('Mute toggled: $_isMuted');
  }

  void toggleSpeaker(bool isSpeakerOn) {
    _isSpeakerOn = isSpeakerOn;
    print('Speaker toggled: $_isSpeakerOn');
  }

  bool get isInCall => _isInCall;
  bool get isMuted => _isMuted;
  bool get isSpeakerOn => _isSpeakerOn;

  void dispose() {
    // Limpieza si es necesaria
    print('SIP Service disposed');
  }
}
