import 'package:url_launcher/url_launcher.dart';

class LinkLauncher {
  static Future<void> launch(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
