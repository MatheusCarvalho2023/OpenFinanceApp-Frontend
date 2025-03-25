import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_finance_app/models/assets_details_model.dart';
import 'package:open_finance_app/services/api_service.dart';
import 'package:open_finance_app/widgets/assets_card.dart';

class AssetsDetailsScreen extends StatefulWidget {
  final int clientID;
  final String productName;

  const AssetsDetailsScreen({
    super.key,
    required this.clientID,
    required this.productName,
  });

  @override
  State<AssetsDetailsScreen> createState() => _AssetsDetailsScreenState();
}

class _AssetsDetailsScreenState extends State<AssetsDetailsScreen> {
  late Future<AssetsDetails> _futureAssetsDetails;

  @override
  void initState() {
    super.initState();
    _futureAssetsDetails = ApiService().fetchAssetsDetails(widget.clientID);
  }

  @override
  Widget build(BuildContext context) {
    // Keeps the same background color and style of the AppBar without repeating BottomNavigation.
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
      body: SafeArea(
        child: FutureBuilder<AssetsDetails>(
          future: _futureAssetsDetails,
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
              final assetsDetails = snapshot.data!;
              return _buildDetailsContent(assetsDetails);
            } else {
              return const Center(child: Text("No data available"));
            }
          },
        ),
      ),
    );
  }

  /// Builds the content of the screen with the details of the selected product.
  Widget _buildDetailsContent(AssetsDetails assetsDetails) {
    final numberFormat = NumberFormat.currency(symbol: "\$");

    // Find the product that matches the selected product name
    final product = assetsDetails.products.firstWhere(
      (p) => p.productName == widget.productName,
      orElse: () => assetsDetails.products[0],
    );

    // Items list for the selected product
    final items = product.items;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Number of stocks: ${product.numItems}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            "Total amount: ${numberFormat.format(product.productTotalAmount)}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                // This is the same card used in the assets_screen.dart
                return AssetsCard(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}
