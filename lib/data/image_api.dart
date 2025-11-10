import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../core/failure.dart';

class ImageApi {
  static const _endpoint =
      'https://november7-730026606190.europe-west1.run.app/image';

  final http.Client _client;
  ImageApi({http.Client? client}) : _client = client ?? http.Client();
  Future<Map<String, dynamic>> getRandomImageJson() async {
    try {
      final uri = Uri.parse(_endpoint);
      final res = await _client
          .get(uri, headers: {HttpHeaders.acceptHeader: 'application/json'})
          .timeout(const Duration(seconds: 12));

      if (res.statusCode != 200) {
        throw Failure('Server error', statusCode: res.statusCode, cause: res.body);
      }

      final body = res.body;
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Unexpected JSON shape');
      }
      return decoded;
    } on FormatException catch (e, st) {
      throw Failure('Invalid response format', cause: e)..toString();
    } on Failure {
      rethrow;
    } on SocketException catch (e) {
      throw Failure('Network error: check connection', cause: e);
    } on HttpException catch (e) {
      throw Failure('HTTP error', cause: e);
    } on TimeoutException catch (e) {
      throw Failure('Request timed out', cause: e);
    } catch (e) {
      throw Failure('Unknown error', cause: e);
    }
  }
}
