import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:open_finance_app/services/api_service.dart';
import 'package:open_finance_app/models/profit_report_model.dart';
import 'package:open_finance_app/models/connection_model.dart';
import 'package:open_finance_app/models/summary_model.dart';
import 'package:open_finance_app/models/assets_model.dart';
import 'package:open_finance_app/models/assets_details_model.dart';
import 'package:open_finance_app/models/statement_model.dart';

void main() {
  group('ApiService', () {
    test('fetchProfitReport returns a valid ProfitReport on success', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        final jsonMap = {
          "clientID": 1,
          "profitReportByMonth": [
            {
              "ReportPeriod": "01-2025",
              "totalAmountInvested": 1000,
              "totalAmount": 1100,
              "totalProfitLoss": 100,
              "totalProfitLossPercentage": 10
            }
          ],
          "timestamp": "2025-03-27T12:00:00Z"
        };
        return http.Response(jsonEncode(jsonMap), 200);
      });

      final apiService = ApiService(client: mockClient);

      // Act
      final report = await apiService.fetchProfitReport(1);

      // Assert
      expect(report, isA<ProfitReport>());
      expect(report.clientID, 1);
      expect(report.profitReportByMonth.length, 1);
      expect(report.profitReportByMonth.first.reportPeriod, "01-2025");
    });

    test('fetchProfitReport throws exception on non-200 status', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });
      final apiService = ApiService(client: mockClient);

      // Act & Assert
      expect(
        () async => await apiService.fetchProfitReport(1),
        throwsException,
      );
    });

    test('fetchConnections returns a valid Connection on success', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        final jsonMap = {
          "clientID": 1,
          "numConnections": 2,
          "totalAmount": 29543.64,
          "connections": [
            {
              "bankName": "Royal Bank of Canada",
              "bankID": 3,
              "accountNumber": 1234567,
              "connectionID": 1,
              "connectionAmount": 25654.51,
              "connectionPercentage": 86.84,
              "isActive": true
            }
          ],
          "timestamp": "2025-03-04T19:26:17.0764209Z"
        };
        return http.Response(jsonEncode(jsonMap), 200);
      });
      final apiService = ApiService(client: mockClient);

      // Act
      final connection = await apiService.fetchConnections(1);

      // Assert
      expect(connection, isA<Connection>());
      expect(connection.clientId, 1);
      expect(connection.connections.length, 1);
      expect(connection.connections.first.bankName, "Royal Bank of Canada");
    });

    test('fetchSummary returns SummaryData on success', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        final jsonMap = {
          "clientID": 1,
          "totalAmount": 10000.0,
          "timestamp": "2025-03-27T12:00:00Z",
          "productTotals": [
            {"product": "Stock", "total": 8000.0}
          ]
        };
        return http.Response(jsonEncode(jsonMap), 200);
      });
      final apiService = ApiService(client: mockClient);

      // Act
      final summary = await apiService.fetchSummary(1);

      // Assert
      expect(summary, isA<SummaryData>());
      expect(summary.clientID, 1);
      expect(summary.productTotals.first.product, "Stock");
      expect(summary.productTotals.first.total, 8000.0);
    });

    test('fetchAssetsSummary returns AssetsSummary on success', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        final jsonMap = {
          "clientID": 1,
          "numProducts": 2,
          "totalAmount": 1500.5,
          "timestamp": "2025-03-27T12:00:00Z",
          "productDetails": [
            {
              "productName": "Mutual Fund",
              "prodTotal": 1000.0,
              "portfolioPercentage": 66.7
            }
          ]
        };
        return http.Response(jsonEncode(jsonMap), 200);
      });
      final apiService = ApiService(client: mockClient);

      // Act
      final assetsSummary = await apiService.fetchAssetsSummary(1);

      // Assert
      expect(assetsSummary, isA<AssetsSummary>());
      expect(assetsSummary.clientID, 1);
      expect(assetsSummary.numProducts, 2);
      expect(assetsSummary.productDetails.first.productName, "Mutual Fund");
    });

    test('fetchAssetsDetails returns AssetsDetails on success', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        final jsonMap = {
          "clientID": 1,
          "numProducts": 1,
          "totalAmount": 2000.0,
          "products": [
            {
              "productName": "Stock",
              "numItems": 2,
              "productTotalAmount": 2000.0,
              "portfolioPercentage": 100.0,
              "productTotalAmountInvested": 1500.0,
              "productTotalProfitLoss": 500.0,
              "productTotalProfitLossPercentage": 33.3,
              "items": []
            }
          ],
          "timestamp": "2025-03-27T12:00:00Z"
        };
        return http.Response(jsonEncode(jsonMap), 200);
      });
      final apiService = ApiService(client: mockClient);

      // Act
      final assetsDetails = await apiService.fetchAssetsDetails(1);

      // Assert
      expect(assetsDetails, isA<AssetsDetails>());
      expect(assetsDetails.clientID, 1);
      expect(assetsDetails.numProducts, 1);
      expect(assetsDetails.products.first.productName, "Stock");
    });

    test('fetchStatements returns ClientStatement on success', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        final jsonMap = {
          "clientID": 1,
          "statement": [
            {
              "month": "March",
              "transactions": [
                {
                  "transactionID": 100,
                  "connectionID": 1,
                  "transactionType": "Buy",
                  "transactionDirection": "Debit",
                  "assetName": "AAPL",
                  "transactionDate": "2025-03-10T10:00:00Z",
                  "transactionAmount": 500.0
                }
              ]
            }
          ],
          "timestamp": "2025-03-27T12:00:00Z"
        };
        return http.Response(jsonEncode(jsonMap), 200);
      });
      final apiService = ApiService(client: mockClient);

      // Act
      final statements = await apiService.fetchStatements(1);

      // Assert
      expect(statements, isA<ClientStatement>());
      expect(statements.clientID, 1);
      expect(statements.statement.first.month, "March");
      expect(
          statements.statement.first.transactions.first.transactionType, "Buy");
    });
  });
}
