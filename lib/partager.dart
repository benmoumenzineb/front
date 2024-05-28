import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headline6: TextStyle(fontWeight: FontWeight.bold),
          bodyText2: TextStyle(color: Colors.black),
        ),
      ),
      home: SocialMediaPage(),
    );
  }
}
class SocialMediaPage extends StatelessWidget {
  final String facebookUrl = "https://www.facebook.com/yourprofile";
  final String instagramUrl = "https://www.instagram.com/yourprofile";
  final String whatsappUrl = "https://wa.me/1234567890";
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Partagez vos mesures sur les réseaux sociaux!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Ajuster à 2 pour mieux s'adapter aux petits écrans
                mainAxisSpacing: 20, // Espacement entre les lignes
                crossAxisSpacing: 20, // Espacement entre les colonnes
                childAspectRatio: 3 / 2, // Ajuster l'aspect pour mieux s'adapter à la taille des écrans
                children: [
                  _socialMediaCard(
                    context,
                    'lib/assets/facebook.png',
                    'Facebook',
                        () => _launchURL(facebookUrl),
                  ),
                  _socialMediaCard(
                    context,
                    'lib/assets/instagram.png',
                    'Instagram',
                        () => _launchURL(instagramUrl),
                  ),
                  _socialMediaCard(
                    context,
                    'lib/assets/whatsapp.jpg',
                    'WhatsApp',
                        () => _launchURL(whatsappUrl),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialMediaCard(BuildContext context, String assetPath, String label, VoidCallback onTap) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              assetPath,
              width: 40,
              height: 40,
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
