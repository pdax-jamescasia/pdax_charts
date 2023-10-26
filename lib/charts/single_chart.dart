import 'package:pdax_charts/charts/metadata_point.dart';
import 'package:flutter/material.dart';
import 'package:pdax_charts/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'data_point.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class SingleChart extends StatefulWidget {
  /// Restrictions
  /// Data is the main data
  /// Metadata is for tooltip information for each datapoint. It shall have the same amount of entries for data.
  /// Labels is a list of strings. Does not have to be the same length as data.
  ///
  ///
  final List<DataPoint> data; //the x & y
  final Stream<double> currentPriceStream; //local variable from a stream
  // final double? currentPrice;
  final List<MetadataPoint>? metadata; //tooltip information
  final List<String>? labels; // the x-labels
  final String selectedPeriod; //string format of selected period
  final LinearGradient? gradient;
  final num previousPrice;
  final TextStyle? textStyle;

  const SingleChart(
      {super.key,
      required this.data,
      required this.selectedPeriod,
      required this.previousPrice,
      required this.currentPriceStream,
      this.textStyle,
      this.metadata,
      this.labels,
      this.gradient});

  @override
  State<SingleChart> createState() => _SingleChartState();
}

class _SingleChartState extends State<SingleChart> {
  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'en_US', symbol: '₱', decimalDigits: 2);

  // function for getting the representative (middle) time for any period
  String getMiddleTime(int startMillis, int endMillis) {
    int middleMillis = ((startMillis + endMillis) / 2) as int;

    DateTime date = DateTime.fromMillisecondsSinceEpoch(middleMillis);
    switch (widget.selectedPeriod) {
      case Constants.TWENTYFOUR_HOURS:
        return "${Constants.months[date.month]} ${date.day} ${date.hour}:${date.minute}";
      case Constants.SEVEN_DAYS:
        return "${Constants.months[date.month]} ${date.day} ${date.hour}:00";

      case Constants.THIRTY_DAYS:
        return "${Constants.months[date.month]} ${date.day}";
      case Constants.NINETY_DAYS:
        return "${Constants.months[date.month]} ${date.day}";
      case Constants.ONE_YEAR:
        return "${Constants.months[date.month]} ${date.year}";

      default:
        return "";
    }
  }

  @override
  void initState() {
    currencyFormat.maximumFractionDigits = 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // calculate min max
    double max_ = double.negativeInfinity;
    double min_ = double.infinity;
    int maxIdx = 0;
    int minIdx = 0;

    widget.data.asMap().forEach((idx, dataPoint) {
      if (dataPoint.averagePrice < min_) {
        min_ = dataPoint.averagePrice;
        minIdx = idx;
      }
      if (dataPoint.averagePrice > max_) {
        max_ = dataPoint.averagePrice;
        maxIdx = idx;
      }
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: StreamBuilder<double>(
              stream: widget.currentPriceStream,
              builder: (context, snapshot) {
                double priceChange = snapshot.data! - widget.previousPrice;
                double priceChangePct =
                    priceChange * 100 / widget.previousPrice;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Price (${widget.selectedPeriod}) ago:',
                            style: widget.textStyle,
                          ),
                          Text(currencyFormat.format(widget.previousPrice),
                              style: widget.textStyle)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Current price:', style: widget.textStyle),
                          snapshot.hasData
                              ? Text(currencyFormat.format(snapshot.data!),
                                  style: widget.textStyle)
                              : Text('Loading prices', style: widget.textStyle)
                          // if (snapshot.hasData) {
                          //       return ;
                          //     } else {
                          //       return Text('Loading prices');
                          //     }
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Price change:', style: widget.textStyle),
                          (snapshot.hasData)
                              ? Text(
                                  '(${priceChangePct.toStringAsFixed(2)} %) ${currencyFormat.format(priceChange)}',
                                  style: widget.textStyle)
                              : Text('Loading prices', style: widget.textStyle)
                        ],
                      ),
                    )
                  ],
                );
              }),
        ),
        SfCartesianChart(
            borderWidth: 0,
            plotAreaBorderColor: Colors.transparent,
            plotAreaBorderWidth: 0,
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            primaryXAxis: NumericAxis(isVisible: false),
            primaryYAxis: NumericAxis(isVisible: false),
            legend: const Legend(isVisible: false),
            tooltipBehavior: TooltipBehavior(
                borderWidth: 0.3,
                borderColor: Colors.black,
                enable: true,
                elevation: 6,
                shadowColor: Colors.black,
                tooltipPosition: TooltipPosition.auto,
                color: const Color.fromARGB(255, 249, 249, 249),
                canShowMarker: true,
                builder: (data, point, series, pointIndex, seriesIndex) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 3),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            currencyFormat
                                .format(widget.data[pointIndex].averagePrice),
                            style: TextStyle(
                                color: Colors.blue,
                                fontFamily: widget.textStyle!.fontFamily,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            getMiddleTime(
                                widget.data[pointIndex].startTimestampUnixMilli,
                                widget.data[pointIndex].endTimestampUnixMilli),
                            style: TextStyle(
                                fontFamily: widget.textStyle!.fontFamily,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      )

                      //  widget.metadata![pointIndex].delta >= 0
                      //     ? Row(
                      //         mainAxisSize: MainAxisSize.min,
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: [
                      //           const Icon(
                      //             Icons.arrow_drop_up,
                      //             size: 24,
                      //             color: Colors.green,
                      //           ),
                      //           Text(
                      //             '${widget.metadata![pointIndex].delta.toStringAsFixed(2)} %',
                      //             style: TextStyle(
                      //                 color: Colors.green,
                      //                 fontFamily: widget.textStyle!.fontFamily,
                      //                 fontWeight: FontWeight.w400),
                      //           ),
                      //         ],
                      //       )
                      //     : Row(
                      //         mainAxisSize: MainAxisSize.min,
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: [
                      //           const Icon(
                      //             Icons.arrow_drop_down,
                      //             size: 24,
                      //             color: Colors.red,
                      //           ),
                      //           Text(
                      //             '${widget.metadata![pointIndex].delta.toStringAsFixed(2)} %',
                      //             style: TextStyle(
                      //                 color: Colors.red,
                      //                 fontFamily: widget.textStyle!.fontFamily,
                      //                 fontWeight: FontWeight.w400),
                      //           ),
                      //         ],
                      //       )

                      );
                }),
            series: <ChartSeries<DataPoint, dynamic>>[
              AreaSeries<DataPoint, dynamic>(
                  dataSource: widget.data,
                  gradient: widget.gradient,
                  xValueMapper: (DataPoint d, _) => d.startTimestampUnixMilli,
                  yValueMapper: (DataPoint d, _) => d.averagePrice,
                  borderWidth: 3,
                  borderColor: const Color.fromARGB(255, 3, 128, 230),
                  markerSettings: const MarkerSettings(
                      isVisible: false,
                      shape: DataMarkerType.circle,
                      color: Colors.black),
                  dataLabelSettings: DataLabelSettings(
                    overflowMode: OverflowMode.shift,
                    labelPosition: ChartDataLabelPosition.inside,
                    isVisible: true,
                    builder: (data, point, series, pointIndex, seriesIndex) {
                      if ([maxIdx, minIdx].contains(pointIndex)) {
                        return Text(
                          currencyFormat.format(data.averagePrice),
                          style: widget.textStyle,
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ))
            ]),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widget.labels!
              .map((label) => Text(
                    label,
                    style: widget.textStyle,
                  ))
              .toList(),
        )
      ],
    );
  }
}
