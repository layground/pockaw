import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GeminiApiService {
  static const String _apiKey = 'AIzaSyCNFglBawmfZ-zARjXrXtRpjZdlsL-YMI8';
  static const String _endpoint =
      'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=$_apiKey';

  /// Sends an image to Gemini and returns the extracted transaction details as a Map.
  Future<Map<String, dynamic>?> extractTransactionDetails(File imageFile,
      {List<String>? availableCategories,
      List<String>? availableAccounts}) async {
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    print('DEBUG: Available categories: $availableCategories');
    print('DEBUG: Available accounts: $availableAccounts');

    final requestBody = {
      "contents": [
        {
          "parts": [
            {
              "inline_data": {
                "mimeType": "image/jpeg",
                "data": base64Image,
              }
            },
            {
              "text":
                  "Extract transaction details (amount, date, merchant, items, total, category, description) from this bill/receipt image. Return as JSON. ${availableCategories != null && availableCategories.isNotEmpty ? "Only use the following categories if applicable: ${availableCategories.join(', ')}. " : ""}${availableAccounts != null && availableAccounts.isNotEmpty ? "Only use the following accounts if applicable: ${availableAccounts.join(', ')}." : ""}"
            }
          ]
        }
      ]
    };

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    print('GEMINI RAW RESPONSE:');
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Gemini returns text in a nested structure; extract JSON from text
      final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      if (text != null) {
        try {
          // Try to parse the text as JSON (strip markdown and surrounding text if present)
          final jsonMatch =
              RegExp(r'```json\n([\s\S]*?)\n```').firstMatch(text);
          String jsonString;

          if (jsonMatch != null && jsonMatch.group(1) != null) {
            jsonString = jsonMatch.group(1)!;
          } else {
            // Fallback: try to parse the entire text if no markdown block is found
            jsonString = text.trim();
          }

          final parsed = jsonDecode(jsonString);
          print(
              'DEBUG: Parsed JSON string (before decoding) in GeminiApiService:');
          print(jsonString);
          print('DEBUG: Parsed JSON (after decoding) in GeminiApiService:');
          print(parsed);

          // If the response is a transaction list, return the first transaction for easy mapping
          if (parsed is Map &&
              parsed['transactions'] is List &&
              parsed['transactions'].isNotEmpty) {
            return parsed['transactions'][0];
          }
          return parsed; // Return the parsed map directly
        } catch (e) {
          print('ERROR: Failed to parse JSON from Gemini response: $e');
          // If not valid JSON, return as raw text
          return {'raw': text};
        }
      }
    }
    return null;
  }
}
