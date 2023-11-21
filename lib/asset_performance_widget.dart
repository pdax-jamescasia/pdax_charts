// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:async';
import 'dart:math';

import 'package:pdax_charts/charts/data_point.dart';
import 'package:pdax_charts/charts/metadata_point.dart';
import 'package:pdax_charts/charts/single_chart.dart';
import 'package:pdax_charts/constants.dart';
import 'package:flutter/material.dart';
import 'package:pdax_charts/date_utils.dart';

class AssetPerformanceWidget extends StatefulWidget {
  final LinearGradient? gradient;
  final TextStyle textStyle;
  final Function(String period) fetchChartPricesCallback;
  final List<DataPoint> data;
  final num? previousPrice;
  final Stream<double> currentPricestream;
  final bool isFail;
  final bool isLoading;
  final bool showMax;
  const AssetPerformanceWidget(
      {super.key,
      this.gradient,
      required this.textStyle,
      required this.fetchChartPricesCallback,
      required this.isFail,
      required this.isLoading,
      required this.showMax,
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
  final double boxHeight = 380;

  @override
  void initState() {
    super.initState();
  }

  List<String> getLabels(String period, List<DataPoint> data) {
    if (data.isEmpty) return ['', ''];
    DateTime date1 =
        DateTime.fromMillisecondsSinceEpoch(data.first.startTimestampUnixMilli);
    DateTime date2 =
        DateTime.fromMillisecondsSinceEpoch(data.last.endTimestampUnixMilli);

    switch (period) {
      case Constants.TWENTYFOUR_HOURS:
        return [formatTimeOfDay(date1), formatTimeOfDay(date2)];
      case Constants.SEVEN_DAYS:
        return [formatDateMonth(date1), formatDateMonth(date2)];
      case Constants.THIRTY_DAYS:
        return [formatDateMonth(date1), formatDateMonth(date2)];
      case Constants.NINETY_DAYS:
        return [formatDateMonthYear(date1), formatDateMonthYear(date2)];
      case Constants.ONE_YEAR:
        return [formatMonthYear(date1), formatMonthYear(date2)];

      default:
        return ['', ''];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SingleChart(
          selectedPeriod: selectedPeriod,
          data: widget.data,
          metadata: metadata,
          gradient: widget.gradient,
          showMax: widget.showMax,
          isLoading: widget.isLoading,
          isFail: widget.isFail,
          labels: getLabels(selectedPeriod, widget.data),
          previousPrice: widget.previousPrice,
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
                      style: widget.textStyle.copyWith(
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
