import 'package:open_finance_app/models/summary_model.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
        "https://192.168.1.100:5280/clients/$clientID/PortifolioTotalAmount");

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
    return FutureBuilder<SummaryData>(
      future: _futureSummaryData, // Uses the Future returned by fetchSummary
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // Error state
        else if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        // Success state
        else if (snapshot.hasData) {
          final summaryData = snapshot.data!;
          return _buildSummaryContent(summaryData);
        } else {
          return const Center(child: Text("No data available"));
        }
      },
    );
  }

  /// Builds the UI showing the total cash amount, plus any other info.
  Widget _buildSummaryContent(SummaryData summaryData) {
    // Format the sendDate from the API response
    final formattedDate = DateFormat.yMMMd().format(summaryData.timestamp);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // A circle with the total amount
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.5,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formattedDate, // Display the formatted date
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$ ${summaryData.totalAmount.toStringAsFixed(2)}", // Display the total amount
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
