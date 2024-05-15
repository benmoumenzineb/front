import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController motDePasseController = TextEditingController();
  TextEditingController confirmMotDePasseController = TextEditingController();

  bool _isObscure = true;
  bool _isConfirmObscure = true;

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    telephoneController.dispose();
    motDePasseController.dispose();
    confirmMotDePasseController.dispose();
    super.dispose();
  }

  Future<void> registerDoctor(String nom, String prenom, String telephone, String motDePasse) async {
    final url = 'http://192.168.2.20:8080/api/doctors';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nom': nom,
        'prenom': prenom,
        'telephone': telephone,
        'motDePasse': motDePasse,
      }),
    );

    if (response.statusCode == 201) {
      // Afficher un message de succès lorsque le compte est créé avec succès
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Compte créé avec succès!"),
        backgroundColor: Colors.green,
      ));

      // Rediriger l'utilisateur vers la page de connexion (LoginPage)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      print('Erreur lors de l\'enregistrement');
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (motDePasseController.text != confirmMotDePasseController.text) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Les mots de passe ne correspondent pas."),
          backgroundColor: Colors.red,
        ));
        return;
      }
      registerDoctor(
        nomController.text,
        prenomController.text,
        telephoneController.text,
        motDePasseController.text,
      );
    }
  }

  String? _validateNom(String? value) {
    if (value == null || value.isEmpty) {
      return "Veuillez saisir votre nom.";
    }
    return null;
  }

  String? _validatePrenom(String? value) {
    if (value == null || value.isEmpty) {
      return "Veuillez saisir votre prénom.";
    }
    return null;
  }

  String? _validateTelephone(String? value) {
    if (value == null || value.isEmpty) {
      return "Veuillez saisir votre numéro de téléphone.";
    }
    // Vous pouvez ajouter ici une validation pour le format du numéro de téléphone
    return null;
  }

  String? _validateMotDePasse(String? value) {
    if (value == null || value.isEmpty) {
      return "Veuillez saisir votre mot de passe.";
    }
    // Vous pouvez ajouter ici des règles de validation supplémentaires pour le mot de passe
    return null;
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Médecin",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                Column(
                  children: <Widget>[
                    TextFormField(
                      controller: nomController,
                      decoration: InputDecoration(
                        labelText: 'Nom',
                      ),
                      validator: _validateNom,
                    ),
                    TextFormField(
                      controller: prenomController,
                      decoration: InputDecoration(
                        labelText: 'Prénom',
                      ),
                      validator: _validatePrenom,
                    ),
                    TextFormField(
                      controller: telephoneController,
                      decoration: InputDecoration(
                        labelText: 'Numéro de téléphone',
                      ),
                      validator: _validateTelephone,
                    ),
                    TextFormField(
                      controller: motDePasseController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                      validator: _validateMotDePasse,
                    ),
                    TextFormField(
                      controller: confirmMotDePasseController,
                      obscureText: _isConfirmObscure,
                      decoration: InputDecoration(
                        labelText: 'Confirmer mot de passe',
                        suffixIcon: IconButton(
                          icon: Icon(_isConfirmObscure ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isConfirmObscure = !_isConfirmObscure;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value != motDePasseController.text) {
                          return "Les mots de passe ne correspondent pas.";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 3, left: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border(
                      bottom: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: _submitForm,
                    color: Color(0xff0095FF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "S'inscrire",


                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}