import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

// Import all model files to be tested.
import 'package:open_finance_app/models/assets_details_model.dart';
import 'package:open_finance_app/models/assets_model.dart';
import 'package:open_finance_app/models/bank_model.dart';
import 'package:open_finance_app/models/client_model.dart';
import 'package:open_finance_app/models/connection_model.dart';
import 'package:open_finance_app/models/profit_report_model.dart';
import 'package:open_finance_app/models/statement_model.dart';
import 'package:open_finance_app/models/summary_model.dart';

/// Group of tests for verifying the correct JSON parsing
/// and serialization for all models in the application.
void main() {
  group('Model Tests', () {
    // Test AssetsDetails.fromJson: Given valid JSON, it should return a correctly parsed AssetsDetails object.
    test('AssetsDetails_fromJson_ValidJson_ReturnsAssetsDetailsObject', () {
      final jsonMap = {
        "clientID": 1,
        "numProducts": 2,
        "totalAmount": 1500.5,
        "products": [
          {
            "productName": "Stock",
            "numItems": 10,
            "productTotalAmount": 1000.0,
            "portfolioPercentage": 66.67,
            "productTotalAmountInvested": 900.0,
            "productTotalProfitLoss": 100.0,
            "productTotalProfitLossPercentage": 11.11,
            "items": [
              {
                "itemName": "AAPL",
                "itemID": 101,
                "itemQuantity": 5,
                "itemLastPrice": 200.0,
                "itemAveragePrice": 190.0,
                "itemAmount": 1000.0,
                "itemAmountInvested": 950.0,
                "itemProfitLoss": 50.0,
                "itemProfitLossPercentage": 5.26,
                "portfolioPercentage": 50.0
              }
            ]
          }
        ],
        "timestamp": "2025-03-27T12:00:00Z"
      };

      final assetsDetails = AssetsDetails.fromJson(jsonMap);

      // Verify top-level properties.
      expect(assetsDetails.clientID, 1);
      expect(assetsDetails.numProducts, 2);
      expect(assetsDetails.totalAmount, 1500.5);
      expect(assetsDetails.products.length, 1);

      // Verify nested product data.
      final product = assetsDetails.products.first;
      expect(product.productName, "Stock");
      expect(product.numItems, 10);
      expect(product.productTotalAmount, 1000.0);

      // Verify nested item data.
      expect(product.items.length, 1);
      final item = product.items.first;
      expect(item.itemName, "AAPL");
      expect(item.itemID, 101);
      expect(item.itemQuantity, 5);
      expect(item.itemLastPrice, 200.0);
      expect(item.itemProfitLoss, 50.0);
    });

    // Test AssetsSummary.fromJson: Given valid JSON, it should return a properly parsed AssetsSummary object.
    test('AssetsSummary_fromJson_ValidJson_ReturnsAssetsSummaryObject', () {
      final jsonMap = {
        "clientID": 2,
        "numProducts": 3,
        "totalAmount": 2500.0,
        "timestamp": "2025-03-27T12:00:00Z",
        "productDetails": [
          {
            "productName": "Mutual Fund",
            "prodTotal": 1500.0,
            "portfolioPercentage": 60.0
          },
          {
            "productName": "Bond",
            "prodTotal": 1000.0,
            "portfolioPercentage": 40.0
          }
        ]
      };

      final assetsSummary = AssetsSummary.fromJson(jsonMap);
      expect(assetsSummary.clientID, 2);
      expect(assetsSummary.numProducts, 3);
      expect(assetsSummary.totalAmount, 2500.0);
      expect(assetsSummary.productDetails.length, 2);
      expect(assetsSummary.productDetails[0].productName, "Mutual Fund");
      expect(assetsSummary.productDetails[1].prodTotal, 1000.0);
    });

    // Test Bank.fromJson and toJson: Validate that parsing and serialization work as expected.
    test('Bank_fromJsonAndToJson_ValidJson_ReturnsCorrectBankObject', () {
      final jsonMap = {"bankName": "TD Bank", "logo": null, "bankID": 1};

      final bank = Bank.fromJson(jsonMap);
      expect(bank.name, "TD Bank");
      expect(bank.bankId, 1);

      final toJson = bank.toJson();
      expect(toJson['name'], "TD Bank");
      expect(toJson['bankID'], 1);
    });

    // Test Client.fromJson and toJson: Ensure a client's data is parsed and serialized properly.
    test('Client_fromJsonAndToJson_ValidJson_ReturnsCorrectClientObject', () {
      final jsonMap = {
        "clientID": 1,
        "clientName": "John Doe",
        "clientEmail": "john@example.com",
        "clientAddress": "123 Main St"
      };

      final client = Client.fromJson(jsonMap);
      expect(client.clientId, 1);
      expect(client.clientName, "John Doe");
      expect(client.clientEmail, "john@example.com");
      expect(client.clientAddress, "123 Main St");

      final toJson = client.toJson();
      expect(toJson["clientID"], 1);
      expect(toJson["clientName"], "John Doe");
    });

    // Test Connection.fromJson: Verify that connection data is parsed correctly.
    test('Connection_fromJson_ValidJson_ReturnsCorrectConnectionObject', () {
      final jsonMap = {
        "clientID": 1,
        "numConnections": 2,
        "totalAmount": 5000.0,
        "connections": [
          {
            "bankName": "RBC",
            "bankID": 2,
            "accountNumber": 123456,
            "connectionID": 10,
            "connectionAmount": 3000.0,
            "connectionPercentage": 60.0,
            "isActive": true
          }
        ],
        "timestamp": "2025-03-27T12:00:00Z"
      };

      final connection = Connection.fromJson(jsonMap);
      expect(connection.clientId, 1);
      expect(connection.numConnections, 2);
      expect(connection.totalAmount, 5000.0);
      expect(connection.connections.length, 1);
      final element = connection.connections.first;
      expect(element.bankName, "RBC");
      expect(element.accountNumber, 123456);
      expect(element.connectionAmount, 3000.0);
    });

    // Test ProfitReport.fromJson: Ensure monthly profit data is parsed as expected.
    test('ProfitReport_fromJson_ValidJson_ReturnsCorrectProfitReportObject',
        () {
      final jsonMap = {
        "clientID": 1,
        "profitReportByMonth": [
          {
            "ReportPeriod": "02-2025",
            "totalAmountInvested": 2000,
            "totalAmount": 2200,
            "totalProfitLoss": 200,
            "totalProfitLossPercentage": 10
          }
        ],
        "timestamp": "2025-03-27T12:00:00Z"
      };

      final profitReport = ProfitReport.fromJson(jsonMap);
      expect(profitReport.clientID, 1);
      expect(profitReport.profitReportByMonth.length, 1);
      expect(profitReport.profitReportByMonth.first.reportPeriod, "02-2025");
      expect(profitReport.profitReportByMonth.first.totalProfitLoss, 200);
    });

    // Test ClientStatement.fromJson: Verify that a client's statement (with monthly transactions) is parsed correctly.
    test(
        'ClientStatement_fromJson_ValidJson_ReturnsCorrectClientStatementObject',
        () {
      final jsonMap = {
        "clientID": 1,
        "statement": [
          {
            "month": "March",
            "transactions": [
              {
                "transactionID": 101,
                "connectionID": 1,
                "transactionType": "Buy",
                "transactionDirection": "Debit",
                "assetName": "AAPL",
                "transactionDate": "2025-03-15T10:00:00Z",
                "transactionAmount": 500.0
              }
            ]
          }
        ],
        "timestamp": "2025-03-27T12:00:00Z"
      };

      final statement = ClientStatement.fromJson(jsonMap);
      expect(statement.clientID, 1);
      expect(statement.statement.length, 1);
      expect(statement.statement.first.month, "March");
      expect(
          statement.statement.first.transactions.first.transactionType, "Buy");
    });

    // Test SummaryData.fromJson: Ensure that overall summary data is parsed correctly.
    test('SummaryData_fromJson_ValidJson_ReturnsCorrectSummaryDataObject', () {
      final jsonMap = {
        "clientID": 1,
        "totalAmount": 3000.0,
        "timestamp": "2025-03-27T12:00:00Z",
        "productTotals": [
          {"product": "Cash", "total": 1000.0},
          {"product": "Stock", "total": 2000.0}
        ]
      };

      final summaryData = SummaryData.fromJson(jsonMap);
      expect(summaryData.clientID, 1);
      expect(summaryData.totalAmount, 3000.0);
      expect(summaryData.productTotals.length, 2);
      expect(summaryData.productTotals.first.product, "Cash");
      expect(summaryData.productTotals.last.total, 2000.0);
    });
  });
}
