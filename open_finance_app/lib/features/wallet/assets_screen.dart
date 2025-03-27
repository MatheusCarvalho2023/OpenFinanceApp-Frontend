import 'package:flutter/material.dart';
import 'package:open_finance_app/features/wallet/assets_details_screen.dart';
import 'package:open_finance_app/models/assets_model.dart';
import 'package:open_finance_app/services/api_service.dart';
import 'package:open_finance_app/widgets/assets_card.dart';

/// AssetsScreen displays a summary of asset products for the client.
/// It fetches the assets summary from the API and displays a list of products.
class AssetsScreen extends StatefulWidget {
  /// The client ID used to fetch the assets summary.
  final int clientID;

  /// Constructor for AssetsScreen.
  const AssetsScreen({super.key, required this.clientID});

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  // Future holding the assets summary data.
  late Future<AssetsSummary> _futureAssetsSummary;

  @override
  void initState() {
    super.initState();
    // Fetch the assets summary data from the backend using the client ID.
    _futureAssetsSummary = ApiService().fetchAssetsSummary(widget.clientID);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // FutureBuilder to handle asynchronous data fetching.
      child: FutureBuilder<AssetsSummary>(
        future: _futureAssetsSummary,
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
          }
          // If data has been successfully fetched, build the assets content.
          else if (snapshot.hasData) {
            final assetsSummary = snapshot.data!;
            return _buildAssetsContent(assetsSummary);
          } else {
            // Fallback message if no data is available.
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }

  /// Builds the content of the Assets screen including a list of asset products.
  Widget _buildAssetsContent(AssetsSummary assetsSummary) {
    // Retrieve list of products from the assets summary.
    final products = assetsSummary.productDetails;
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the number of asset products.
          Text(
            "Number of products: ${assetsSummary.numProducts}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          // Display the total amount of assets.
          Text(
            "Total amount: ${assetsSummary.totalAmount}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Build a scrollable list of asset cards for each product.
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return InkWell(
                  onTap: () {
                    // Navigate to the asset details screen when tapped.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AssetsDetailsScreen(
                          clientID: widget.clientID,
                          productName: product.productName,
                        ),
                      ),
                    );
                  },
                  child: AssetsCard(product: product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
