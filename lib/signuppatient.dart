import 'package:flutter/material.dart';
import 'package:front/Service/PatientService.dart';

class SignupPage2 extends StatefulWidget {
  @override
  _SignupPage2State createState() => _SignupPage2State();
}

class _SignupPage2State extends State<SignupPage2> {
  final PatientService patientService = PatientService();

  final patientIdController = TextEditingController();
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final telephoneController = TextEditingController();
  final motDePasseController = TextEditingController();
  final confirmMotDePasseController = TextEditingController();

  bool _motDePasseObscured = true;

  // État d'erreur pour chaque champ
  bool _patientIdError = false;
  bool _nomError = false;
  bool _prenomError = false;
  bool _telephoneError = false;
  bool _motDePasseError = false;
  bool _confirmMotDePasseError = false;

  void _toggleMotDePasseVisibility() {
    setState(() {
      _motDePasseObscured = !_motDePasseObscured;
    });
  }

  Future<void> _registerPatient() async {
    // Validation des champs
    setState(() {
      _patientIdError = patientIdController.text.trim().isEmpty;
      _nomError = nomController.text.trim().isEmpty;
      _prenomError = prenomController.text.trim().isEmpty;
      _telephoneError = telephoneController.text.trim().isEmpty;
      _motDePasseError = motDePasseController.text.trim().isEmpty;
      _confirmMotDePasseError = confirmMotDePasseController.text.trim().isEmpty;
    });

    // Vérification s'il y a des erreurs de champ
    if ([_patientIdError, _nomError, _prenomError, _telephoneError, _motDePasseError, _confirmMotDePasseError].contains(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tous les champs sont obligatoires")),
      );
      return;
    }

    // Vérification si les mots de passe correspondent
    final motDePasse = motDePasseController.text.trim();
    final confirmMotDePasse = confirmMotDePasseController.text.trim();
    if (motDePasse != confirmMotDePasse) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Les mots de passe ne correspondent pas")),
      );
      return;
    }

    // Création de l'objet patient
    final newPatient = {
      'id_patient': patientIdController.text.trim(),
      'nom': nomController.text.trim(),
      'prenom': prenomController.text.trim(),
      'telephone': telephoneController.text.trim(),
      'motDePasse': motDePasse,
    };

    // Appel de l'API pour enregistrer le patient
    final response = await patientService.createPatient(newPatient);

    // Traitement de la réponse
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Patient créé avec succès")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : ${response.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 40),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "Patient",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              inputFile(
                label: "ID_Patient",
                controller: patientIdController,
                hasError: _patientIdError,
              ),
              inputFile(
                label: "Nom",
                controller: nomController,
                hasError: _nomError,
              ),
              inputFile(
                label: "Prénom",
                controller: prenomController,
                hasError: _prenomError,
              ),
              inputFile(
                label: "Téléphone",
                controller: telephoneController,
                hasError: _telephoneError,
              ),
              inputFile(
                label: "Mot de passe",
                controller: motDePasseController,
                obscureText: _motDePasseObscured,
                isPasswordField: true,
                toggleObscureText: _toggleMotDePasseVisibility,
                hasError: _motDePasseError,
              ),
              inputFile(
                label: "Confirmez le mot de passe",
                controller: confirmMotDePasseController,
                obscureText: _motDePasseObscured,
                isPasswordField: true,
                toggleObscureText: _toggleMotDePasseVisibility,
                hasError: _confirmMotDePasseError,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerPatient,
                child: Text("S'inscrire"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget inputFile({
  required String label,
  TextEditingController? controller,
  bool obscureText = false,
  bool isPasswordField = false,
  bool hasError = false,
  VoidCallback? toggleObscureText,
}) {
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
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          suffixIcon: isPasswordField
              ? IconButton(
            onPressed: toggleObscureText,
            icon: obscureText ? Icon(Icons.remove_red_eye) : Icon(Icons.visibility_off),
          )
              : null,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: hasError ? BorderSide(color: Colors.red) : BorderSide(),
          ),
          border: OutlineInputBorder(
            borderSide: hasError ? BorderSide(color: Colors.red) : BorderSide(),
          ),
        ),
      ),
      SizedBox(height: 10),
    ],
  );
}
