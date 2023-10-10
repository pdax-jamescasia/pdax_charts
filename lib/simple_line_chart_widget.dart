import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:pdax_charts/charts/data_point.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class SimpleLineChartWidget extends StatelessWidget {
  final List<DataPoint> data;
  final Color? color;
  const SimpleLineChartWidget({super.key, required this.data, this.color});

  @override
  Widget build(BuildContext context) {
    return SfSparkLineChart(
        axisLineColor: Colors.transparent,
        color: color ?? Colors.blue,
        width: 4,
        data: data.map((e) => e.averagePrice).toList());
  }
}
