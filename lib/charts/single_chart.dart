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
  final num? previousPrice;
  final TextStyle textStyle;
  final bool showMax;
  final bool isLoading;
  final bool isFail;
  get isEmpty => data.isEmpty;
  final double boxHeight = 300;
  const SingleChart(
      {super.key,
      required this.data,
      required this.selectedPeriod,
      required this.previousPrice,
      required this.currentPriceStream,
      required this.isLoading,
      required this.isFail,
      required this.showMax,
      required this.textStyle,
      this.metadata,
      this.labels,
      this.gradient});

  @override
  State<SingleChart> createState() => _SingleChartState();
}

class _SingleChartState extends State<SingleChart> {
  String formatAmount(num? amount) {
    NumberFormat currencyFormat;
    if (amount == null) {
      return "0.0";
    }
    if (amount.abs() > 100) {
      currencyFormat =
          NumberFormat.currency(locale: 'en_US', symbol: '₱', decimalDigits: 2);
    } else if (amount.abs() > 1) {
      currencyFormat =
          NumberFormat.currency(locale: 'en_US', symbol: '₱', decimalDigits: 3);
    } else if (amount.abs() > 0.01) {
      currencyFormat =
          NumberFormat.currency(locale: 'en_US', symbol: '₱', decimalDigits: 4);
    } else {
      currencyFormat =
          NumberFormat.currency(locale: 'en_US', symbol: '₱', decimalDigits: 8);
    }
    return currencyFormat.format(amount);
  }

  // function for getting the representative (middle) time for any period
  String getMiddleTime(int startMillis, int endMillis) {
    int middleMillis = (startMillis + endMillis) ~/ 2;

    DateTime date = DateTime.fromMillisecondsSinceEpoch(middleMillis);
    switch (widget.selectedPeriod) {
      case Constants.TWENTYFOUR_HOURS:
        return "${Constants.months[date.month]} ${date.day} ${date.year} ${date.hour}:${date.minute}";
      case Constants.SEVEN_DAYS:
        return "${Constants.months[date.month]} ${date.day}  ${date.year} ${date.hour}:00";

      case Constants.THIRTY_DAYS:
        return "${Constants.months[date.month]} ${date.day} ${date.year}";
      case Constants.NINETY_DAYS:
        return "${Constants.months[date.month]} ${date.day} ${date.year}";
      case Constants.ONE_YEAR:
        return "${Constants.months[date.month]} ${date.year}";

      default:
        return "";
    }
  }

  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
        shouldAlwaysShow: true,
        enable: true,
        elevation: 6,
        shadowColor: Colors.black,
        tooltipPosition: TooltipPosition.pointer,
        color: const Color.fromARGB(255, 249, 249, 249),
        canShowMarker: true,
        builder: (data, point, series, pointIndex, seriesIndex) {
          try {
            return Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    formatAmount(widget.data[pointIndex].averagePrice),
                    style: TextStyle(
                        color: Colors.blue,
                        fontFamily: widget.textStyle.fontFamily,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    getMiddleTime(
                        widget.data[pointIndex].startTimestampUnixMilli,
                        widget.data[pointIndex].endTimestampUnixMilli),
                    style: TextStyle(
                        fontFamily: widget.textStyle.fontFamily,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            );
          } on Exception catch (_) {
            return const SizedBox();
          }
        });

    // currencyFormat.maximumFractionDigits = 2;
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(milliseconds: 2000), () {
        try {
          _tooltipBehavior.showByIndex(0, widget.data.length - 1);
        } catch (e) {
          //
        }
      });
    });
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
                if (snapshot.data != null) {
                  double priceChange =
                      (snapshot.data ?? 1) - (widget.previousPrice ?? 1);
                  double priceChangePct =
                      priceChange * 100 / (widget.previousPrice ?? 1);

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
                            Text(
                                widget.isLoading
                                    ? 'Loading Price'
                                    : formatAmount(widget.previousPrice),
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
                                ? Text(formatAmount(snapshot.data!),
                                    style: widget.textStyle)
                                : Text('Loading prices',
                                    style: widget.textStyle)
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
                                    '(${priceChangePct > 0 ? '+' : ''}${priceChangePct.toStringAsFixed(2)} %) ${formatAmount(priceChange)}',
                                    style: widget.textStyle.copyWith(
                                        color: priceChangePct.isNegative
                                            ? Colors.red
                                            : priceChangePct > 0
                                                ? Colors.green
                                                : widget.textStyle.color))
                                : Text('Loading prices',
                                    style: widget.textStyle)
                          ],
                        ),
                      )
                    ],
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const SizedBox(
                    height: 100,
                    child: Center(
                      child: Text('Loading prices.'),
                    ),
                  );
                } else {
                  return const SizedBox(
                    height: 100,
                    child: Center(
                      child: Text(
                          'Failed fetching prices. Please try again later'),
                    ),
                  );
                }
              }),
        ),
        if ([Constants.TWENTYFOUR_HOURS, Constants.SEVEN_DAYS]
            .contains(widget.selectedPeriod))
          SizedBox(
            height: widget.boxHeight,
            child: Center(
              child: Text('No data available for ${widget.selectedPeriod}'),
            ),
          )
        else if (widget.isFail)
          SizedBox(
            height: widget.boxHeight,
            child: const Center(
              child: Text('Failed fetching data. Please try again later.'),
            ),
          )
        else if (widget.isLoading)
          SizedBox(
              height: widget.boxHeight,
              child: const Center(child: CircularProgressIndicator()))
        else if (widget.isEmpty)
          SizedBox(
            height: widget.boxHeight,
            child: const Center(
              child: Text('No data retrieved.'),
            ),
          )
        else
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SfCartesianChart(
                      borderWidth: 0,
                      plotAreaBorderColor: Colors.transparent,
                      plotAreaBorderWidth: 0,
                      backgroundColor: Colors.transparent,
                      borderColor: Colors.transparent,
                      primaryXAxis: const NumericAxis(
                        isVisible: false,
                        minorTickLines: MinorTickLines(size: 0),
                        // majorTickLines: const MajorTickLines(size: 0),
                      ),
                      primaryYAxis: const NumericAxis(isVisible: false),
                      legend: const Legend(isVisible: false),
                      tooltipBehavior: _tooltipBehavior,
                      series: <CartesianSeries>[
                        AreaSeries<DataPoint, dynamic>(
                            dataSource: widget.data,
                            gradient: widget.gradient,
                            enableTooltip: true,
                            xValueMapper: (DataPoint d, _) =>
                                d.startTimestampUnixMilli,
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
                              builder: (data, point, series, pointIndex,
                                  seriesIndex) {
                                if (!widget.showMax) {
                                  return const SizedBox();
                                } else if ([maxIdx, minIdx]
                                    .contains(pointIndex)) {
                                  return Text(
                                    formatAmount(data.averagePrice),
                                    style: widget.textStyle,
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ))
                      ]),
                  Positioned(
                    bottom: 14,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: widget.data.map((dataPoint) {
                          return Container(
                            width: 1,
                            height: 6,
                            color: Colors.grey,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: widget.labels!
                      .map((label) => Text(
                            label,
                            style: widget.textStyle,
                          ))
                      .toList(),
                ),
              )
            ],
          ),
      ],
    );
  }
}
