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

/// Group of tests for verifying the ApiService methods.
/// Each test is named using the pattern: Method_Input_ExpectedResult.
void main() {
  group('ApiService', () {
    /// Test: fetchProfitReport_ValidClientID_ReturnsProfitReport
    /// Given a valid clientID and a successful (200) HTTP response containing profit report JSON,
    /// the fetchProfitReport method should return a properly parsed ProfitReport object.
    test('fetchProfitReport_ValidClientID_ReturnsProfitReport', () async {
      // Arrange: Set up a mock HTTP client with sample JSON data.
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

      // Act: Call fetchProfitReport with a valid client ID.
      final report = await apiService.fetchProfitReport(1);

      // Assert: Verify that the returned ProfitReport is correct.
      expect(report, isA<ProfitReport>());
      expect(report.clientID, 1);
      expect(report.profitReportByMonth.length, 1);
      expect(report.profitReportByMonth.first.reportPeriod, "01-2025");
    });

    /// Test: fetchProfitReport_Non200Status_ThrowsException
    /// Given a non-200 HTTP response, the fetchProfitReport method should throw an exception.
    test('fetchProfitReport_Non200Status_ThrowsException', () async {
      // Arrange: Create a mock client that simulates a 500 Server Error response.
      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });
      final apiService = ApiService(client: mockClient);

      // Act & Assert: Expect that calling fetchProfitReport throws an exception.
      expect(
        () async => await apiService.fetchProfitReport(1),
        throwsException,
      );
    });

    /// Test: fetchConnections_ValidClientID_ReturnsConnection
    /// Given valid clientID and a successful response containing connection JSON,
    /// the fetchConnections method should return a properly parsed Connection object.
    test('fetchConnections_ValidClientID_ReturnsConnection', () async {
      // Arrange: Provide sample JSON for connections.
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

      // Act: Fetch connections for clientID 1.
      final connection = await apiService.fetchConnections(1);

      // Assert: Verify that the Connection object is correct.
      expect(connection, isA<Connection>());
      expect(connection.clientId, 1);
      expect(connection.connections.length, 1);
      expect(connection.connections.first.bankName, "Royal Bank of Canada");
    });

    /// Test: fetchSummary_ValidClientID_ReturnsSummaryData
    /// Given a valid summary JSON response, fetchSummary should return a correctly parsed SummaryData object.
    test('fetchSummary_ValidClientID_ReturnsSummaryData', () async {
      // Arrange: Sample JSON for summary data.
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

      // Act: Call fetchSummary.
      final summary = await apiService.fetchSummary(1);

      // Assert: Verify that the SummaryData object contains expected values.
      expect(summary, isA<SummaryData>());
      expect(summary.clientID, 1);
      expect(summary.productTotals.first.product, "Stock");
      expect(summary.productTotals.first.total, 8000.0);
    });

    /// Test: fetchAssetsSummary_ValidClientID_ReturnsAssetsSummary
    /// Given valid JSON for asset summary, fetchAssetsSummary should return an AssetsSummary object with expected data.
    test('fetchAssetsSummary_ValidClientID_ReturnsAssetsSummary', () async {
      // Arrange: Provide sample JSON data for asset summary.
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

      // Act: Fetch asset summary.
      final assetsSummary = await apiService.fetchAssetsSummary(1);

      // Assert: Verify the returned AssetsSummary data.
      expect(assetsSummary, isA<AssetsSummary>());
      expect(assetsSummary.clientID, 1);
      expect(assetsSummary.numProducts, 2);
      expect(assetsSummary.productDetails.first.productName, "Mutual Fund");
    });

    /// Test: fetchAssetsDetails_ValidClientID_ReturnsAssetsDetails
    /// Given valid JSON for asset details, fetchAssetsDetails should return an AssetsDetails object.
    test('fetchAssetsDetails_ValidClientID_ReturnsAssetsDetails', () async {
      // Arrange: Provide sample JSON for asset details.
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

      // Act: Fetch asset details.
      final assetsDetails = await apiService.fetchAssetsDetails(1);

      // Assert: Verify the returned AssetsDetails.
      expect(assetsDetails, isA<AssetsDetails>());
      expect(assetsDetails.clientID, 1);
      expect(assetsDetails.numProducts, 1);
      expect(assetsDetails.products.first.productName, "Stock");
    });

    /// Test: fetchStatements_ValidClientID_ReturnsClientStatement
    /// Given valid JSON for statements, fetchStatements should return a ClientStatement object.
    test('fetchStatements_ValidClientID_ReturnsClientStatement', () async {
      // Arrange: Provide sample JSON for client statements.
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

      // Act: Fetch statements.
      final statements = await apiService.fetchStatements(1);

      // Assert: Verify that the returned ClientStatement is as expected.
      expect(statements, isA<ClientStatement>());
      expect(statements.clientID, 1);
      expect(statements.statement.first.month, "March");
      expect(
          statements.statement.first.transactions.first.transactionType, "Buy");
    });
  });
}
