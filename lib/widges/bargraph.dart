import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class IndividualBar {
  final int x;  //posicion eje x
  final double y1; //posicion eje y

  IndividualBar({
    required this.x,
    required this.y1,
  });
}

class BarData {
  final double valor1dia1;
  final double valor1dia2;
  final double valor1dia3;
  final double valor1dia4;
  final double valor1dia5;
  final double valor1dia6;
  final double valor1dia7;

  BarData({
    required this.valor1dia1,
    required this.valor1dia2,
    required this.valor1dia3,
    required this.valor1dia4,
    required this.valor1dia5,
    required this.valor1dia6,
    required this.valor1dia7,
  });

  List<IndividualBar> barData = [];

  //Inicializar barData
  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y1: valor1dia1),
      IndividualBar(x: 1, y1: valor1dia2),
      IndividualBar(x: 2, y1: valor1dia3),
      IndividualBar(x: 3, y1: valor1dia4),
      IndividualBar(x: 4, y1: valor1dia5),
      IndividualBar(x: 5, y1: valor1dia6),
      IndividualBar(x: 6, y1: valor1dia7),
    ];
  }
}

class MyBarGraph extends StatefulWidget {
  const MyBarGraph({super.key, required this.sumario1, required this.objetivo, required this.tipo, required this.dias});
    
    final sumario1;  
    final double objetivo;
    final tipo;
    final List<String> dias;

  @override
  State<MyBarGraph> createState() => _MyBarGraphState();
}
List<String> dias = [];

class _MyBarGraphState extends State<MyBarGraph> {

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(
          '${DateFormat.MMMd().format(DateTime.now().subtract(Duration(days: 6)))}',
          style: style,
        );
        break;
      case 1:
        text = Text(
          '${DateFormat.MMMd().format(DateTime.now().subtract(Duration(days: 5)))}',
          style: style,
        );
        break;
      case 2:
        text = Text(
          '${DateFormat.MMMd().format(DateTime.now().subtract(Duration(days: 4)))}',
          style: style,
        );
        break;
      case 3:
        text = Text(
          '${DateFormat.MMMd().format(DateTime.now().subtract(Duration(days: 3)))}',
          style: style,
        );
        break;
      case 4:
        text = Text(
          '${DateFormat.MMMd().format(DateTime.now().subtract(Duration(days: 2)))}',
          style: style,
        );
        break;
      case 5:
        text = Text(
          '${DateFormat.MMMd().format(DateTime.now().subtract(Duration(days: 1)))}',
          style: style,
        );
        break;
      case 6:
        text = Text(
          '${DateFormat.MMMd().format(DateTime.now().subtract(Duration(days: 0)))}',
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
    return SideTitleWidget(
      child: text, 
      axisSide: meta.axisSide,
      space: 10,
      angle: pi/5,
    );
  }

  @override
  Widget build(BuildContext context) {
    
    //inicializar barData
    BarData myBarData;
    print(widget.sumario1);
    print(widget.dias);
    myBarData = BarData(
      valor1dia1: widget.sumario1[0], 
      valor1dia2: widget.sumario1[1], 
      valor1dia3: widget.sumario1[2], 
      valor1dia4: widget.sumario1[3],  
      valor1dia5: widget.sumario1[4],  
      valor1dia6: widget.sumario1[5],  
      valor1dia7: widget.sumario1[6],
    );
    myBarData.initializeBarData();
    
    //dias para el eje x:
    List<String> diasMal = (widget.dias).map((dia) => formatDate(dia)).toList();
    dias = (diasMal).map((dia) => formatDateStr(dia)).toList();
    print(dias);

    return AspectRatio(
      aspectRatio: 2,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: BarChart(
          BarChartData(
            maxY: widget.objetivo,
            minY: 0,
            gridData: FlGridData(
              show: true, 
            ),
            borderData: FlBorderData(
              show: false,
            ),
            titlesData: FlTitlesData(
              show: true,
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: (widget.tipo == 'superavitcalorico' || widget.tipo == 'deficitcalorico' || widget.tipo == 'caloriastbm')
                    ? 250 
                    : 5,
                  reservedSize: 40,
                ),
              ),
              bottomTitles: AxisTitles(
                drawBehindEverything: false,
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: bottomTitleWidgets,
                  reservedSize: 30,
                ),
              ),
            ),
            barGroups: myBarData.barData.map((data) => BarChartGroupData(
              x: data.x,
              barRods: [
                BarChartRodData(
                  toY: data.y1,
                  color: Color.fromARGB(255, 14, 144, 7),
                  width: 17,
                  borderRadius: BorderRadius.circular(5),
                  // borderSide: BorderSide(
                  //   width: 1,
                  // ),
                )
              ],
            )).toList(),
          ),
        ),
      ),
    );
  }
  String formatDate(String date) {
    if(date.contains('-')) {
      List<String> partes = date.split('-');
      return '${partes[2]}-${partes[1]}';
    } else {
      return date;
    }
  }

  String formatDateStr(String date) {
    if(date.contains('-')) {
      List<String> partes = date.split('-');
      if(partes[1] == '01') {
        partes[1] = 'En';
      } else if(partes[1] == '02') {
        partes[1] = 'Fe';
      } else if(partes[1] == '03') {
        partes[1] = 'Mz';
      } else if(partes[1] == '04') {
        partes[1] = 'Ab';
      } else if(partes[1] == '05') {
        partes[1] = 'My';
      } else if(partes[1] == '06') {
        partes[1] = 'Jn';
      } else if(partes[1] == '07') {
        partes[1] = 'Jl';
      } else if(partes[1] == '08') {
        partes[1] = 'Ag';
      } else if(partes[1] == '09') {
        partes[1] = 'Se';
      } else if(partes[1] == '10') {
        partes[1] = 'Oc';
      } else if(partes[1] == '11') {
        partes[1] = 'No';
      } else if(partes[1] == '12') {
        partes[1] = 'Di';
      }
      return '${partes[0]} ${partes[1]}';
    } else {
      return date;
    }
  }
}