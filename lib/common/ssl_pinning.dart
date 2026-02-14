import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class SSLPinningHelper {
  static http.Client? _clientInstance;

  static Future<http.Client> createClient() async {
    if (_clientInstance != null) {
      return _clientInstance!;
    }

    try {
      // Load certificate
      final sslCert = await rootBundle.load('certificates/tmdb.pem');
      
      // Create SecurityContext with only our pinned certificate
      // withTrustedRoots: false means we don't trust system certificates
      SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
      
      // Set our trusted certificate
      securityContext.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());

      // Create HTTP client with pinned certificate
      HttpClient httpClient = HttpClient(context: securityContext);
      
      // Do not set badCertificateCallback - let the SecurityContext handle validation
      // If certificate doesn't match, connection will fail (which is what we want)

      _clientInstance = IOClient(httpClient);
    } catch (e) {
      print('Error creating SSL client: $e');
      // Re-throw the error instead of falling back to unsecured client
      rethrow;
    }

    return _clientInstance!;
  }

  static http.Client get client {
    if (_clientInstance == null) {
      throw Exception(
          'SSL Client not initialized. Call SSLPinningHelper.createClient() first.');
    }
    return _clientInstance!;
  }
}
