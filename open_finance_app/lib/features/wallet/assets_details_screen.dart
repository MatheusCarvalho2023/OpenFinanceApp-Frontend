import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_finance_app/models/assets_details_model.dart';
import 'package:open_finance_app/services/api_service.dart';
import 'package:open_finance_app/widgets/assets_card.dart';

/// AssetsDetailsScreen displays the details for a specific asset product.
/// It fetches detailed information for the provided client and product name.
class AssetsDetailsScreen extends StatefulWidget {
  /// The client ID used to fetch the asset details.
  final int clientID;

  /// The name of the product for which details are to be displayed.
  final String productName;

  /// Constructor for AssetsDetailsScreen.
  const AssetsDetailsScreen({
    super.key,
    required this.clientID,
    required this.productName,
  });

  @override
  State<AssetsDetailsScreen> createState() => _AssetsDetailsScreenState();
}

class _AssetsDetailsScreenState extends State<AssetsDetailsScreen> {
  // Future holding the asset details data.
  late Future<AssetsDetails> _futureAssetsDetails;

  @override
  void initState() {
    super.initState();
    // Initialize future to fetch asset details using the provided client ID.
    _futureAssetsDetails = ApiService().fetchAssetsDetails(widget.clientID);
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold with a consistent AppBar style and background.
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "${widget.productName} details",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      // Use SafeArea to avoid system UI overlaps.
      body: SafeArea(
        child: FutureBuilder<AssetsDetails>(
          future: _futureAssetsDetails,
          builder: (context, snapshot) {
            // Loading state: show spinner while waiting for data.
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Error state: display error message.
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (snapshot.hasData) {
              // Data successfully fetched, build content.
              final assetsDetails = snapshot.data!;
              return _buildDetailsContent(assetsDetails);
            } else {
              // No data available.
              return const Center(child: Text("No data available"));
            }
          },
        ),
      ),
    );
  }

  /// Builds the detailed content view for the selected asset product.
  /// Formats currency values and displays a list of asset items.
  Widget _buildDetailsContent(AssetsDetails assetsDetails) {
    // Format numbers as currency.
    final numberFormat = NumberFormat.currency(symbol: "\$");

    // Find the product that matches the selected product name.
    final product = assetsDetails.products.firstWhere(
      (p) => p.productName == widget.productName,
      orElse: () => assetsDetails.products[0],
    );

    // Extract list of asset items for the selected product.
    final items = product.items;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display number of stocks for the product.
          Text(
            "Number of stocks: ${product.numItems}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          // Display total amount for the product.
          Text(
            "Total amount: ${numberFormat.format(product.productTotalAmount)}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Display a list of asset cards for each item.
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                // Reuse AssetsCard widget for consistent styling.
                return AssetsCard(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}
