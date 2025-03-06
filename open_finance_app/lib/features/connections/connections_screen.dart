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

  Widget _buildConnectionsContent(
      Connection connectionData) {
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
      double bankTotal = bankConnections.fold(
          0, (sum, connection) => sum + (connection.connectionAmount ?? 0));

      totalAmount += bankTotal;

      chartData.add(ChartData(
        value: bankTotal,
        color: bankColors[colorIndex % bankColors.length],
      ));

      colorIndex++;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
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
                          totalAccountBalance: formattedBalance,
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
