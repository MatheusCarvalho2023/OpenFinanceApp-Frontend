import 'package:open_finance_app/models/summary_model.dart';
import 'package:open_finance_app/services/api_service.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:open_finance_app/widgets/product_summary.dart';

/// Display the total cash amount for a specific account by calling a backend API.
class SummaryScreen extends StatefulWidget {
  final int clientID; // Client ID required to fetch data

  // Constructor for SummaryScreen
  const SummaryScreen({
    super.key,
    required this.clientID, // Accepts client ID as input
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen>
    with SingleTickerProviderStateMixin {
  // Future holds the async result of fetching SummaryData.
  late Future<SummaryData> _futureSummaryData;
  late AnimationController _animationController;
  late Animation<double> _chartAnimation;

  @override
  void initState() {
    super.initState();
    // Fetch data from the backend using clientID
    _futureSummaryData = ApiService().fetchSummary(widget.clientID);

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create animations
    _chartAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset and start animations when tab becomes visible
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
    // There is no AppBar here as it is located on the WalletScreen
    return SafeArea(
      // FutureBuilder to handle the async fetching of data
      child: FutureBuilder<SummaryData>(
        future: _futureSummaryData,
        builder: (context, snapshot) {
          // Display a loading spinner while fetching data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // If an error occured, display the error message.
          else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          // If data has been fetched successfully, build the summary screen content.
          else if (snapshot.hasData) {
            final summaryData = snapshot.data!;
            return _buildSummaryContent(summaryData);
          }
          // In case there is no data available, show a default message.
          else {
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }

  /// Build the content using LayoutBuilder + SingleChildScrollView
  Widget _buildSummaryContent(SummaryData summaryData) {
    // Create a number format for currency, using the dollar symbol.
    final numberFormat = NumberFormat.currency(symbol: '\$');

    // Sum of all values to display in the center of the pie chart
    final totalGeral = summaryData.productTotals.fold<double>(
      0.0,
      (sum, prod) => sum + prod.total,
    );

    // LayoutBuilder was used to get the available dimensions.
    // SingleChildScrollView + ConstrainedBox to take up at least all the vertical space, allowing scrolling if needed.
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            // Ensure the minimum height is equal to the height of the screen
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              // Apply symmetric horizontal and vertical padding around the content.
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  // PieChart takes up 50% of the available height
                  SizedBox(
                    height: constraints.maxHeight * 0.5,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Animated pie chart
                        AnimatedBuilder(
                          animation: _chartAnimation,
                          builder: (context, child) {
                            return PieChart(
                              PieChartData(
                                sections: _generateChartSections(summaryData),
                                centerSpaceRadius: 120 * _chartAnimation.value,
                                sectionsSpace: 3,
                                startDegreeOffset:
                                    270 - (360 * _chartAnimation.value),
                                pieTouchData: PieTouchData(enabled: true),
                              ),
                              swapAnimationDuration:
                                  const Duration(milliseconds: 800),
                              swapAnimationCurve: Curves.easeInOutCubic,
                            );
                          },
                        ),
                        // Display the total currency value in the center with fade-in animation
                        FadeTransition(
                          opacity: _chartAnimation,
                          child: ScaleTransition(
                            scale: _chartAnimation,
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

                  // Space between the pie chart and the summary items.
                  const SizedBox(height: 20),

                  // Container to display individual summary items
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    // Create a list of summary items for each product using .map()
                    child: Column(
                      children: summaryData.productTotals.map((product) {
                        // Return a ProductSummary widget for each product.
                        return ProductSummary(
                            productName: product.product, value: product.total);
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

  /// Generate the sections for the PieChart associating each product with a color
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
      // Build the pie chart section
      return PieChartSectionData(
        value: product.total,
        color: color,
        radius: 50,
        showTitle: false,
      );
    }).toList();
  }
}
