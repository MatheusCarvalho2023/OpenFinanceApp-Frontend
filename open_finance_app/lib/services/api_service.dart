import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:open_finance_app/api/api_endpoints.dart';
import 'package:open_finance_app/models/connection_model.dart';
import 'package:open_finance_app/models/profit_report_model.dart';
import 'package:open_finance_app/models/statement_model.dart';
import 'package:open_finance_app/models/summary_model.dart';
import 'package:open_finance_app/models/assets_model.dart';
import 'package:open_finance_app/models/assets_details_model.dart';

class ApiService {
  // Singleton instance of ApiService
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Generic method to handle API responses
  void _handleResponse(http.Response response, String errorMessage) {
    if (response.statusCode != 200) {
      throw Exception(
          '$errorMessage: ${response.statusCode} - ${response.body}');
    }
  }

  // Fetch Profit Report
  Future<ProfitReport> fetchProfitReport(int clientID) async {
    final url = Uri.parse(ApiEndpoints.profitReport(clientID));

    try {
      final response = await http.get(url);
      _handleResponse(response, 'Failed to load profit report data');
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return ProfitReport.fromJson(decoded);
    } catch (e) {
      throw Exception('Error fetching profit report data: $e');
    }
  }

  /// Fetch connections for pie chart
  Future<Connection> fetchConnections(int clientID) async {
    final url = Uri.parse(ApiEndpoints.connections(clientID));
    final response = await http.get(url);
    _handleResponse(response, 'Failed to load connections data');

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return Connection.fromJson(decoded);
  }

  // Fetch Summary Data
  Future<SummaryData> fetchSummary(int clientID) async {
    final url = Uri.parse(ApiEndpoints.portfolioTotalAmount(clientID));
    try {
      final response = await http.get(url);
      _handleResponse(response, 'Failed to load summary data');
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return SummaryData.fromJson(decoded);
    } catch (e) {
      throw Exception('Error fetching summary data: $e');
    }
  }

  // Fetch Assets Summary
  Future<AssetsSummary> fetchAssetsSummary(int clientID) async {
    final url = Uri.parse(ApiEndpoints.assetsSummary(clientID));
    try {
      final response = await http.get(url);
      _handleResponse(response, 'Failed to load assets data');
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return AssetsSummary.fromJson(decoded);
    } catch (e) {
      throw Exception('Error fetching assets data: $e');
    }
  }

  // Fetch Assets Details
  Future<AssetsDetails> fetchAssetsDetails(int clientID) async {
    final url = Uri.parse(ApiEndpoints.assetsDetails(clientID));
    try {
      final response = await http.get(url);
      _handleResponse(response, 'Failed to load asset details');
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return AssetsDetails.fromJson(decoded);
    } catch (e) {
      throw Exception('Error fetching asset details: $e');
    }
  }

  // Fetch Statements
  Future<ClientStatement> fetchStatements(int clientID) async {
    final url = Uri.parse(ApiEndpoints.statements(clientID));
    try {
      final response = await http.get(url);
      _handleResponse(response, 'Failed to load statements data');
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return ClientStatement.fromJson(decoded);
    } catch (e) {
      throw Exception('Error fetching statements data: $e');
    }
  }
}
