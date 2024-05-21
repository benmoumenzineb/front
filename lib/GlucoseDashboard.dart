import 'package:flutter/material.dart';
import 'package:front/MesureHebdomadaire.dart';
import 'package:front/main.dart';
import 'package:front/parametre.dart';
import 'package:front/partager.dart';
import 'package:front/ComptePatient.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
class GlucoseDataPoint {
  final DateTime dateTime;
  final double glucoseLevel;

  GlucoseDataPoint(this.dateTime, this.glucoseLevel);
}
class GlucoseDashboard extends StatefulWidget {
  const GlucoseDashboard({Key? key}) : super(key: key);
  @override
  _GlucoseDashboardState createState() => _GlucoseDashboardState();
}
class _GlucoseDashboardState extends State<GlucoseDashboard> {
  List<GlucoseDataPoint> glucoseData = [];
  bool showDetails = false;
  @override
  void initState() {
    super.initState();
    fetchDataFromAPI().then((data) {
      setState(() {
        glucoseData = data;
      });
    }).catchError((error) {
      print("Erreur lors de la récupération des données de glucose: $error");
    });
  }
  Future<List<GlucoseDataPoint>> fetchDataFromAPI() async {
    var url = Uri.parse('http://localhost:8080/api/current?patientId=1');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse is List) {
        return jsonResponse.map((record) {
          return GlucoseDataPoint(
            DateTime.parse(record['recordedDate']),
            (record['glucoseLevel'] as num).toDouble(),
          );
        }).toList();
      } else {
        throw Exception("Unexpected response format");
      }
    } else {
      throw Exception("Failed to fetch glucose data");
    }
  }
  Color getColorForGlucoseLevel(double glucoseLevel) {
    if (glucoseLevel > 1.10) {
      return Colors.red;
    } else if (glucoseLevel >= 0.7 && glucoseLevel <= 1.10) {
      return Colors.green;
    } else {
      return Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tableau de bord de la glycémie"),
        actions: [
          PopupMenuButton<int>(
            onSelected: (item) {
              switch (item) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MesureHebdomadaire()),
                  );
                  break;
                case 1:
                // Naviguer vers les paramètres
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ParametresPage()),
                  );
                  break;
                case 2:
                // Action pour les suggestions
                  break;
                case 3:
                // Naviguer vers la page des réseaux sociaux
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SocialMediaPage()),
                  );
                  break;
                case 4:
                // Naviguer vers la page de profil
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ComptePatient()),
                  );
                  break;
                case 5:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                  break;
              }
            },
            icon: Icon(Icons.dehaze),
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: [
                    Icon(Icons.dashboard),
                    SizedBox(width: 10),
                    Text("Mesures hebdomadaire"),
                  ],
                ),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 10),
                    Text("Paramètres"),
                  ],
                ),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline),
                    SizedBox(width: 10),
                    Text("Suggestion"),
                  ],
                ),
              ),
              const PopupMenuItem<int>(
                value: 3,
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 10),
                    Text("Partager"),
                  ],
                ),
              ),
              const PopupMenuItem<int>(
                value: 4,
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text("Profil"),
                  ],
                ),
              ),
              const PopupMenuItem<int>(
                value: 5,
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 10),
                    Text("Déconnexion"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Mesures de glycémie en temps réel",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: glucoseData.isNotEmpty
                  ? LineChart(
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
              )
                  : Center(child: Text("Pas de données disponibles")),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showDetails = !showDetails;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    showDetails ? "Masquer les détails" : "Afficher les détails",
                  ),
                  Icon(
                    showDetails ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
            if (showDetails && glucoseData.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: glucoseData.length,
                  itemBuilder: (context, index) {
                    final data = glucoseData[index];
                    final formattedDate = "${data.dateTime.day}/${data.dateTime.month}/${data.dateTime.year}";
                    final formattedTime = "${data.dateTime.hour}:${data.dateTime.minute}";

                    return ListTile(
                      title: Text("Niveau de glycémie : ${data.glucoseLevel}"),
                      subtitle: Text("Date : $formattedDate | Heure : $formattedTime"),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}


