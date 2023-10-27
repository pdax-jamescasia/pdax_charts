// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:async';
import 'dart:math';

import 'package:pdax_charts/charts/data_point.dart';
import 'package:pdax_charts/charts/metadata_point.dart';
import 'package:pdax_charts/charts/single_chart.dart';
import 'package:pdax_charts/constants.dart';
import 'package:flutter/material.dart';

class AssetPerformanceWidget extends StatefulWidget {
  final LinearGradient? gradient;
  final TextStyle? textStyle;
  final Function(String period) fetchChartPricesCallback;
  final List<DataPoint> data;
  final double previousPrice;
  final Stream<double> currentPricestream;

  const AssetPerformanceWidget(
      {super.key,
      this.gradient,
      this.textStyle,
      required this.fetchChartPricesCallback,
      required this.data,
      required this.previousPrice,
      required this.currentPricestream});

  @override
  State<AssetPerformanceWidget> createState() => _AssetPerformanceWidgetState();
}

class _AssetPerformanceWidgetState extends State<AssetPerformanceWidget> {
  List<MetadataPoint> metadata = List.generate(70, (index) {
    // Create a DateTime object for x, e.g., with random timestamps
    return MetadataPoint((Random().nextDouble() - 0.5) * 60);
  });

  // in-widget state
  String selectedPeriod = Constants.TWENTYFOUR_HOURS;

  List<bool> selectedStatus = [true, false, false, false, false];
  Color selectedColor = Colors.black;
  Color unselectedColor = Colors.black54;
  double gap = 4;

  @override
  void initState() {
    super.initState();
  }

  List<String> getLabels(String period) {
    // Todo
    //calculate labels based on x-units from last data point
    Map<String, List<String>> periodToLabelsMap = {
      Constants.TWENTYFOUR_HOURS: ['12AM', '4AM', '8AM', '12PM', '4PM', '8PM'],
      Constants.SEVEN_DAYS: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      Constants.THIRTY_DAYS: ['12AM', '4AM', '8AM', '12PM', '4PM', '8PM'],
      Constants.NINETY_DAYS: ['12AM', '4AM', '8AM', '12PM', '4PM', '8PM'],
      Constants.ONE_YEAR: ['Jan', 'Apr', 'Jul', 'Aug', 'Oct', 'Dec'],
    };

    return periodToLabelsMap[period]!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SingleChart(
          selectedPeriod: selectedPeriod,
          data: widget.data,
          metadata: metadata,
          gradient: widget.gradient,
          labels: getLabels(selectedPeriod),
          previousPrice: 1,
          currentPriceStream: widget.currentPricestream,
          textStyle: widget.textStyle,
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: gap, vertical: 4),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  onTap: () {
                    setState(() {
                      selectedPeriod = Constants.TWENTYFOUR_HOURS;
                      widget
                          .fetchChartPricesCallback(Constants.TWENTYFOUR_HOURS);
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color: selectedPeriod == Constants.TWENTYFOUR_HOURS
                            ? Colors.grey.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Text(
                      Constants.TWENTYFOUR_HOURS,
                      style: widget.textStyle!.copyWith(
                          color: selectedPeriod == Constants.TWENTYFOUR_HOURS
                              ? selectedColor
                              : unselectedColor),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: gap, vertical: 4),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  onTap: () {
                    setState(() {
                      selectedPeriod = Constants.SEVEN_DAYS;
                      widget.fetchChartPricesCallback(Constants.SEVEN_DAYS);
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color: selectedPeriod == Constants.SEVEN_DAYS
                            ? Colors.grey.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Text(
                      Constants.SEVEN_DAYS,
                      style: widget.textStyle!.copyWith(
                          color: selectedPeriod == Constants.SEVEN_DAYS
                              ? selectedColor
                              : unselectedColor),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: gap, vertical: 4),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  onTap: () {
                    setState(() {
                      selectedPeriod = Constants.THIRTY_DAYS;
                      widget.fetchChartPricesCallback(Constants.THIRTY_DAYS);
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color: selectedPeriod == Constants.THIRTY_DAYS
                            ? Colors.grey.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Text(
                      Constants.THIRTY_DAYS,
                      style: widget.textStyle!.copyWith(
                          color: selectedPeriod == Constants.THIRTY_DAYS
                              ? selectedColor
                              : unselectedColor),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: gap, vertical: 4),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  onTap: () {
                    setState(() {
                      selectedPeriod = Constants.NINETY_DAYS;
                      widget.fetchChartPricesCallback(Constants.NINETY_DAYS);
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color: selectedPeriod == Constants.NINETY_DAYS
                            ? Colors.grey.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Text(
                      Constants.NINETY_DAYS,
                      style: widget.textStyle!.copyWith(
                          color: selectedPeriod == Constants.NINETY_DAYS
                              ? selectedColor
                              : unselectedColor),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: gap, vertical: 4),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  onTap: () {
                    setState(() {
                      selectedPeriod = Constants.ONE_YEAR;
                      widget.fetchChartPricesCallback(Constants.ONE_YEAR);
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color: selectedPeriod == Constants.ONE_YEAR
                            ? Colors.grey.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Text(
                      Constants.ONE_YEAR,
                      style: widget.textStyle!.copyWith(
                          color: selectedPeriod == Constants.ONE_YEAR
                              ? selectedColor
                              : unselectedColor),
                    ),
                  ),
                ),
              )
            ])
      ],
    );
  }
}
