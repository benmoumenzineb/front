import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Patient {
  final String idPatient;
  final String nom;
  final String prenom;
  final String motDePasse;
  final String telephone;
  final String doctorName;

  Patient({
    required this.idPatient,
    required this.nom,
    required this.prenom,
    required this.motDePasse,
    required this.telephone,
    required this.doctorName,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      idPatient: json['idPatient'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      motDePasse: json['motDePasse'] ?? '',
      telephone: json['telephone'] ?? '',
      doctorName: json['doctorName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idPatient': idPatient,
      'nom': nom,
      'prenom': prenom,
      'motDePasse': motDePasse,
      'telephone': telephone,
      'doctorName': doctorName,
    };
  }
}

class PatientsPage extends StatefulWidget {
  @override
  _PatientsPageState createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  List<Patient> patients = [];

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    var url = Uri.parse('http://localhost:8080/api/patients');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        setState(() {
          patients = body.map((dynamic item) => Patient.fromJson(item)).toList();
        });
      } else {
        throw Exception('Failed to load patients');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> addPatient(Patient patient) async {
    var url = Uri.parse('http://localhost:8080/api/patients/createWithAuth');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(patient.toJson()),
      );
      if (response.statusCode == 201) {
        fetchPatients();
      } else {
        throw Exception('Failed to add patient');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  Future<void> deletePatient(String name) async {
    var url = Uri.parse('http://localhost:8080/api/patients/byName');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 204) {
        fetchPatients();
      } else if (response.statusCode == 404) {
        throw Exception('Patient not found');
      } else {
        throw Exception('Failed to delete patient');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
/*pour donner non au token
Future<void> deletePatientByName(String patientName) async {
  final response = await http.delete(
    Uri.parse('http://localhost:8080/api/patients/byName'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken', // Assurez-vous d'inclure le jeton d'authentification si nécessaire
    },
    body: jsonEncode(<String, String>{
      'patientName': patientName,
    }),
  );

  if (response.statusCode == 204) {
    // Patient supprimé avec succès
  } else {
    // Gérer les autres codes d'état HTTP, par exemple, afficher un message d'erreur
  }
}

 */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients'),
      ),
      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final patient = patients[index];
          return ListTile(
            title: Text(patient.nom.isNotEmpty ? patient.nom : 'Nom inconnu'),
            subtitle: Text(patient.prenom.isNotEmpty ? patient.prenom : 'Prénom inconnu'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deletePatient(patient.idPatient);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Register Patient'),
                content: RegisterPatientForm(onSubmit: addPatient),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class RegisterPatientForm extends StatefulWidget {
  final Function(Patient) onSubmit;

  RegisterPatientForm({required this.onSubmit});

  @override
  _RegisterPatientFormState createState() => _RegisterPatientFormState();
}

class _RegisterPatientFormState extends State<RegisterPatientForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _idPatientController = TextEditingController();
  final _motDePasseController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _nomDocteurController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: _nomController,
            decoration: InputDecoration(labelText: 'Nom'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _prenomController,
            decoration: InputDecoration(labelText: 'Prenom'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a prenom';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _idPatientController,
            decoration: InputDecoration(labelText: 'ID Patient'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an ID Patient';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _motDePasseController,
            decoration: InputDecoration(labelText: 'Mot de Passe'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a mot de passe';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _telephoneController,
            decoration: InputDecoration(labelText: 'Téléphone'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a telephone';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _nomDocteurController,
            decoration: InputDecoration(labelText: 'Nom du Docteur'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a doctor name';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                final newPatient = Patient(
                  idPatient: _idPatientController.text,
                  nom: _nomController.text,
                  prenom: _prenomController.text,
                  motDePasse: _motDePasseController.text,
                  telephone: _telephoneController.text,
                  doctorName: _nomDocteurController.text,
                );
                widget.onSubmit(newPatient);
                Navigator.of(context).pop();
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
