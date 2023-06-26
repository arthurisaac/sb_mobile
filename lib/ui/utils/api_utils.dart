import 'package:jaguar_jwt/jaguar_jwt.dart';

import 'constants.dart';

class ApiUtils {
  static Map<String, String> getHeaders() => {
    "Authorization": 'Bearer ${_getJwtToken()}',
  };

  static String _getJwtToken() {
    final claimSet =
    JwtClaim(issuer: 'smartbox', expiry: DateTime.now().add(const Duration(/*days: 365*/ minutes: 1)), issuedAt: DateTime.now().toUtc());
    String token = issueJwtHS256(claimSet, jwtKey);
    return token;
  }
}