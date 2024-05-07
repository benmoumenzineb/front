import 'package:flutter/material.dart';
// Classe représentant un patient avec son nom et son état de glycémie
class Patient {
  final String fullName;
  final double glucoseLevel; // État de la glycémie du patient
  Patient({required this.fullName, required this.glucoseLevel});
}
class PatientsPage extends StatefulWidget {
  @override
  _PatientsPageState createState() => _PatientsPageState();
}
class _PatientsPageState extends State<PatientsPage> {
  List<Patient> patients = [
    Patient(fullName: 'Zineb Ben', glucoseLevel: 1.2),
    Patient(fullName: 'Essadia Bah', glucoseLevel: 1.5),
    // Ajoutez autant de patients que nécessaire
  ];
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
          // Renvoie un widget ListTile pour chaque patient
          return ListTile(
            title: Text('Patient ${index + 1}'),
            trailing: ElevatedButton(
              onPressed: () {
                // Action à effectuer lorsque le bouton "Voir Détails" est cliqué
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
              Text('Nom complet: ${patients[index].fullName}'),
              Text('État de glycémie: ${patients[index].glucoseLevel} mmol/L'),
              // Ajoutez d'autres informations détaillées ici si nécessaire
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
    TextEditingController fullNameController = TextEditingController();
    TextEditingController glucoseLevelController = TextEditingController();
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
                  controller: fullNameController,
                  decoration: InputDecoration(labelText: 'Nom complet'),
                ),
                TextField(
                  controller: glucoseLevelController,
                  decoration: InputDecoration(labelText: 'État de glycémie (mmol/L)'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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
              onPressed: () {
                String fullName = fullNameController.text.trim();
                double glucoseLevel = double.parse(glucoseLevelController.text.trim());
                Patient newPatient = Patient(fullName: fullName, glucoseLevel: glucoseLevel);
                setState(() {
                  patients.add(newPatient);
                });
                Navigator.of(context).pop();
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
                  title: Text(patients[index].fullName),
                  onTap: () {
                    setState(() {
                      patients.removeAt(index);
                    });
                    Navigator.of(context).pop();
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

}