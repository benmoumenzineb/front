import 'package:flutter/material.dart';
class ParametresPage extends StatefulWidget {
  @override
  _ParametresPageState createState() => _ParametresPageState();
}
class _ParametresPageState extends State<ParametresPage> {
  bool _notificationsActive = true;
  bool _darkModeActive = false;
  String _selectedLangue = 'Français'; // Langue sélectionnée par défaut
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Notifications',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text('Activer les notifications'),
              value: _notificationsActive,
              onChanged: (value) {
                setState(() {
                  _notificationsActive = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'Langue',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text('Changer la langue'),
              onTap: () {
                _showLangueDialog(); // Afficher le dialogue de langue
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'Mode sombre',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text('Activer le mode sombre'),
              value: _darkModeActive,
              onChanged: (value) {
                setState(() {
                  _darkModeActive = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour afficher le dialogue de sélection de langue
  void _showLangueDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sélectionner une langue'),
          content: DropdownButton<String>(
            value: _selectedLangue,
            onChanged: (String? newValue) {
              setState(() {
                _selectedLangue = newValue!;
              });
              Navigator.of(context).pop(); // Fermer le dialogue après la sélection
            },
            items: <String>['Français', 'Anglais', 'Arabe']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}