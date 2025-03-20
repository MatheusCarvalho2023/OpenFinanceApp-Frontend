import 'package:flutter/material.dart';
import 'package:open_finance_app/features/wallet/assets_details_screen.dart';
import 'package:open_finance_app/models/assets_model.dart';
import 'package:open_finance_app/services/api_service.dart';
import 'package:open_finance_app/widgets/assets_card.dart';

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
    _futureAssetsSummary = ApiService().fetchAssetsSummary(widget.clientID);
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
    // scrollable list of "assets_card" for each productDetail
    final products = assetsSummary.productDetails;
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Number of products: ${assetsSummary.numProducts}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            "Total amount: ${assetsSummary.totalAmount}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return InkWell(
                  onTap: () {
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
