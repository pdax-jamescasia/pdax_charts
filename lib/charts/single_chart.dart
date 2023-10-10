import 'package:pdax_charts/charts/metadata_point.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'data_point.dart';
import 'dart:async';

class SingleChart extends StatefulWidget {
  /// Restrictions
  /// Data is the main data
  /// Metadata is for tooltip information for each datapoint. It shall have the same amount of entries for data.
  /// Labels is a list of strings. Does not have to be the same length as data.
  ///
  ///
  final List<DataPoint> data; //the x & y
  Stream<double> currentPriceStream; //local variable from a stream
  // final double? currentPrice;
  final List<MetadataPoint>? metadata; //tooltip information
  final List<String>? labels; // the x-labels
  final String selectedPeriod; //string format of selected period
  final LinearGradient? gradient;
  final num previousPrice;
  final TextStyle? textStyle;

  SingleChart(
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  double priceChange() {
    return 1;
  }

  double priceChangePct() {
    return 0.1;
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Price (${widget.selectedPeriod}) ago:',
                          style: widget.textStyle,
                        ),
                        Text(widget.previousPrice.toString(),
                            style: widget.textStyle)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Current price:', style: widget.textStyle),
                        snapshot.hasData
                            ? Text(snapshot.data.toString(),
                                style: widget.textStyle)
                            : Text('Loading prices', style: widget.textStyle)
                        // if (snapshot.hasData) {
                        //       return ;
                        //     } else {
                        //       return Text('Loading prices');
                        //     }
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Price change:', style: widget.textStyle),
                        (snapshot.hasData)
                            ? Text('($priceChangePct %) P$priceChange',
                                style: widget.textStyle)
                            : Text('Loading prices', style: widget.textStyle)
                      ],
                    )
                  ],
                );
              }),
        ),
        SfCartesianChart(
            borderWidth: 0,
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            primaryXAxis: NumericAxis(isVisible: false),
            primaryYAxis: NumericAxis(isVisible: false),
            legend: const Legend(isVisible: false),
            tooltipBehavior: TooltipBehavior(
                enable: true,
                elevation: 6,
                shadowColor: Colors.black,
                tooltipPosition: TooltipPosition.auto,
                color: const Color.fromARGB(255, 236, 236, 236),
                canShowMarker: true,
                builder: (data, point, series, pointIndex, seriesIndex) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 3),
                      child: widget.metadata![pointIndex].delta >= 0
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.arrow_drop_up,
                                  size: 24,
                                  color: Colors.green,
                                ),
                                Text(
                                  '${widget.metadata![pointIndex].delta.toStringAsFixed(2)} %',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontFamily: widget.textStyle!.fontFamily,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.arrow_drop_down,
                                  size: 24,
                                  color: Colors.red,
                                ),
                                Text(
                                  '${widget.metadata![pointIndex].delta.toStringAsFixed(2)} %',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: widget.textStyle!.fontFamily,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ));
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
                          data.averagePrice.toStringAsFixed(2),
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
