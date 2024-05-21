import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Patient {
  final String nom;
  final String prenom;
  final String telephone;
  final String motDePasse;
  final String idPatient;

  Patient({
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.motDePasse,
    required this.idPatient,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      nom: json['nom'],
      prenom: json['prenom'],
      telephone: json['telephone'],
      motDePasse: json['motDePasse'],
      idPatient: json['idPatient'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'motDePasse': motDePasse,
      'idPatient': idPatient,
    };
  }
}

class PatientsPage extends StatefulWidget {
  @override
  _PatientsPageState createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  List<Patient> patients = [];
  String token = "<your_token>"; // Replace with the actual token

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    var url = Uri.parse('http://localhost:8080/api/patients/doctor/patients');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      setState(() {
        patients = body.map((dynamic item) => Patient.fromJson(item)).toList();
      });
    } else {
      print('Erreur lors de la récupération des patients: ${response.statusCode}');
      throw Exception('Failed to load patients');
    }
  }

  Future<void> registerPatient(String nom, String prenom, String telephone, String motDePasse, String idPatient) async {
    var url = Uri.parse('http://localhost:8080/api/patients');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Include the token here
      },
      body: jsonEncode(Patient(
        nom: nom,
        prenom: prenom,
        telephone: telephone,
        motDePasse: motDePasse,
        idPatient: idPatient,
      ).toJson()),
    );

    if (response.statusCode == 201) {
      setState(() {
        patients.add(Patient(
          nom: nom,
          prenom: prenom,
          telephone: telephone,
          motDePasse: motDePasse,
          idPatient: idPatient,
        ));
      });
    } else {
      print('Erreur lors de l\'enregistrement du patient: ${response.statusCode}');
      throw Exception('Failed to register patient');
    }
  }


  Future<void> deletePatient(String id) async {
    var url = Uri.parse('http://localhost:8080/api/patients/$id');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 204) {
      setState(() {
        patients.removeWhere((patient) => patient.idPatient == id);
      });
    } else {
      print('Erreur lors de la suppression du patient: ${response.statusCode}');
      throw Exception('Failed to delete patient');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Patients'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _addPatientDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deletePatientDialog(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Patient ${index + 1} - ${patients[index].nom}'),
            trailing: ElevatedButton(
              onPressed: () {
                _showPatientDetails(context, index);
              },
              child: Text('Voir Détails'),
            ),
          );
        },
      ),
    );
  }

  void _showPatientDetails(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Détails du Patient'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nom: ${patients[index].nom}'),
              Text('Prénom: ${patients[index].prenom}'),
              Text('Téléphone: ${patients[index].telephone}'),
              Text('Mot de passe: ${patients[index].motDePasse}'),
              Text('ID Patient: ${patients[index].idPatient}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  void _addPatientDialog(BuildContext context) {
    TextEditingController nomController = TextEditingController();
    TextEditingController prenomController = TextEditingController();
    TextEditingController telephoneController = TextEditingController();
    TextEditingController motDePasseController = TextEditingController();
    TextEditingController idPatientController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter un Patient'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomController,
                  decoration: InputDecoration(labelText: 'Nom'),
                ),
                TextField(
                  controller: prenomController,
                  decoration: InputDecoration(labelText: 'Prénom'),
                ),
                TextField(
                  controller: telephoneController,
                  decoration: InputDecoration(labelText: 'Téléphone'),
                ),
                TextField(
                  controller: motDePasseController,
                  decoration: InputDecoration(labelText: 'Mot de passe'),
                  obscureText: true,
                ),
                TextField(
                  controller: idPatientController,
                  decoration: InputDecoration(labelText: 'ID Patient'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                String nom = nomController.text.trim();
                String prenom = prenomController.text.trim();
                String telephone = telephoneController.text.trim();
                String motDePasse = motDePasseController.text.trim();
                String idPatient = idPatientController.text.trim();

                try {
                  await registerPatient(nom, prenom, telephone, motDePasse, idPatient);
                  Navigator.of(context).pop();
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Erreur'),
                        content: Text('Échec de l\'enregistrement du patient. Veuillez réessayer.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Fermer'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  void _deletePatientDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer un Patient'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(patients.length, (index) {
                return ListTile(
                  title: Text(patients[index].nom),
                  onTap: () {
                    _confirmDeletePatientDialog(context, patients[index].idPatient);
                  },
                );
              }),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeletePatientDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Êtes-vous sûr de vouloir supprimer ce patient ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                await deletePatient(id);
                Navigator.of(context).pop();
              },
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}
