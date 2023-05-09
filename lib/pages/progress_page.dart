import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:nutri_app/main.dart';
import 'package:nutri_app/pages/home_page.dart';
//import 'package:horizontal_indicator/horizontal_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:nutri_app/variables/global.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  //macros si puede ser será un array de double [calorias, proteinas, carbohidratos, grasas]

  dynamic jsonData;

  @override
  void initState() {
    super.initState();
    fetchConsumo();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                SafeArea(child: NavigationScreen(page: screens[0])),
          ),
        );
      },
    );
  }

  Future<void> fetchConsumo() async {
    final response = await http.get(
      Uri.parse('${globalVariables.ipVM}/consumo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': globalVariables.tokenUser,
      },
    );
    if (response.statusCode == 200) {
      jsonData = jsonDecode(response.body);
      //print(jsonData);
    } else {
      throw Exception('Failed to connect to the server');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            padding: EdgeInsets.only(left: 5, top: 20, right: 25),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.55,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Color(0x34090F13),
                  offset: Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(children: <Widget>[
              Text(
                'Seguimiento Semanal',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              // Indicator(
              //   color: AppColors.contentColorYellow,
              //   text: 'Two',
              //   isSquare: false,
              //   size: touchedIndex == 1 ? 18 : 16,
              //   textColor: touchedIndex == 1
              //       ? AppColors.mainTextColor1
              //       : AppColors.mainTextColor3,
              // ),
              Center(child: LineChartWidget(nutrientes))
            ]),
          ),
        ),
    );
  }
}

class Nutriente {
  final double dia;
  final double cantidad;
  Nutriente({required this.dia, required this.cantidad});
}

//Método para mapear la clase, modificar según lleguen los datos del backend

List<Nutriente> get nutrientes {
  final data = <double>[20, 30, 20, 40, 10];
  return data
      .mapIndexed(((index, element) =>
          Nutriente(dia: index.toDouble(), cantidad: element)))
      .toList();
}

class LineChartWidget extends StatelessWidget {
  final List<Nutriente> nutrientes;
  const LineChartWidget(this.nutrientes, {Key? key}) : super(key: key);

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      fontFamily: 'SVN-Gilroy',
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(
          '${DateFormat.MMMd().format(DateTime.now().subtract(Duration(days: 4)))}',
          style: style,
        );
        break;
      case 1:
        text = Text(
          '${DateFormat.MMMd().format(DateTime.now().subtract(Duration(days: 3)))}',
          style: style,
        );
        break;
      case 2:
        text = Text(
          '${DateFormat.MMMd().format(DateTime.now().subtract(Duration(days: 2)))}',
          style: style,
        );
        break;
      case 3:
        text = Text(
          '${DateFormat.MMMd().format(DateTime.now().subtract(Duration(days: 1)))}',
          style: style,
        );
        break;
      case 4:
        text = Text(
          '${DateFormat.MMMd().format(DateTime.now())}',
          style: style,
        );
        break;
      default:
        text = const Text(
          '',
          style: style,
        );
        break;
    }
    return SideTitleWidget(axisSide: AxisSide.bottom, child: text);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(LineChartData(
          titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: bottomTitleWidgets,
                ),
              ),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))),
          borderData: FlBorderData(
            show: false,
          ),
          gridData: FlGridData(
            drawVerticalLine: false,
            drawHorizontalLine: true,
          ),
          lineBarsData: [
            LineChartBarData(
                spots: nutrientes
                    .map((nutriente) =>
                        FlSpot(nutriente.dia, nutriente.cantidad))
                    .toList(),
                isCurved: true,
                dotData: FlDotData(show: true)),
            LineChartBarData(
              spots: const [
                FlSpot(0, 4),
                FlSpot(1, 3.5),
                FlSpot(2, 4.5),
                FlSpot(3, 1),
                FlSpot(4, 4),
              ],
              isCurved: true,
              barWidth: 2,
              dotData: FlDotData(
                show: false,
              ),
            ),
          ])),
    );
  }
}