import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:open_finance_app/services/api_service.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/models/profit_report_model.dart';
import 'package:open_finance_app/models/connection_model.dart';

/// This screen shows a donut chart for Connections Distribution and
/// a line chart for monthly performance.
class AnalysisScreen extends StatefulWidget {
  final int clientID;

  const AnalysisScreen({super.key, required this.clientID});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pieAnimation;
  late Future<ProfitReport> _futureProfitReport;
  late Future<Connection> _futureConnections;

  // Colors used for the donut slices
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

    // Set up animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pieAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    // Start fetching data
    _futureProfitReport = ApiService().fetchProfitReport(widget.clientID);
    _futureConnections = ApiService().fetchConnections(widget.clientID);

    // Begin animation
    _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Restart animation each time this screen is shown
    _animationController.reset();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Calculates the interval for the Y-axis of the line chart.
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
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Column(
        children: [
          // Donut Chart
          SizedBox(
            height: screenHeight * 0.4,
            child: FutureBuilder<Connection>(
              future: _futureConnections,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No data'));
                }
                return _buildAnimatedPieChart(snapshot.data!);
              },
            ),
          ),
          // Line Chart
          Expanded(
            child: FutureBuilder<ProfitReport>(
              future: _futureProfitReport,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No data'));
                }
                return _buildLineChart(snapshot.data!);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the animated donut chart (Connections Distribution) without center text.
  Widget _buildAnimatedPieChart(Connection connectionData) {
    final sections = <PieChartSectionData>[];
    final legendItems = <_LegendItem>[];

    final total = connectionData.totalAmount ?? 0;
    if (connectionData.connections.isNotEmpty && total > 0) {
      int colorIndex = 0;
      for (final c in connectionData.connections) {
        final amount = c.connectionAmount ?? 0;
        if (amount <= 0) continue;
        final color = _pieColors[colorIndex % _pieColors.length];
        colorIndex++;
        final percentage = (amount / total) * 100;
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
          const Text(
            'Connections Distribution',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Column(
              children: [
                // Animate the donut chart via AnimatedBuilder
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
                // Legend below the donut chart
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

  /// Builds the static line chart for monthly performance.
  Widget _buildLineChart(ProfitReport profitReport) {
    final distinct = <ProfitByMonth>[];
    final used = <String>{};
    for (final p in profitReport.profitReportByMonth) {
      if (!used.contains(p.reportPeriod)) {
        used.add(p.reportPeriod);
        distinct.add(p);
      }
    }
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
    const maxMonths = 5;
    if (distinct.length > maxMonths) {
      distinct.removeRange(0, distinct.length - maxMonths);
    }
    final spots = <FlSpot>[];
    double minValue = double.infinity;
    double maxValue = -double.infinity;
    for (int i = 0; i < distinct.length; i++) {
      final val = distinct[i].totalProfitLossPercentage;
      if (val < minValue) minValue = val;
      if (val > maxValue) maxValue = val;
      spots.add(FlSpot(i.toDouble(), val));
    }
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

  Widget _buildLegendItem(_LegendItem item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: item.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(item.label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

/// Model for the donut chart legend.
class _LegendItem {
  final Color color;
  final String label;

  _LegendItem({
    required this.color,
    required this.label,
  });
}
