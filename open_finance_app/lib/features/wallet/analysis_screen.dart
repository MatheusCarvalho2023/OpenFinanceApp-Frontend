import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:open_finance_app/services/api_service.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/models/profit_report_model.dart';
import 'package:open_finance_app/models/connection_model.dart';

/// AnalysisScreen displays a donut chart for connections distribution and a
/// line chart for monthly performance. It fetches data for profit reports and connections
/// from the API based on the provided client ID.
class AnalysisScreen extends StatefulWidget {
  /// The client ID used for fetching data from the API.
  final int clientID;

  /// Constructor for AnalysisScreen.
  const AnalysisScreen({super.key, required this.clientID});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller for chart animations.
  late AnimationController _animationController;
  // Curved animation for the pie (donut) chart.
  late Animation<double> _pieAnimation;
  // Future that holds profit report data from the API.
  late Future<ProfitReport> _futureProfitReport;
  // Future that holds connections data from the API.
  late Future<Connection> _futureConnections;

  // Colors used for the different slices in the donut chart.
  final List<Color> _pieColors = [
    AppColors.accentGreen,
    AppColors.accentRed,
    AppColors.accentYellow,
    AppColors.primaryColor70,
    AppColors.secondaryColor,
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controller with a duration of 1500ms.
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    // Create a curved animation for the donut chart.
    _pieAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    // Start fetching profit report and connection data.
    _futureProfitReport = ApiService().fetchProfitReport(widget.clientID);
    _futureConnections = ApiService().fetchConnections(widget.clientID);

    // Begin the animation.
    _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Restart animation each time the screen is displayed.
    _animationController.reset();
    _animationController.forward();
  }

  @override
  void dispose() {
    // Dispose of the animation controller to free resources.
    _animationController.dispose();
    super.dispose();
  }

