import 'package:http/http.dart' as http; // Importation du package HTTP
import 'dart:convert'; // Pour l'encodage/décodage JSON

class PatientService {
  final String baseUrl;

  PatientService({this.baseUrl = "http://localhost:8080"}); // URL de base par défaut

  // Méthode pour créer un patient
  Future<http.Response> createPatient(Map<String, dynamic> patientData) async {
    final url = Uri.parse('http://localhost:8080/api/patients');
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Spécifiez le type de contenu
      },
      body: jsonEncode(patientData), // Convertit les données en JSON
    );
  }
//Méthode pour verifier l'existence

  Future<bool> checkPatientExistence(String id_patient) async {
    final url = Uri.parse('$baseUrl/api/patients/exists/$id_patient');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return response.statusCode == 200;
  }

}
