import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Patient {
  final String idPatient;
  final String nom;
  final String prenom;

  Patient({
    required this.idPatient,
    required this.nom,
    required this.prenom,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      idPatient: json['idPatient'],
      nom: json['nom'],
      prenom: json['prenom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idPatient': idPatient,
      'nom': nom,
      'prenom': prenom,
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
        print('Response body: ${response.body}');
        throw Exception('Failed to load patients');
      }
    } catch (e) {
      print(e);
      // Gérer l'erreur de manière appropriée dans votre application
    }
  }

  Future<void> registerPatient(String nom, String prenom, String idPatient, String doctorName) async {
    var url = Uri.parse('http://localhost:8080/api/patients/createWithAuth');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'nom': nom,
          'prenom': prenom,
          'id_patient': idPatient,
          'doctorName': doctorName,
        }),
      );
      if (response.statusCode == 201) {
        fetchPatients();
      } else {
        print('Response body: ${response.body}');
        throw Exception('Failed to register patient');
      }
    } catch (e) {
      print(e);
      // Gérer l'erreur de manière appropriée dans votre application
    }
  }

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
            title: Text(patient.nom),
            subtitle: Text(patient.prenom),
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
                content: RegisterPatientForm(onSubmit: registerPatient),
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
  final Function(String, String, String, String) onSubmit;

  RegisterPatientForm({required this.onSubmit});

  @override
  _RegisterPatientFormState createState() => _RegisterPatientFormState();
}

class _RegisterPatientFormState extends State<RegisterPatientForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _idPatientController = TextEditingController();
  final _doctorNameController = TextEditingController();

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
            controller: _doctorNameController,
            decoration: InputDecoration(labelText: 'Doctor Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a doctor name';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSubmit(
                  _nomController.text,
                  _prenomController.text,
                  _idPatientController.text,
                  _doctorNameController.text,
                );
                Navigator.of(context).pop();
              }
            },
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}
