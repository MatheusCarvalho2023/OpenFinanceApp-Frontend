/// Provides methods to fetch bank data from the backend API.
/// This service handles communication with the API to retrieve
/// information about banks that users can connect to.
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:open_finance_app/api/api_endpoints.dart';
import 'package:open_finance_app/models/bank_model.dart';

class BankService {
  /// An instance of [http.Client] used to perform HTTP requests.
  /// This is injected for easier testing and flexibility.
  final http.Client client;

  /// Creates a [BankService] instance.
  ///
  /// If no [client] is provided, a default [http.Client] is used.
  BankService({http.Client? client}) : client = client ?? http.Client();

  /// Fetches the list of available banks from the API.
  ///
  /// Returns a [Future] that resolves to a list of [Bank] objects on success.
  /// If the API call fails, it returns a fallback list of common banks.
  Future<List<Bank>> fetchBanks() async {
    try {
      final url = Uri.parse(ApiEndpoints.banks);
      final response = await client.get(url);

      // If response status is OK, parse and return bank data.
      if (response.statusCode == 200) {
        final List<dynamic> banksJson = jsonDecode(response.body);
        return banksJson.map((bank) => Bank.fromJson(bank)).toList();
      } else {
        // Throw an exception if the response status is not OK.
        throw Exception('Failed to load banks: ${response.statusCode}');
      }
    } catch (e) {
      // Return fallback bank data in case of any network or parsing error.
      return [
        Bank(name: 'Royal Bank of Canada', logo: null, bankId: 3),
        Bank(name: 'TD Bank', logo: null, bankId: 1),
        Bank(name: 'Scotiabank', logo: null, bankId: 2),
      ];
    }
  }
}
