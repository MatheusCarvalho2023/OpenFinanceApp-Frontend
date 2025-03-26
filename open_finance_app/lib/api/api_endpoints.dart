/// A utility class that provides API endpoint URLs for the OpenFinance application.
///
/// This class contains static methods and constants that represent the various
/// API endpoints used throughout the application, organized by feature or screen.
class ApiEndpoints {
  /// Base URL for all API endpoints
  static const String baseUrl =
      'http://openfinance.us-east-1.elasticbeanstalk.com';

  /// Endpoint for user authentication (login)
  static const String login = '$baseUrl/authentication/login';
  
  /// Endpoint for user registration
  static const String signup = '$baseUrl/authentication/signup';
  
  /// Endpoint to retrieve list of supported banks
  static String banks = '$baseUrl/bankslist';
  
  /// Endpoint to add a new financial connection
  static String addConnection = '$baseUrl/clients/AddNewConnection';

  /// Returns the endpoint URL to fetch assets summary for a specific client
  ///
  /// [clientID] The unique identifier for the client
  static String assetsSummary(int clientID) {
    return '$baseUrl/clients/$clientID/AssetsSummary';
  }

  /// Returns the endpoint URL to fetch total portfolio amount for a specific client
  ///
  /// [clientID] The unique identifier for the client
  static String portfolioTotalAmount(int clientID) {
    return '$baseUrl/clients/$clientID/PortfolioTotalAmount';
  }

  /// Returns the endpoint URL to fetch client profile data
  ///
  /// [clientID] The unique identifier for the client
  static String getClientData(int clientID) {
    return '$baseUrl/clients/$clientID/ClientProfile';
  }

  /// Returns the endpoint URL to update client profile data
  static String updateClientData() {
    return '$baseUrl/clients/ClientProfile';
  }

  /// Returns the endpoint URL to fetch all financial connections for a client
  ///
  /// [clientID] The unique identifier for the client
  static String connections(int clientID) {
    return '$baseUrl/clients/$clientID/GetAllConnections';
  }

  /// Returns the endpoint URL to enable or disable a financial connection
  static String updateStatusConnection() {
    return '$baseUrl/clients/EnableDisableConnection';
  }

  /// Returns the endpoint URL to fetch detailed asset information for a client
  ///
  /// [clientID] The unique identifier for the client
  static String assetsDetails(int clientID) {
    return '$baseUrl/clients/$clientID/AssetsDetails';
  }

  /// Returns the endpoint URL to fetch client statements
  ///
  /// [clientID] The unique identifier for the client
  static String statements(int clientID) {
    return '$baseUrl/statement/$clientID/ClientStatement';
  }

  /// Returns the endpoint URL to fetch profit reports for a client
  ///
  /// [clientID] The unique identifier for the client
  static String profitReport(int clientID) {
    return '$baseUrl/report/$clientID/ProfitReport';
  }
}
