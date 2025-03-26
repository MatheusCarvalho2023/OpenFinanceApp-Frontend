import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:open_finance_app/api/api_endpoints.dart';
import 'package:open_finance_app/models/bank_model.dart';

/// Service class responsible for fetching bank data from the API.
///
/// This service handles the communication with the backend API to retrieve
/// information about available banks that users can connect to in the application.
class BankService {
  /// Fetches the list of available banks from the API.
  ///
  /// Makes a GET request to the banks endpoint and parses the response into
  /// a list of [Bank] objects. If the API call fails for any reason, returns
  /// a fallback list of common banks to ensure the UI can still function.
  ///
  /// Returns a Future that resolves to a List of [Bank] objects.
  ///
  /// Throws an Exception with a descriptive message if the API returns
  /// a non-200 status code, but catches and handles any network or parsing errors.
  Future<List<Bank>> fetchBanks() async {
    try {
      final url = Uri.parse(ApiEndpoints.banks);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> banksJson = jsonDecode(response.body);
        return banksJson.map((bank) => Bank.fromJson(bank)).toList();
      } else {
        throw Exception('Failed to load banks: ${response.statusCode}');
      }
    } catch (e) {
      // Return fallback data if API fails
      return [
        Bank(name: 'Royal Bank of Canada', logo: null, bankId: 3),
        Bank(name: 'TD Bank', logo: null, bankId: 1),
        Bank(name: 'Scotiabank', logo: null, bankId: 2),
      ];
    }
  }
}