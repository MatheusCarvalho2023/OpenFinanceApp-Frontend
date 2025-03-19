class ApiEndpoints {
  static const String baseUrl =
      'http://openfinance.us-east-1.elasticbeanstalk.com';

  static const String login = '$baseUrl/authentication/login';
  static const String signup = '$baseUrl/authentication/signup';
  static String banks = '$baseUrl/bankslist';
  static String addConnection = '$baseUrl/clients/AddNewConnection';

  // endpoints for assets_screen.dart
  static String assetsSummary(int clientID) {
    return '$baseUrl/clients/$clientID/AssetsSummary';
  }

  // endpoints for summary_screen.dart
  static String portfolioTotalAmount(int clientID) {
    return '$baseUrl/clients/$clientID/PortfolioTotalAmount';
  }

  // endpoints for connections_screen.dart
  static String connections(int clientID) {
    return '$baseUrl/clients/$clientID/GetAllConnections';
  }
  static String updateConnection() {
    return '$baseUrl/clients/EnableDisableConnection';
  // {
  // "clientID": 1,
  // "connectionID": 1,
  // "status": true
  // }
  }
}
