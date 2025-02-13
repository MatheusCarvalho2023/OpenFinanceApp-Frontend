class ApiEndpoints {
  static const String baseUrl = 'http://10.0.2.2:5280';

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
}
