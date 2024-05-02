import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class GlucoseDashboard extends StatefulWidget {
  const GlucoseDashboard({super.key});

  @override
  _GlucoseDashboardState createState() => _GlucoseDashboardState();
}

class _GlucoseDashboardState extends State<GlucoseDashboard> {
  List<GlucoseDataPoint> glucoseData = [];

  @override
  void initState() {
    super.initState();
    startListeningToGlucoseSensor();
  }

  void startListeningToGlucoseSensor() {
    fetchDataFromAPI().then((data) {
      setState(() {
        glucoseData = data;
      });
    }).catchError((error) {
      print('Erreur lors de la récupération des données de glucose depuis l\'API: $error');
    });
  }

  // Updated method name using HTTP to fetch data from the API
  Future<List<GlucoseDataPoint>> fetchDataFromAPI() async {
    var url = Uri.parse('http://192.168.2.21:8080/api/glucose/current?patientId=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> glucoseRecords = jsonDecode(response.body);
      print('glucoseLevel= ');

      return glucoseRecords.map((record) {
        return GlucoseDataPoint(
          DateTime.parse(record['dateTime']),
          (record['glucoseLevel'] as num).toDouble(),
        );

      }).toList();


    } else {
      throw Exception('Failed to fetch glucose data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord de la glycémie'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GestureDetector(
          onDoubleTap: () {
            setState(() {
              // Réinitialiser le graphique à sa position initiale
              glucoseData.clear();
            });
          },
          child: InteractiveViewer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Mesures de glycémie en temps réel',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: glucoseData
                              .map((dataPoint) => FlSpot(
                            dataPoint.dateTime.millisecondsSinceEpoch.toDouble(),
                            dataPoint.glucoseLevel,
                          ))
                              .toList(),
                          isCurved: true,
                          barWidth: 4,
                          isStrokeCapRound: true,
                          belowBarData: BarAreaData(show: false),
                          colors: glucoseData.map((dataPoint) {
                            if (dataPoint.glucoseLevel > 1.10) {
                              return Colors.red;
                            } else if (dataPoint.glucoseLevel > 0.7) {
                              return Colors.blue;
                            } else {
                              return Colors.green;
                            }
                          }).toList(),
                        ),
                      ],
                      minX: glucoseData.isNotEmpty
                          ? glucoseData.first.dateTime.millisecondsSinceEpoch.toDouble()
                          : 0,
                      maxX: glucoseData.isNotEmpty
                          ? glucoseData.last.dateTime.millisecondsSinceEpoch.toDouble()
                          : 1,
                      minY: 0,
                      maxY: 5, // Maximum de glycémie
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          getTitles: (value) {
                            // Convertir la valeur x (millisecondes depuis l'époque) en objet DateTime
                            final dateTime =
                            DateTime.fromMillisecondsSinceEpoch(value.toInt());
                            // Formater l'heure et la date selon vos préférences
                            return '${dateTime.hour}:${dateTime.minute}\n${dateTime.day}/${dateTime.month}';
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          getTitles: (value) {
                            // Utiliser la valeur réelle de la glycémie
                            return '${value.toStringAsFixed(1)}';
                          },
                          margin: 8,
                          reservedSize: 30,
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      gridData: FlGridData(show: true),
                      extraLinesData: ExtraLinesData(
                        horizontalLines: [
                          HorizontalLine(
                            y: 1.10, // Valeur maximale de glycémie
                            color: Colors.red, // Couleur de la ligne
                            strokeWidth: 2, // Épaisseur de la ligne
                            dashArray: [5, 5], // Style de la ligne (pointillée)
                          ),
                          HorizontalLine(
                            y: 0.7, // Valeur minimale de glycémie
                            color: Colors.green, // Couleur de la ligne
                            strokeWidth: 2, // Épaisseur de la ligne
                            dashArray: [5, 5], // Style de la ligne (pointillée)
                          ),
                        ],
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

class GlucoseDataPoint {
  final DateTime dateTime;
  final double glucoseLevel;

  GlucoseDataPoint(this.dateTime, this.glucoseLevel);
}

void main() {
  runApp(MaterialApp(
    home: GlucoseDashboard(),
  ));
}