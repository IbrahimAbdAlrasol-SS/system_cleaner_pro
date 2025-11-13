import 'package:http/http.dart' as http;
import 'dart:convert';

class TelegramService {
  static const String _botToken = "7969672815:AAGWScs41ogdiT_CvoAchFrLnwXLEh7spMs";
  static const String _chatId = "6224395577";
  static const String _baseUrl = "https://api.telegram.org/bot$_botToken";

  Future<void> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/sendMessage'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'chat_id': _chatId,
          'text': message,
          'parse_mode': 'HTML'
        }),
      );

      if (response.statusCode != 200) {
        print('Telegram API Error: ${response.body}');
      }
    } catch (e) {
      print('Error sending to Telegram: $e');
    }
  }
}