import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:open_finance_app/api/api_endpoints.dart';
import 'package:open_finance_app/widgets/addconnection.dart';
import 'package:open_finance_app/widgets/connection_item.dart';
import 'package:open_finance_app/features/connections/add_connection_screen.dart';
import 'package:open_finance_app/models/connection_model.dart';
import 'package:open_finance_app/widgets/charts/pie_chart_widget.dart';

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
  late Future<Connection> _futureConnectionData;

  @override
  void initState() {
    super.initState();
    _futureConnectionData = _fetchConnectionData(widget.clientID);
  }

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

  Map<int, List<ConnectionElement>> _groupConnectionsByBank(
      Connection connectionData) {
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

  Future<void> _updateConnectionStatus(int connectionId, int clientId, bool status) async {
    final url = Uri.parse(ApiEndpoints.updateStatusConnection());
    
    try {
      final requestBody = {
        "clientID": clientId,
        "connectionID": connectionId,
        "status": status
      };
      
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      
      if (response.statusCode == 200) {
        // Successfully updated on the backend
        debugPrint('Connection status updated successfully');
      } else {
        debugPrint('Failed to update connection status: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        // If the API call fails, you might want to revert the UI change
        // or show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update connection status')),
        );
      }
    } catch (e) {
      debugPrint('Error updating connection status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
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
        child: FutureBuilder<Connection>(
          future: _futureConnectionData,
          builder: (context, AsyncSnapshot<Connection> snapshot) {
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

  Widget _buildConnectionsContent(Connection connectionData) {
    final numberFormat = NumberFormat.currency(symbol: '\$');

    // Group connections by bank
    final groupedConnections = _groupConnectionsByBank(connectionData);

    // Create chart data for the pie chart
    final List<ChartData> chartData = [];
    final List<Color> bankColors = [
      AppColors.primaryColor20,
      AppColors.primaryColor30,
      AppColors.primaryColor40,
      AppColors.primaryColor50,
    ];

    int colorIndex = 0;
    double totalAmount = 0;

    for (var entry in groupedConnections.entries) {
      final bankConnections = entry.value;
      // Only include active connections in the chart total
      double bankTotal = bankConnections
          .where((connection) => connection.isActive == true)
          .fold(0, (sum, connection) => sum + (connection.connectionAmount ?? 0));

      // Only add to chart if the bank has active connections with non-zero amount
      if (bankTotal > 0) {
        totalAmount += bankTotal;

        chartData.add(ChartData(
          value: bankTotal,
          color: bankColors[colorIndex % bankColors.length],
        ));

        colorIndex++;
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Found RefreshIndicator is used to refresh screen
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _futureConnectionData = _fetchConnectionData(widget.clientID);
            });
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    child: PieChartWidget(
                      data: chartData,
                      centerSpaceRadius: 100,
                      sectionRadius: 50,
                      sectionsSpace: 3,
                      centerText: numberFormat.format(totalAmount),
                      height: constraints.maxHeight * 0.4,
                      width: constraints.maxWidth * 0.9,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: _groupConnectionsByBank(connectionData)
                          .entries
                          .map((entry) {
                        ConnectionElement primaryConnection = entry.value.first;
                        IconData iconData = Icons.account_balance;

                        double totalBankAmount = entry.value.fold(
                            0,
                            (sum, connection) =>
                                sum + (connection.connectionAmount ?? 0));

                        final formattedBalance =
                            numberFormat.format(totalBankAmount);

                        bool isActive =
                            entry.value.any((conn) => conn.isActive == true);

                        return ConnectionItem(
                          iconData: iconData,
                          bankName:
                              primaryConnection.bankName ?? "Unknown Bank",
                          // Only show active accounts in the main balance display
                          totalAccountBalance: numberFormat.format(entry.value
                              .where((conn) => conn.isActive == true)
                              .fold(0.0, (sum, conn) => sum + (conn.connectionAmount ?? 0))),
                          switchValue: isActive,
                          onSwitchChanged: (newValue) {
                            // TODO: Implement API call to update connection status on switch change
                          },
                          drawerContent: [
                            ...entry.value.map((account) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Account #${account.accountNumber}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Balance:"),
                                      Text(numberFormat.format(
                                          account.connectionAmount ?? 0)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("% of connection:"),
                                      Text(
                                          "${account.connectionPercentage?.toStringAsFixed(2) ?? 0}%"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Enable account",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Transform.scale(
                                        scale: 0.75,
                                        child: Switch(
                                          value: account.isActive ?? false,
                                          onChanged: (value) {
                                            // Update the local state immediately for UI feedback
                                            setState(() {
                                              // Find and update the specific account
                                              for (var conn in connectionData.connections) {
                                                if (conn.connectionId == account.connectionId) {
                                                  conn.isActive = value;
                                                }
                                              }
                                              // Refresh the UI
                                              _futureConnectionData = Future.value(connectionData);
                                            });
                                            
                                            // Make the API call to update account status on the backend
                                            _updateConnectionStatus(account.connectionId!, widget.clientID, value);
                                          },
                                          activeColor: AppColors.primaryColor,
                                        ),
                                      ),
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
                  AddConnectionButton(onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddConnectionScreen(
                          clientID: widget.clientID,
                        ),
                      ),
                    );

                    if (result == true) {
                      setState(() {
                        _futureConnectionData =
                            _fetchConnectionData(widget.clientID);
                      });
                    }
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
