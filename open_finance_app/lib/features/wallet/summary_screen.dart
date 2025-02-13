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

  // Constructor for SummaryScreen
  const SummaryScreen({
    super.key,
    required this.clientID, // Accepts client ID as input
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  // Future holds the async result of fetching SummaryData.
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
        // If the request is successful, decode the JSON response
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        // Convert JSON into the SummaryData model
        return SummaryData.fromJson(decoded);
      } else {
        // If the server did not return a 200 OK response, throw an exception
        throw Exception(
            "Failed to load summary data. Status: ${response.statusCode}");
      }
    } catch (e) {
      // Catch any network or parsing errors and throw an exception.
      throw Exception("Error fetching data: $e");
    }
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
                        // Render the pie chart using generated chart sections.
                        PieChart(
                          PieChartData(
                            sections: _generateChartSections(summaryData),
                            centerSpaceRadius: 120, // Size of the center hole
                            sectionsSpace:
                                3, // Space between pie chart sections.
                          ),
                        ),
                        // Display the total currency value in the center of the pie chart.
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
      // Build the pie chart section
      return PieChartSectionData(
        value: product.total,
        color: color,
        radius: 50,
        showTitle: false,
      );
    }).toList();
  }

  /// Builds a widget representing a summary item
  /// with the product name and its total value.
  Widget _buildSummaryItem(String product, double value) {
    return Padding(
      // Apply vertical padding between summary items.
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        // Arrange the product name and value on opposite ends of the row.
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Display the product name with bold formatting.
          Text(
            product,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          // Display the product total value formatted to 2 decimal places.
          Text(
            "\$${value.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
