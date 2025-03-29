import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:open_finance_app/services/bank_service.dart';
import 'package:open_finance_app/models/bank_model.dart';

/// Group of tests for verifying the BankService methods.
void main() {
  group('BankService', () {
    /// Test: fetchBanks_ValidResponse_ReturnsListOfBanks
    /// Given a valid JSON response (HTTP 200) from the API,
    /// the fetchBanks method should return a list of Bank objects.
    test('fetchBanks_ValidResponse_ReturnsListOfBanks', () async {
      // Arrange: Create a mock HTTP client that returns sample bank JSON data.
      final mockClient = MockClient((request) async {
        final banksJson = jsonEncode([
          {"bankName": "TD Bank", "logo": null, "bankID": 1},
          {"bankName": "RBC", "logo": null, "bankID": 2}
        ]);
        return http.Response(banksJson, 200);
      });
      final service = BankService(client: mockClient);

      // Act: Fetch banks.
      final banks = await service.fetchBanks();

      // Assert: Verify that the list of banks is correctly returned.
      expect(banks, isA<List<Bank>>());
      expect(banks.length, 2);
      expect(banks.first.name, 'TD Bank');
      expect(banks.last.bankId, 2);
    });

    /// Test: fetchBanks_Non200Response_ReturnsFallbackData
    /// Given a non-200 HTTP response, fetchBanks should return fallback bank data.
    test('fetchBanks_Non200Response_ReturnsFallbackData', () async {
      // Arrange: Create a mock client simulating a non-200 response.
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });
      final service = BankService(client: mockClient);

      // Act: Fetch banks.
      final banks = await service.fetchBanks();

      // Assert: Verify that fallback data is returned (fallback list has 3 banks).
      expect(banks.length, 3);
      expect(banks.first.name, 'Royal Bank of Canada');
    });
  });
}
