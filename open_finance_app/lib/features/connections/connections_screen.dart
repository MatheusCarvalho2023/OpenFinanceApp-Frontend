import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:open_finance_app/models/summary_model.dart';
import 'package:open_finance_app/api/api_endpoints.dart';

class ConnectionsScreen extends StatefulWidget {
  final int clientID;

  const ConnectionsScreen({
    super.key,
    required this.clientID,
  });

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  late Future<SummaryData> _futureSummaryData;

  @override
  void initState() {
    super.initState();
    _futureSummaryData = _fetchSummaryData(widget.clientID);
  }

  Future<SummaryData> _fetchSummaryData(int clientID) async {
    final url = Uri.parse(ApiEndpoints.portfolioTotalAmount(clientID));

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Good morning, John!",
          style: TextStyle(color: AppColors.textSecondary),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<SummaryData>(
          future: _futureSummaryData,
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
              return _buildConnectionsContent(snapshot.data!);
            } else {
              return const Center(child: Text("No data available"));
            }
          },
        ),
      ),
    );
  }

  Widget _buildConnectionsContent(SummaryData summaryData) {
    final numberFormat = NumberFormat.currency(symbol: '\$');
    final totalGeral = summaryData.productTotals.fold<double>(
      0.0,
      (sum, prod) => sum + prod.total,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Pie chart section
                SizedBox(
                  height: constraints.maxHeight * 0.5,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sections: _generateChartSections(summaryData),
                          centerSpaceRadius: 120,
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
                
              ],
            ),
          ),
        );
      },
    );
  }

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
      return PieChartSectionData(
        value: product.total,
        color: color,
        radius: 50,
        showTitle: false,
      );
    }).toList();
  }
}