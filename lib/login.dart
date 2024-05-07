import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/ProfilePage.dart';
import 'package:front/signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers to manage text field inputs
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose of controllers when no longer needed
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
      body: SingleChildScrollView( // Allows vertical scrolling
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20), // Add space at the beginning
              Center( // Center content
                child: Column(
                  children: <Widget>[
                    Text(
                      "Médecin",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold, // Correct assignment
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("lib/assets/doctors.PNG"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // Space between elements
              inputFile(
                label: "Nom",
                controller: nameController, // Assign controller
              ),
              SizedBox(height: 10),
              inputFile(
                label: "Mot de passe",
                controller: passwordController, // Assign controller
                obscureText: true, // For password field
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                child: MaterialButton(
                  onPressed: () {
                    var name = nameController.text; // Get text from input
                    var password = passwordController.text; // Get text from input

                    // Validation logic
                    if (name.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Veuillez remplir tous les champs')), // Display error message
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()), // Navigate to ProfilePage
                      );
                    }
                  },
                  color: Color(0xff0095FF),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Se connecter",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold, // Correct assignment
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Space after button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Vous n'avez pas un compte?",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 5),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()), // Navigate to signup page
                      );
                    },
                    child: Text(
                      "Créer un compte",
                      style: TextStyle(
                        color: Color(0xff0095FF),
                        fontSize: 16,
                        fontWeight: FontWeight.bold, // Correct assignment
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20), // Final spacing to avoid overflow
            ],
          ),
        ),
      ),
    );
  }
}

Widget inputFile({required String label, TextEditingController? controller, bool obscureText = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
      SizedBox(height: 5),
      TextField(
        controller: controller, // Use the passed controller
        obscureText: obscureText, // Set to true for password fields
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    ],
  );
}
