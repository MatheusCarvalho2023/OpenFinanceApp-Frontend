import 'package:open_finance_app/models/summary_model.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

/// Display the total cash amount for a specific account by calling a backend API.
class SummaryScreen extends StatefulWidget {
  final int clientID; // Client ID required to fetch data

  const SummaryScreen({
    super.key,
    required this.clientID, // Accepts client ID as input
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  late Future<SummaryData> _futureSummaryData;

  @override
  void initState() {
    super.initState();
    // Fetch data from the backend using clientID
    _futureSummaryData = fetchSummary(widget.clientID);
  }

  /// Function to call the backend API, passing the client ID.
  Future<SummaryData> fetchSummary(int clientID) async {
    // Update the URL to match the API endpoint
    final url = Uri.parse(
        "http://10.0.2.2:5280/clients/$clientID/PortfolioTotalAmount");

    try {
      // Sends a GET request to the backend API
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Parse JSON response into a Dart Map
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        // Convert JSON into the SummaryData model
        return SummaryData.fromJson(decoded);
      } else {
        throw Exception(
            "Failed to load summary data. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // There is no AppBar here as it is located on the WalletScreen
    return SafeArea(
      child: FutureBuilder<SummaryData>(
        future: _futureSummaryData,
        builder: (context, snapshot) {
          // Display a loading spinner while fetching data
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

  /// Build the content using LayoutBuilder + SingleChildScrollView
  Widget _buildSummaryContent(SummaryData summaryData) {
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  // PieChart takes up 50% of the available height
                  SizedBox(
                    height: constraints.maxHeight * 0.5,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            sections: _generateChartSections(summaryData),
                            centerSpaceRadius: 120, // Size of the center hole
                            sectionsSpace: 3,
                          ),
                        ),
                        Text(
                          numberFormat.format(totalGeral),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Container with padding, decoration, and a column of summary items
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
                        return _buildSummaryItem(
                            product.product, product.total);
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
        case "Funds":
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

  /// Build a summary item with a product name and its value
  Widget _buildSummaryItem(String product, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            product,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Text(
            "\$${value.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
