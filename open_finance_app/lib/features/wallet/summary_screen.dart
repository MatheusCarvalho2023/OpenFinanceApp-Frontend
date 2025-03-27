import 'package:open_finance_app/models/summary_model.dart';
import 'package:open_finance_app/services/api_service.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:open_finance_app/widgets/product_summary.dart';

/// SummaryScreen displays the overall summary for a client's account.
/// It shows a pie chart of asset distribution and a detailed product summary.
class SummaryScreen extends StatefulWidget {
  /// The client ID used to fetch summary data.
  final int clientID;

  /// Constructor for SummaryScreen.
  const SummaryScreen({
    super.key,
    required this.clientID,
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen>
    with SingleTickerProviderStateMixin {
  // Future holding the summary data fetched from the API.
  late Future<SummaryData> _futureSummaryData;

  // Animation controller for pie chart animation.
  late AnimationController _animationController;
  // Curved animation for the pie chart.
  late Animation<double> _pieAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize future to fetch summary data using the client ID.
    _futureSummaryData = ApiService().fetchSummary(widget.clientID);

    // Initialize animation controller with a duration of 1200ms.
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create a curved animation for smooth transitions.
    _pieAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset and start the animation each time the screen becomes visible.
    _animationController.reset();
    _animationController.forward();
  }

  @override
  void dispose() {
    // Dispose the animation controller to free resources.
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // FutureBuilder to handle asynchronous fetching of summary data.
      child: FutureBuilder<SummaryData>(
        future: _futureSummaryData,
        builder: (context, snapshot) {
          // Show a loading spinner while data is being fetched.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Display an error message if fetching fails.
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData) {
            // Data fetched successfully; build the summary content.
            final summaryData = snapshot.data!;
            return _buildSummaryContent(summaryData);
          } else {
            // Fallback message if no data is available.
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }

  /// Builds the overall summary content including a pie chart and product summaries.
  Widget _buildSummaryContent(SummaryData summaryData) {
    // Format numbers as currency.
    final numberFormat = NumberFormat.currency(symbol: '\$');

    // Calculate total value from all product totals.
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
                  // Container for the animated pie chart; takes up about half of the height.
                  SizedBox(
                    height: constraints.maxHeight * 0.5,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // AnimatedBuilder for the pie chart animation.
                        AnimatedBuilder(
                          animation: _pieAnimation,
                          builder: (context, child) {
                            return PieChart(
                              PieChartData(
                                sections: _generateChartSections(summaryData),
                                // Animate the center hole of the pie chart.
                                centerSpaceRadius: 120 * _pieAnimation.value,
                                sectionsSpace: 3,
                                // Animate the "unfolding" of the pie chart.
                                startDegreeOffset:
                                    270 - (360 * _pieAnimation.value),
                                pieTouchData: PieTouchData(enabled: true),
                              ),
                            );
                          },
                        ),
                        // Center text displaying the total amount with fade and scale transitions.
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
                  // Container for the product summaries with styling.
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

  /// Generates the sections for the PieChart based on the product totals.
  List<PieChartSectionData> _generateChartSections(SummaryData summaryData) {
    return summaryData.productTotals.map((product) {
      // Determine color based on product type.
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
      // Return a chart section for the product.
      return PieChartSectionData(
        value: product.total,
        color: color,
        radius: 50,
        showTitle: false,
      );
    }).toList();
  }
}
