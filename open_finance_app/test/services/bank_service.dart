import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:open_finance_app/services/bank_service.dart';
import 'package:open_finance_app/models/bank_model.dart';

void main() {
  group('BankService', () {
    test('fetchBanks returns list of Bank on 200 status', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        final banksJson = jsonEncode([
          {"bankName": "TD Bank", "logo": null, "bankID": 1},
          {"bankName": "RBC", "logo": null, "bankID": 2}
        ]);
        return http.Response(banksJson, 200);
      });

      final service = BankService(client: mockClient);

      // Act
      final banks = await service.fetchBanks();

      // Assert
      expect(banks, isA<List<Bank>>());
      expect(banks.length, 2);
      expect(banks.first.name, 'TD Bank');
      expect(banks.last.bankId, 2);
    });

    test('fetchBanks throws exception on non-200, returns fallback data',
        () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final service = BankService(client: mockClient);

      // Act
      final banks = await service.fetchBanks();

      // Assert
      // The fallback data includes RBC, TD, Scotiabank
      expect(banks.length, 3);
      expect(banks.first.name, 'Royal Bank of Canada');
    });
  });
}
