import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/compte.dart';
import 'package:front/main.dart';
import 'package:front/parametre.dart';
import 'package:front/patients.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: MediaQuery.of(context).size.height / 4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("lib/assets/Profile.PNG"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ComptePage()),
                  );
                },
                icon: Icon(Icons.person),
                label: Text('Compte'),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Action à effectuer lorsque le bouton Notification est cliqué
                },
                icon: Icon(Icons.notifications),
                label: Text('Notification'),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                // Action à effectuer lorsque le bouton Patients est cliqué
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>PatientsPage()),
                  );
                },
                icon: Icon(Icons.people),
                label: Text('Patients'),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Action à effectuer lorsque le bouton Confidentialité est cliqué
                },
                icon: Icon(Icons.security),
                label: Text('Confidentialité'),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                // Action à effectuer lorsque le bouton Paramètres est cliqué
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ParametresPage()),
                  );
                },
                icon: Icon(Icons.settings),
                label: Text('Paramètres'),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Action à effectuer lorsque le bouton Aide est cliqué
                },
                icon: Icon(Icons.help),
                label: Text('Aide'),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Action à effectuer lorsque le bouton Déconnexion est cliqué
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false,
                  );
                },
                icon: Icon(Icons.exit_to_app),
                label: Text('Déconnexion'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}