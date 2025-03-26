/// Screen that displays and manages a client's financial connections.
///
/// This screen shows a visual overview of the client's connected accounts using a pie chart,
/// lists all bank connections, and provides functionality to add new connections or
/// toggle existing ones on/off.
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

/// A screen widget that displays a client's financial connections.
///
/// This screen shows an overview of connected bank accounts, their balances,
/// and allows the user to manage these connections including enabling/disabling them.
class ConnectionsScreen extends StatefulWidget {
  /// The unique identifier of the client whose connections are displayed
  final int clientID;

  const ConnectionsScreen({
    super.key,
    required this.clientID,
  });

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

/// The state class for the ConnectionsScreen.
class _ConnectionsScreenState extends State<ConnectionsScreen> {
  /// Future that holds the connection data to be displayed
  late Future<Connection> _futureConnectionData;

  @override
  void initState() {
    super.initState();
    _futureConnectionData = _fetchConnectionData(widget.clientID);
  }

  /// Fetches connection data for a specific client from the API.
  ///
  /// [clientID] The unique identifier of the client whose connections to fetch.
  /// Returns a Future that resolves to the Connection object containing all connection data.
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

  /// Groups connection elements by their bank ID.
  ///
  /// [connectionData] The Connection object containing the connections to group.
  /// Returns a Map where keys are bank IDs and values are lists of connections for that bank.
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

  /// Updates the active status of a connection via the API.
  ///
  /// [connectionId] The unique identifier of the connection to update.
  /// [clientId] The unique identifier of the client who owns the connection.
  /// [status] The new status (true for active, false for inactive).
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
        // Check if mounted before showing a SnackBar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update connection status')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error updating connection status: $e');
      // Check if mounted before showing a SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
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

  /// Builds the main content of the connections screen.
  ///
  /// [connectionData] The Connection object containing all the client's connections.
  /// Returns a widget tree representing the UI for the connections screen.
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
      AppColors.primaryColor60,
      AppColors.primaryColor70,
      AppColors.primaryColor80,
      AppColors.primaryColor90,
    ];

    int colorIndex = 0;
    double totalAmount = 0;

    for (var entry in groupedConnections.entries) {
      final bankConnections = entry.value;
      // Only include active connections in the chart total
      double bankTotal = bankConnections
          .where((connection) => connection.isActive == true)
          .fold(0, (sum, connection) => sum + (connection.connectionAmount ?? 0));

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
                            setState(() {
                              for (var conn in entry.value) {
                                conn.isActive = newValue;
                              }
                              _futureConnectionData = Future.value(connectionData);
                            });

                            // Make the API call to update account status on the backend
                            for (var conn in entry.value) {
                              _updateConnectionStatus(conn.connectionId!, widget.clientID, newValue);
                            }
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
