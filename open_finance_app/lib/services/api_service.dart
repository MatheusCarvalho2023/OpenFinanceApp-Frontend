/// Provides various API methods to fetch data such as profit reports,
/// connections, summary data, assets, and statements for a given client.
///
/// This class uses dependency injection for the HTTP client, which makes testing easier.
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
  /// The HTTP client used for making API calls.
  final http.Client client;

  /// Creates an [ApiService] instance.
  ///
  /// If no [client] is provided, a default [http.Client] is used.
  ApiService({http.Client? client}) : client = client ?? http.Client();

  /// A generic method to handle API responses.
  ///
  /// Throws an exception with [errorMessage] if the [response]'s status is not 200.
  void _handleResponse(http.Response response, String errorMessage) {
    if (response.statusCode != 200) {
      throw Exception(
          '$errorMessage: ${response.statusCode} - ${response.body}');
    }
  }

  /// Fetches the profit report for a client identified by [clientID].
  ///
  /// Returns a [Future] that resolves to a [ProfitReport] object.
  Future<ProfitReport> fetchProfitReport(int clientID) async {
    final url = Uri.parse(ApiEndpoints.profitReport(clientID));
    try {
      final response = await client.get(url);
      _handleResponse(response, 'Failed to load profit report data');
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return ProfitReport.fromJson(decoded);
    } catch (e) {
      throw Exception('Error fetching profit report data: $e');
    }
  }

  /// Fetches the connection data (used for pie chart display) for the given [clientID].
  ///
  /// Returns a [Future] that resolves to a [Connection] object.
  Future<Connection> fetchConnections(int clientID) async {
    final url = Uri.parse(ApiEndpoints.connections(clientID));
    final response = await client.get(url);
    _handleResponse(response, 'Failed to load connections data');

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return Connection.fromJson(decoded);
  }

  /// Fetches the summary data (portfolio total amount) for a client.
  ///
  /// Returns a [Future] that resolves to a [SummaryData] object.
  Future<SummaryData> fetchSummary(int clientID) async {
    final url = Uri.parse(ApiEndpoints.portfolioTotalAmount(clientID));
    try {
      final response = await client.get(url);
      _handleResponse(response, 'Failed to load summary data');
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return SummaryData.fromJson(decoded);
    } catch (e) {
      throw Exception('Error fetching summary data: $e');
    }
  }

  /// Fetches the assets summary for a client.
  ///
  /// Returns a [Future] that resolves to an [AssetsSummary] object.
  Future<AssetsSummary> fetchAssetsSummary(int clientID) async {
    final url = Uri.parse(ApiEndpoints.assetsSummary(clientID));
    try {
      final response = await client.get(url);
      _handleResponse(response, 'Failed to load assets data');
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return AssetsSummary.fromJson(decoded);
    } catch (e) {
      throw Exception('Error fetching assets data: $e');
    }
  }

  /// Fetches the detailed asset information for a client.
  ///
  /// Returns a [Future] that resolves to an [AssetsDetails] object.
  Future<AssetsDetails> fetchAssetsDetails(int clientID) async {
    final url = Uri.parse(ApiEndpoints.assetsDetails(clientID));
    try {
      final response = await client.get(url);
      _handleResponse(response, 'Failed to load asset details');
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return AssetsDetails.fromJson(decoded);
    } catch (e) {
      throw Exception('Error fetching asset details: $e');
    }
  }

  /// Fetches the statements for a client.
  ///
  /// Returns a [Future] that resolves to a [ClientStatement] object.
  Future<ClientStatement> fetchStatements(int clientID) async {
    final url = Uri.parse(ApiEndpoints.statements(clientID));
    try {
      final response = await client.get(url);
      _handleResponse(response, 'Failed to load statements data');
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return ClientStatement.fromJson(decoded);
    } catch (e) {
      throw Exception('Error fetching statements data: $e');
    }
  }
}
