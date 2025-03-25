import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:open_finance_app/api/api_endpoints.dart';
import 'package:open_finance_app/models/bank_model.dart';

class BankService {
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