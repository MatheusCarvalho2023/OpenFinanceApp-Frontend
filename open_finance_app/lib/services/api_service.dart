import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:open_finance_app/api/api_endpoints.dart';
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
}
