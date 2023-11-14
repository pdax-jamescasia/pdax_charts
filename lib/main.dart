import 'dart:async';

import 'package:pdax_charts/asset_performance_widget.dart';
import 'package:pdax_charts/constants.dart';
import 'package:pdax_charts/simple_line_chart_widget.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'charts/data_point.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DataPoint> data = [];

  final LinearGradient gradientColors = const LinearGradient(
      colors: [Color.fromARGB(255, 154, 173, 250), Colors.white],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);
  TextStyle style = const TextStyle(
      fontSize: 14,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      color: Colors.black87);
  StreamController<double> currentPriceStreamController =
      StreamController<double>();

  final randomDataStream = Stream<double>.periodic(
    const Duration(seconds: 1),
    (count) =>
        Random().nextInt(100) *
        1.02, // Generates random integers between 0 and 99
  ).take(1000); // Limits the stream to 10 random values

  @override
  void initState() {
    currentPriceStreamController.addStream(randomDataStream).then((value) {
      // currentPriceStreamController.close();
    });
    setData(Constants.TWENTYFOUR_HOURS);
    super.initState();
  }

  List<DataPoint> getPriceCharts(String period) {
    List<DataPoint> data = List.generate(70, (index) {
      // Create a DateTime object for x, e.g., with random timestamps
      DateTime timestamp = DateTime.now().subtract(Duration(days: 50 - index));

      // Generate a random stock price for y
      double stockPrice = 100.0 * Random().nextDouble() +
          (index % 10) * Random().nextDouble() +
          (index ~/ 10) * 5.02 * Random().nextInt(6);
      double openPrice = stockPrice * 0.99;

      return DataPoint(openPrice, openPrice, openPrice, openPrice, stockPrice,
          timestamp.millisecondsSinceEpoch, timestamp.millisecondsSinceEpoch);
    });
    return data;
  }

  void setData(String period) {
    setState(() {
      data = getPriceCharts(period);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(children: [
          AssetPerformanceWidget(
            showMax: false,
            isFail: false,
            isLoading: false,
            gradient: gradientColors,
            currentPricestream: currentPriceStreamController.stream,
            textStyle: style,
            data: data,
            fetchChartPricesCallback: setData,
            previousPrice: 3,
          ),
          Container(
              width: 400,
              height: 140,
              color: Colors.grey.shade300,
              padding: const EdgeInsets.all(6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text('BTC'),
                  SimpleLineChartWidget(
                    data: data,
                    color: Colors.blue,
                  ),
                  const Text('1414514 Php')
                ],
              ))
        ]) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
