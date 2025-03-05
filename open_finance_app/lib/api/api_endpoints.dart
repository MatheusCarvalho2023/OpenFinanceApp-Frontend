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

  // endpoints for assets_details_screen.dart
  static String assetsDetails(int clientID) {
    return '$baseUrl/clients/$clientID/AssetsDetails';
  }
}
