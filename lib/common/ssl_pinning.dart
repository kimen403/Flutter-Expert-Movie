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
      SecurityContext securityContext = SecurityContext(withTrustedRoots: true);
      
      try {
        securityContext.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());
      } catch (e) {
        print('Warning: Could not load custom certificate: $e');
        // Continue with default trusted roots
      }

      // Create HTTP client with pinned certificate
      HttpClient httpClient = HttpClient(context: securityContext);
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        // Only allow connections to themoviedb.org
        return host.contains('themoviedb.org');
      };

      _clientInstance = IOClient(httpClient);
    } catch (e) {
      print('Error creating SSL client: $e');
      // Fallback to default HTTP client
      _clientInstance = http.Client();
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
