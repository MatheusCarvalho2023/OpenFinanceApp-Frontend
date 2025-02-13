import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_finance_app/api/api_endpoints.dart';
import 'package:open_finance_app/models/assets_model.dart';
import 'package:intl/intl.dart';
import 'package:open_finance_app/theme/colors.dart';

class AssetsScreen extends StatefulWidget {
  final int clientID;

  const AssetsScreen(
      {super.key, required this.clientID}); // Accepts client ID as input

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  late Future<AssetsSummary> _futureAssetsSummary;

  @override
  void initState() {
    super.initState();
    // Fetch data from the backend using clientID
    _futureAssetsSummary = fetchAssetsSummary(widget.clientID);
  }

  /// Function to call the backend API, passing the client ID.
  Future<AssetsSummary> fetchAssetsSummary(int clientID) async {
    // Update the URL to match the API endpoint
    final url = Uri.parse(ApiEndpoints.assetsSummary(clientID));
    try {
      // Sends a GET request to the backend API
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Parse JSON into AssetsSummary
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return AssetsSummary.fromJson(decoded);
      } else {
        throw Exception("Failed to load assets data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching assets data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // FutureBuilder to handle the async fetching of data
      child: FutureBuilder<AssetsSummary>(
        future: _futureAssetsSummary,
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
          }
          // If data has been fetched successfully, build the summary screen content.
          else if (snapshot.hasData) {
            final assetsSummary = snapshot.data!;
            return _buildAssetsContent(assetsSummary);
          } else {
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }

  /// Build the content of the Assets screen
  Widget _buildAssetsContent(AssetsSummary assetsSummary) {
    // A scrollable list of "cards" for each productDetail
    final products = assetsSummary.productDetails;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        // Map each productDetail to a card
        children: products.map((prod) => _buildProductCard(prod)).toList(),
      ),
    );
  }

  /// Card layout for each ProductDetail
  Widget _buildProductCard(ProductDetail product) {
    final numberFormat = NumberFormat.currency(symbol: "\$");
    return Container(
      margin: const EdgeInsets.only(bottom: 16), // Add margin between cards
      padding: const EdgeInsets.all(16), // Add padding inside the card
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12), // Rounded corners
        boxShadow: const [
          BoxShadow(color: AppColors.shadowColor, blurRadius: 4) // Add shadow
        ],
      ),
      child: Column(
        // Column to vertically align the content
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product name
          Text(
            product.productName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          const Divider(
              color: AppColors.dividerColor, thickness: 1), // Add a divider
          const SizedBox(
              height: 8), // Add space between the divider and content

          // Show product total
          Row(
            // Row to align the content horizontally
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total", style: TextStyle(fontSize: 16)),
              Text(
                numberFormat.format(product.prodTotal), // Format as currency
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),

          // Show portfolio percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("% of portfolio", style: TextStyle(fontSize: 16)),
              Text(
                "${product.portfolioPercentage.toStringAsFixed(2)}%", // Format as percentage
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