  /// Calculates the Y-axis interval for the line chart based on the range.
  double _calculateInterval(double minY, double maxY) {
    final range = (maxY - minY).abs();
    if (range < 1) {
      return 0.5;
    } else if (range < 5) {
      return 1;
    } else if (range < 10) {
      return 2;
    } else if (range < 20) {
      return 4;
    } else if (range < 40) {
      return 5;
    } else {
      return 10;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen height for responsive layout.
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Column(
        children: [
          // Display the donut chart in the upper section.
          SizedBox(
            height: screenHeight * 0.4,
            child: FutureBuilder<Connection>(
              future: _futureConnections,
              builder: (context, snapshot) {
                // Show loading indicator while data is being fetched.
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Display error message if fetching fails.
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  // Show message if no data is available.
                  return const Center(child: Text('No data'));
                }
                // Build the animated donut chart with the connection data.
                return _buildAnimatedPieChart(snapshot.data!);
              },
            ),
          ),
          // Display the line chart in the remaining space.
          Expanded(
            child: FutureBuilder<ProfitReport>(
              future: _futureProfitReport,
              builder: (context, snapshot) {
                // Loading state.
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Error state.
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  // No data state.
                  return const Center(child: Text('No data'));
                }
                // Build the line chart using the fetched profit report data.
                return _buildLineChart(snapshot.data!);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the animated donut chart (Connections Distribution) without center text.
  /// Uses the [Connection] data to display the percentage distribution of connections.
  Widget _buildAnimatedPieChart(Connection connectionData) {
    final sections = <PieChartSectionData>[];
    final legendItems = <_LegendItem>[];

    // Calculate total connections amount.
    final total = connectionData.totalAmount ?? 0;
    if (connectionData.connections.isNotEmpty && total > 0) {
      int colorIndex = 0;
      // Iterate over each connection to create chart sections.
      for (final c in connectionData.connections) {
        final amount = c.connectionAmount ?? 0;
        if (amount <= 0) continue;
        // Cycle through predefined colors for each slice.
        final color = _pieColors[colorIndex % _pieColors.length];
        colorIndex++;
        final percentage = (amount / total) * 100;
        // Create a section for the donut chart.
        sections.add(
          PieChartSectionData(
            value: amount,
            color: color,
            title: '${percentage.toStringAsFixed(1)}%',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            titlePositionPercentageOffset: 0.55,
          ),
        );
        // Add corresponding legend item.
        legendItems.add(
          _LegendItem(
            color: color,
            label: c.bankName ?? 'Unknown',
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Title for the chart.
          const Text(
            'Connections Distribution',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Column(
              children: [
                // Animated builder to handle pie chart animation.
                Expanded(
                  child: AnimatedBuilder(
                    animation: _pieAnimation,
                    builder: (context, child) {
                      final animVal = _pieAnimation.value;
                      return PieChart(
                        PieChartData(
                          sections: sections
                              .map((section) => PieChartSectionData(
                                    value: section.value,
                                    color: section.color,
                                    title: section.title,
                                    radius: section.radius * animVal,
                                    titleStyle: section.titleStyle,
                                    titlePositionPercentageOffset:
                                        section.titlePositionPercentageOffset,
                                  ))
                              .toList(),
                          centerSpaceRadius: 60 * animVal,
                          sectionsSpace: 2,
                          startDegreeOffset: 270 - 360 * animVal,
                          pieTouchData: PieTouchData(enabled: true),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Legend displayed below the donut chart.
                Wrap(
                  spacing: 16,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: legendItems.map(_buildLegendItem).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the static line chart for monthly performance using profit report data.
  Widget _buildLineChart(ProfitReport profitReport) {
    final distinct = <ProfitByMonth>[];
    final used = <String>{};
    // Filter out duplicate report periods.
    for (final p in profitReport.profitReportByMonth) {
      if (!used.contains(p.reportPeriod)) {
        used.add(p.reportPeriod);
        distinct.add(p);
      }
    }
    // Sort data chronologically based on report period.
    distinct.sort((a, b) {
      final partsA = a.reportPeriod.split('-');
      final partsB = b.reportPeriod.split('-');
      if (partsA.length == 2 && partsB.length == 2) {
        final mA = int.tryParse(partsA[0]) ?? 0;
        final yA = int.tryParse(partsA[1]) ?? 0;
        final mB = int.tryParse(partsB[0]) ?? 0;
        final yB = int.tryParse(partsB[1]) ?? 0;
        return DateTime(yA, mA).compareTo(DateTime(yB, mB));
      }
      return 0;
    });
    // Limit the number of months to display.
    const maxMonths = 5;
    if (distinct.length > maxMonths) {
      distinct.removeRange(0, distinct.length - maxMonths);
    }
    final spots = <FlSpot>[];
    double minValue = double.infinity;
    double maxValue = -double.infinity;
    // Prepare data points for the line chart.
    for (int i = 0; i < distinct.length; i++) {
      final val = distinct[i].totalProfitLossPercentage;
      if (val < minValue) minValue = val;
      if (val > maxValue) maxValue = val;
      spots.add(FlSpot(i.toDouble(), val));
    }
    // Calculate padding and intervals for Y-axis.
    final range = (maxValue - minValue).abs();
    final topPad = range * 0.15;
    final bottomPad = range * 0.2;
    final chartMinY = minValue - bottomPad;
    final chartMaxY = maxValue + topPad;
    final intervalY = _calculateInterval(chartMinY, chartMaxY);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Title for the line chart.
          const Text(
            'Performance Trend (% Return)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                minY: chartMinY,
                maxY: chartMaxY,
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.white.withOpacity(0.8),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    bottom: BorderSide(color: Colors.black, width: 1),
                    left: BorderSide(color: Colors.black, width: 1),
                    right: BorderSide(color: Colors.transparent),
                    top: BorderSide(color: Colors.transparent),
                  ),
                ),
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 52,
                      interval: intervalY,
                      getTitlesWidget: (value, meta) {
                        final valInt = value.round();
                        return Text('$valInt%',
                            style: const TextStyle(fontSize: 14));
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 52,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= distinct.length) {
                          return const SizedBox();
                        }
                        final period = distinct[index].reportPeriod;
                        final parts = period.split('-');
                        if (parts.length == 2) {
                          final mm = int.tryParse(parts[0]) ?? 0;
                          final yyyy = int.tryParse(parts[1]) ?? 0;
                          final date = DateTime(yyyy, mm);
                          // Rotate text slightly for better readability.
                          return Transform.rotate(
                            angle: -math.pi / 12,
                            child: Text(
                              '${_monthAbbr(date.month)}-${date.year % 100}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }
                        return Transform.rotate(
                          angle: -math.pi / 12,
                          child: Text(period,
                              style: const TextStyle(fontSize: 14)),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.accentGreen,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the abbreviated month name given the month number.
  String _monthAbbr(int month) {
    const abbr = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return (month < 1 || month > 12) ? '' : abbr[month - 1];
  }

  /// Builds a legend item widget for the donut chart.
  Widget _buildLegendItem(_LegendItem item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Color indicator circle.
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: item.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        // Label for the legend item.
        Text(item.label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

/// Private model class for representing a legend item in the donut chart.
class _LegendItem {
  /// Color of the legend indicator.
  final Color color;

  /// Label for the legend item.
  final String label;

  _LegendItem({
    required this.color,
    required this.label,
  });
}
