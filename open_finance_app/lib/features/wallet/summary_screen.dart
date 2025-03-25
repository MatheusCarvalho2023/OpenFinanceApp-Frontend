import 'package:open_finance_app/models/summary_model.dart';
import 'package:open_finance_app/services/api_service.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:open_finance_app/widgets/product_summary.dart';

/// Displays the total cash amount for a specific account by calling a backend API.
class SummaryScreen extends StatefulWidget {
  final int clientID; // Client ID required to fetch data

  const SummaryScreen({
    super.key,
    required this.clientID, // Accepts client ID as input
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen>
    with SingleTickerProviderStateMixin {
  // Future for fetching SummaryData
  late Future<SummaryData> _futureSummaryData;

  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _pieAnimation;

  @override
  void initState() {
    super.initState();

    // Fetch data from backend
    _futureSummaryData = ApiService().fetchSummary(widget.clientID);

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create a curved animation
    _pieAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Restart animations every time this screen becomes visible
    _animationController.reset();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // FutureBuilder to handle async fetching of data
      child: FutureBuilder<SummaryData>(
        future: _futureSummaryData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData) {
            final summaryData = snapshot.data!;
            return _buildSummaryContent(summaryData);
          } else {
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }

  /// Builds the layout with a pie chart and product summaries
  Widget _buildSummaryContent(SummaryData summaryData) {
    final numberFormat = NumberFormat.currency(symbol: '\$');

    // Sum of all values in the chart
    final totalGeral = summaryData.productTotals.fold<double>(
      0.0,
      (sum, prod) => sum + prod.total,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  // Takes up about half the available height
                  SizedBox(
                    height: constraints.maxHeight * 0.5,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Use AnimatedBuilder to animate the pie chart
                        AnimatedBuilder(
                          animation: _pieAnimation,
                          builder: (context, child) {
                            return PieChart(
                              PieChartData(
                                sections: _generateChartSections(summaryData),
                                // Animate center hole
                                centerSpaceRadius: 120 * _pieAnimation.value,
                                sectionsSpace: 3,
                                // Animate the "unfolding"
                                startDegreeOffset:
                                    270 - (360 * _pieAnimation.value),
                                pieTouchData: PieTouchData(enabled: true),
                              ),
                            );
                          },
                        ),
                        // Center text: fade + scale transitions
                        FadeTransition(
                          opacity: _pieAnimation,
                          child: ScaleTransition(
                            scale: _pieAnimation,
                            child: Text(
                              numberFormat.format(totalGeral),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Product summaries
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: Column(
                      children: summaryData.productTotals.map((product) {
                        return ProductSummary(
                          productName: product.product,
                          value: product.total,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Generates the sections for the PieChart
  List<PieChartSectionData> _generateChartSections(SummaryData summaryData) {
    return summaryData.productTotals.map((product) {
      Color color;
      switch (product.product) {
        case "Cash":
          color = AppColors.accentGreen;
          break;
        case "Stock":
          color = AppColors.accentYellow;
          break;
        case "Mutual Fund":
          color = AppColors.accentRed;
          break;
        default:
          color = Colors.blueGrey;
      }
      return PieChartSectionData(
        value: product.total,
        color: color,
        radius: 50,
        showTitle: false,
      );
    }).toList();
  }
}
