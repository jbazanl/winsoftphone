import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RecentCallsService {
  static const _recentCallsKey = 'recent_calls';

  Future<List<RecentCall>> getRecentCalls() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? recentCallsJson = prefs.getStringList(_recentCallsKey);
    if (recentCallsJson == null) return [];
    return recentCallsJson.map((callJson) {
      Map<String, dynamic> callMap = jsonDecode(callJson);
      return RecentCall(
          callMap['phoneNumber'], DateTime.parse(callMap['timestamp']));
    }).toList();
  }

  Future<void> addRecentCall(RecentCall call) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recentCallsJson = prefs.getStringList(_recentCallsKey) ?? [];
    recentCallsJson.add(jsonEncode({
      'phoneNumber': call.phoneNumber,
      'timestamp': call.timestamp.toIso8601String(),
    }));
    prefs.setStringList(_recentCallsKey, recentCallsJson);
  }
}
