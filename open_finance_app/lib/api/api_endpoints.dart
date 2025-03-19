class ApiEndpoints {
  static const String baseUrl =
      'http://openfinance.us-east-1.elasticbeanstalk.com';

  static const String login = '$baseUrl/authentication/login';
  static const String signup = '$baseUrl/authentication/signup';

  // endpoints for assets_screen.dart
  static String assetsSummary(int clientID) {
    return '$baseUrl/clients/$clientID/AssetsSummary';
  }

  // endpoints for summary_screen.dart
  static String portfolioTotalAmount(int clientID) {
    return '$baseUrl/clients/$clientID/PortfolioTotalAmount';
  }

  /// Endpoints for profile screen
  // GET request to fetch client data
  static String getClientData(int clientID) {
    return '$baseUrl/clients/$clientID/ClientProfile';
  }

  // PATCH request to update client data
  static String updateClientData() {
    return '$baseUrl/clients/ClientProfile';
  }
}
