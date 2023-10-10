class DataPoint {
  DataPoint(
      this.openPrice,
      this.highPrice,
      this.lowPrice,
      this.closePrice,
      this.averagePrice,
      this.startTimestampUnixMilli,
      this.endTimestampUnixMilli);
  final double openPrice;
  final double highPrice;
  final double lowPrice;
  final double closePrice;
  final double averagePrice;
  final int startTimestampUnixMilli;
  final int endTimestampUnixMilli;
}
