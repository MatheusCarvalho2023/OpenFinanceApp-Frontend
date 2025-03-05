import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:open_finance_app/models/summary_model.dart';
import 'package:open_finance_app/api/api_endpoints.dart';
import 'package:open_finance_app/widgets/addconnection.dart';
import 'package:open_finance_app/widgets/connection_item.dart';
import 'package:open_finance_app/features/connections/add_connection_screen.dart';
import 'package:open_finance_app/models/connection_model.dart';

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
  late Future<Connection> _futureConnectionData;

  @override
  void initState() {
    super.initState();
    _futureSummaryData = _fetchSummaryData(widget.clientID);
    _futureConnectionData = _fetchConnectionData(widget.clientID);
  }

  // Fetch summary data from the API
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

 // Fetch connection data from the API
  Future<Connection> _fetchConnectionData(int clientID) async {
    final url = Uri.parse(ApiEndpoints.connections(clientID));

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return Connection.fromJson(decoded);
      } else {
        throw Exception(
            "Failed to load connection data. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching connection data: $e");
    }
  }
 
  // Group connections by bank ID
  Map<int, List<ConnectionElement>> _groupConnectionsByBank(Connection connectionData) {
    Map<int, List<ConnectionElement>> groupedConnections = {};
    
    for (var connection in connectionData.connections) {
      if (connection.bankId != null) {
        if (!groupedConnections.containsKey(connection.bankId)) {
          groupedConnections[connection.bankId!] = [];
        }
        groupedConnections[connection.bankId!]!.add(connection);
      }
    }
    
    return groupedConnections;
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
        child: FutureBuilder(
          future: Future.wait([_futureSummaryData, _futureConnectionData]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
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
              final summaryData = snapshot.data![0] as SummaryData;
              final connectionData = snapshot.data![1] as Connection;
              return _buildConnectionsContent(summaryData, connectionData);
            } else {
              return const Center(child: Text("No data available"));
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primaryColor,
        selectedItemColor: AppColors.secondaryColor,
        unselectedItemColor: AppColors.textSecondary,
        currentIndex: 1,
        onTap: (index) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.link),
            label: 'Connections',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionsContent(SummaryData summaryData, Connection connectionData) {
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
                // Pie chart section remains the same
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

                // Connection items container
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: _groupConnectionsByBank(connectionData).entries.map((entry) {
                      // Get the first connection to use for the main display
                      ConnectionElement primaryConnection = entry.value.first;
                      IconData iconData = Icons.account_balance;
                      
                      // Calculate total amount for all accounts from this bank
                      double totalBankAmount = entry.value.fold(
                        0, (sum, connection) => sum + (connection.connectionAmount ?? 0)
                      );
                      
                      final formattedBalance = numberFormat.format(totalBankAmount);
                      
                      // Check if any connections are active
                      bool isActive = entry.value.any((conn) => conn.isActive == true);

                      return ConnectionItem(
                        iconData: iconData,
                        bankName: primaryConnection.bankName ?? "Unknown Bank",
                        totalAccountBalance: formattedBalance,
                        switchValue: isActive,
                        onSwitchChanged: (newValue) {
                          // TODO: Implement API call to update connection status for all accounts
                        },
                        drawerContent: [
                          ...entry.value.map((account) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Account #${account.accountNumber}",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Balance:"),
                                    Text(numberFormat.format(account.connectionAmount ?? 0)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("% of connection:"),
                                    Text("${account.connectionPercentage?.toStringAsFixed(2) ?? 0}%"),
                                  ],
                                ),
                                const SizedBox(height: 16),
                              ],
                            );
                          }),
                        ],
                      );
                    }).toList(),
                  ),
                ),

                AddConnectionButton(onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddConnectionScreen(),
                    ),
                  );
                }),
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
