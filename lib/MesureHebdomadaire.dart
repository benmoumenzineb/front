import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

// Classe représentant un point de données de glucose
class GlucoseDataPoint {
  final DateTime dateTime;
  final double glucoseLevel;
  GlucoseDataPoint(this.dateTime, this.glucoseLevel);
}

// Tableau de bord de la glycémie
class MesureHebdomadaire extends StatefulWidget {
  const MesureHebdomadaire({Key? key}) : super(key: key);

  @override
  _MesureHebdomadaireState createState() => _MesureHebdomadaireState();
}

class _MesureHebdomadaireState extends State<MesureHebdomadaire> {
  List<GlucoseDataPoint> glucoseData = [];
  bool isLoading = true; // Pour indiquer si les données sont en cours de chargement
  bool hasError = false; // Pour indiquer s'il y a eu une erreur lors de la récupération des données

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  // Fonction pour récupérer les données de l'API
  void fetchDataFromAPI() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      var url = Uri.parse('http://localhost:8080/api/glucose/history?patientId=1'); // Modifiez avec l'URL de votre API
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse is List) {
          List<GlucoseDataPoint> data = jsonResponse.map((record) {
            return GlucoseDataPoint(
              DateTime.parse(record['recordedDate']),
              (record['glucoseLevel'] as num).toDouble(),
            );
          }).toList();

          setState(() {
            glucoseData = data;
            isLoading = false; // Les données ont été chargées avec succès
          });
        } else {
          throw Exception("Format de réponse inattendu");
        }
      } else {
        throw Exception("Erreur lors de la récupération des données");
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false; // Marquer comme terminé même en cas d'erreur
      });
      debugPrint("Erreur: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tableau de bord de la glycémie"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLoading)
              Center(child: CircularProgressIndicator()) // Afficher un indicateur de chargement pendant le chargement des données
            else if (hasError)
              Center(child: Text("Erreur lors de la récupération des données"))
            else if (glucoseData.isEmpty)
                Center(child: Text("Aucune donnée disponible"))
              else
                Expanded(
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: glucoseData.map((dataPoint) => FlSpot(
                            dataPoint.dateTime.millisecondsSinceEpoch.toDouble(),
                            dataPoint.glucoseLevel,
                          )).toList(),
                          isCurved: true,
                          barWidth: 4,
                          colors: glucoseData.map((dataPoint) => getColorForGlucoseLevel(dataPoint.glucoseLevel)).toList(),
                        ),
                      ],
                      minX: glucoseData.first.dateTime.millisecondsSinceEpoch.toDouble(),
                      maxX: glucoseData.last.dateTime.millisecondsSinceEpoch.toDouble(),
                      minY: 0,
                      maxY: 5,
                      borderData: FlBorderData(show: true),
                      gridData: FlGridData(show: true),
                      extraLinesData: ExtraLinesData(
                        horizontalLines: [
                          HorizontalLine(
                            y: 1.10,
                            color: Colors.red,
                            strokeWidth: 2,
                            dashArray: [5, 5],
                          ),
                          HorizontalLine(
                            y: 0.7,
                            color: Colors.green,
                            strokeWidth: 2,
                            dashArray: [5, 5],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  // Fonction pour obtenir la couleur selon le niveau de glucose
  Color getColorForGlucoseLevel(double glucoseLevel) {
    if (glucoseLevel > 1.10) {
      return Colors.red;
    } else if (glucoseLevel >= 0.7 && glucoseLevel <= 1.10) {
      return Colors.green;
    } else {
      return Colors.yellow;
    }
  }
}
