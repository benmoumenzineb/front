import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SocialMediaPage(),
    );
  }
}

class SocialMediaPage extends StatelessWidget {
  final String facebookUrl = "https://www.facebook.com/yourprofile";
  final String instagramUrl = "https://www.instagram.com/yourprofile";
  final String whatsappUrl = "https://wa.me/1234567890"; // Numéro WhatsApp

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Partage sur les réseaux sociaux"),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _launchURL(facebookUrl),
              child: Image.asset(
                'lib/assets/facebook.png',
                width: 32,
                height: 32,
              ),
            ),
            SizedBox(width: 20), // Espace entre les icônes
            GestureDetector(
              onTap: () => _launchURL(instagramUrl),
              child: Image.asset(
                'lib/assets/instagram.png',
                width: 32,
                height: 32,
              ),
            ),
            SizedBox(width: 20), // Espace entre les icônes
            GestureDetector(
              onTap: () => _launchURL(whatsappUrl),
              child: Image.asset(
                'lib/assets/whatsapp.jpg',
                width: 32,
                height: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
