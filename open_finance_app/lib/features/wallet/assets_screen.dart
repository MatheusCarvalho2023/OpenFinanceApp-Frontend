import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_finance_app/api/api_endpoints.dart';
import 'package:open_finance_app/models/assets_model.dart';
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
        // Map each productDetail to an AssetsCard widget
        children: products.map((prod) => AssetsCard(product: prod)).toList(),
      ),
    );
  }
}
